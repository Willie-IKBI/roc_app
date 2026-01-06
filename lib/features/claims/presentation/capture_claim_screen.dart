import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_place/google_place.dart';

import '../../../core/config/env.dart';
import '../../../core/errors/domain_error.dart';
import '../../../core/logging/logger.dart';
import '../../../core/providers/current_user_provider.dart';
import '../../../core/strings/app_strings.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/theme/roc_color_scheme.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/glass_dialog.dart';
import '../../../core/widgets/glass_input.dart';
import '../../../core/utils/places_web_service.dart';
import '../../../core/utils/validators.dart';
import '../../../data/repositories/claim_repository_supabase.dart';
import '../../../domain/models/claim_draft.dart';
import '../../../domain/value_objects/claim_enums.dart';
import '../../claims/controller/capture_controller.dart';
import '../../../domain/models/reference_option.dart';
import '../../reference_data/controller/reference_data_controller.dart';
import 'widgets/technician_selector.dart';
import 'widgets/appointment_picker.dart';

enum AddressMode { existing, newAddress }
enum AddressInputMode { search, manual, gps }

/// Helper function for capture claim field decoration - uses GlassInput
InputDecoration buildCaptureFieldDecoration(
  BuildContext context,
  String label, {
  String? hint,
}) {
  return GlassInput.decoration(
    context: context,
    label: label,
    hint: hint,
  );
}

class CaptureClaimScreen extends ConsumerStatefulWidget {
  const CaptureClaimScreen({super.key});

  @override
  ConsumerState<CaptureClaimScreen> createState() => _CaptureClaimScreenState();
}

class _CaptureClaimScreenState extends ConsumerState<CaptureClaimScreen> {
  final _formKey = GlobalKey<FormState>();

  final _claimNumberController = TextEditingController();
  final _notesController = TextEditingController();
  final _clientNotesController = TextEditingController();
  final _damageDescriptionController = TextEditingController();

  // Client controllers
  final _clientFirstNameController = TextEditingController();
  final _clientLastNameController = TextEditingController();
  final _clientPrimaryPhoneController = TextEditingController();
  final _clientAltPhoneController = TextEditingController();
  final _clientEmailController = TextEditingController();

  // Address controllers
  final _addressSearchController = TextEditingController();
  final _addressComplexController = TextEditingController();
  final _addressUnitController = TextEditingController();
  final _addressStreetController = TextEditingController();
  final _addressSuburbController = TextEditingController();
  final _addressCityController = TextEditingController();
  final _addressProvinceController = TextEditingController();
  final _addressPostalCodeController = TextEditingController();
  final _addressNotesController = TextEditingController();

  // Service provider controllers
  final _providerCompanyController = TextEditingController();
  final _providerContactNameController = TextEditingController();
  final _providerContactPhoneController = TextEditingController();
  final _providerContactEmailController = TextEditingController();
  final _providerReferenceController = TextEditingController();
  final _dasNumberController = TextEditingController();

  bool _surgeAtDb = false;
  bool _surgeAtPlug = false;
  String? _selectedInsurer;
  String? _selectedAddress;
  PriorityLevel _selectedPriority = PriorityLevel.normal;
  DamageCause _selectedDamageCause = DamageCause.other;

  AddressMode _addressMode = AddressMode.newAddress;
  AddressInputMode _addressInputMode = AddressInputMode.search;
  bool _includeServiceProvider = false;
  String? _selectedInsurerLabel;
  String? _selectedTechnicianId;
  DateTime? _selectedAppointmentDate;
  String? _selectedAppointmentTime;

  GooglePlace? _googlePlace;
  Timer? _addressSearchDebounce;
  List<_Prediction> _addressPredictions = [];
  bool _isLoadingAutocomplete = false;
  double? _selectedLat;
  double? _selectedLng;
  String? _selectedPlaceId;
  String? _selectedPlaceDescription;
  String? _selectedEstateId;
  String? _staticMapUrl;
  late final bool _useWebPlaces = kIsWeb && Env.googleMapsApiKey.isNotEmpty;
  String? _autoStreet;
  String? _autoSuburb;
  String? _autoCity;
  String? _autoProvince;
  String? _autoPostalCode;
  final _gpsCoordinateController = TextEditingController();
  String? _gpsCoordinateError;
  bool _isReverseGeocoding = false;

  final List<_ClaimItemFormState> _items = [];

  bool get _requiresDasNumber =>
      (_selectedInsurerLabel?.toLowerCase().trim() ?? '') == 'digicall';
  StateSetter? _addressDialogSetState;

  @override
  void initState() {
    super.initState();
    
    // Verify environment variables are present
    if (!Env.verifyEnvVars()) {
      AppLogger.error(
        'Environment variables missing in capture claim screen',
        name: 'CaptureClaim',
      );
    }
    
    final apiKey = Env.googleMapsApiKey;
    if (_useWebPlaces) {
      // Load Places API in background, handle errors gracefully
      PlacesWebService.ensureLoaded(apiKey).catchError((error, stackTrace) {
        AppLogger.error(
          'Failed to load Places API in initState: $error',
          name: 'CaptureClaim',
          error: error,
          stackTrace: stackTrace,
        );
        // Don't show error to user yet - will show when they try to use autocomplete
        // The screen will gracefully degrade if Places API is unavailable
      });
    } else if (apiKey.isNotEmpty) {
      try {
        _googlePlace = GooglePlace(apiKey);
      } catch (e, stackTrace) {
        AppLogger.error(
          'Failed to initialize GooglePlace: $e',
          name: 'CaptureClaim',
          error: e,
          stackTrace: stackTrace,
        );
      }
    } else {
      AppLogger.debug(
        'Google Maps API key not configured - Places API features will be disabled',
        name: 'CaptureClaim',
      );
    }
    _addItem();
  }

  Future<void> _checkForExistingAddressMatch(String placeId) async {}

  /// Parses GPS coordinates from text input.
  /// Supports multiple formats:
  /// - "-26.2041, 28.0473" (comma-separated)
  /// - "lat: -26.2041, lng: 28.0473" (labeled)
  /// - "-26.2041,28.0473" (no spaces)
  /// - "-26.2041 28.0473" (space-separated)
  /// Returns a map with 'lat' and 'lng' keys, or null if parsing fails.
  Map<String, double>? _parseGpsCoordinates(String input) {
    if (input.trim().isEmpty) {
      return null;
    }

    try {
      // Remove common prefixes and clean up
      String cleaned = input.trim();
      
      // Try to extract lat and lng from labeled format: "lat: -26.2041, lng: 28.0473"
      final labeledPattern = RegExp(
        r'(?:lat(?:itude)?\s*:?\s*)?(-?\d+\.?\d*)[,\s]+(?:lng|lon|longitude)\s*:?\s*(-?\d+\.?\d*)',
        caseSensitive: false,
      );
      final labeledMatch = labeledPattern.firstMatch(cleaned);
      if (labeledMatch != null) {
        final lat = double.tryParse(labeledMatch.group(1) ?? '');
        final lng = double.tryParse(labeledMatch.group(2) ?? '');
        if (lat != null && lng != null) {
          if (lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180) {
            return {'lat': lat, 'lng': lng};
          }
        }
      }

      // Try comma-separated or space-separated: "-26.2041, 28.0473" or "-26.2041 28.0473"
      final parts = cleaned.split(RegExp(r'[,\s]+')).where((p) => p.trim().isNotEmpty).toList();
      if (parts.length >= 2) {
        final lat = double.tryParse(parts[0].trim());
        final lng = double.tryParse(parts[1].trim());
        if (lat != null && lng != null) {
          if (lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180) {
            return {'lat': lat, 'lng': lng};
          }
        }
      }

      return null;
    } catch (e) {
      AppLogger.debug(
        'Error parsing GPS coordinates: $e',
        name: 'CaptureClaim',
        error: e,
      );
      return null;
    }
  }

  void _handleGpsCoordinateInput(String value) {
    setState(() {
      _gpsCoordinateError = null;
    });

    if (value.trim().isEmpty) {
      setState(() {
        _selectedLat = null;
        _selectedLng = null;
        _staticMapUrl = null;
      });
      _refreshAddressDialog();
      return;
    }

    final coords = _parseGpsCoordinates(value);
    if (coords != null) {
      setState(() {
        _selectedLat = coords['lat'];
        _selectedLng = coords['lng'];
        if (_selectedLat != null && _selectedLng != null) {
          _staticMapUrl = _buildStaticMapUrl(_selectedLat!, _selectedLng!);
        }
        _gpsCoordinateError = null;
      });
      _refreshAddressDialog();
    } else {
      setState(() {
        _gpsCoordinateError = 'Invalid format. Use: "lat, lng" or "lat: X, lng: Y"';
        _selectedLat = null;
        _selectedLng = null;
        _staticMapUrl = null;
      });
      _refreshAddressDialog();
    }
  }

  Future<void> _reverseGeocodeCoordinates() async {
    if (_selectedLat == null || _selectedLng == null) return;
    if (!_useWebPlaces) return;

    setState(() {
      _isReverseGeocoding = true;
    });
    _refreshAddressDialog();

    try {
      if (Env.googleMapsApiKey.isEmpty) {
        setState(() {
          _gpsCoordinateError = 'Google Maps API key is not configured';
          _isReverseGeocoding = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Google Maps API key is not configured. Please configure GOOGLE_MAPS_API_KEY.'),
              duration: Duration(seconds: 4),
            ),
          );
        }
        return;
      }

      // Load Places API with error handling
      try {
        await PlacesWebService.ensureLoaded(Env.googleMapsApiKey);
      } catch (loadError, loadStack) {
        AppLogger.error(
          'Failed to load Places API for reverse geocoding: $loadError',
          name: 'CaptureClaim',
          error: loadError,
          stackTrace: loadStack,
        );
        if (mounted) {
          setState(() {
            _gpsCoordinateError = 'Failed to load Google Maps API. Please check your API key configuration.';
            _isReverseGeocoding = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to load Google Maps API. Please check your API key configuration.'),
              duration: Duration(seconds: 4),
            ),
          );
        }
        return;
      }
      
      // Perform reverse geocoding with error handling
      final result = await PlacesWebService.reverseGeocode(_selectedLat!, _selectedLng!);
      
      if (result != null && mounted) {
        // Parse address components similar to _selectPrediction
        final rawComponents = (result['address_components'] as List<dynamic>? ?? []);
        final components = rawComponents
            .map((item) {
              final map = Map<String, dynamic>.from(item as Map);
              return _AddressComponent(
                longName: (map['long_name'] as String?) ?? '',
                types: List<String>.from(map['types'] ?? const []),
              );
            })
            .toList(growable: false);

        String? componentFor(String type) {
          for (final component in components) {
            if (component.types.contains(type)) {
              return component.longName;
            }
          }
          return null;
        }

        final formattedAddress = result['formatted_address'] as String? ?? '';
        final fallbackParts = formattedAddress.split(',');
        String fallbackPart(int index) =>
            index < fallbackParts.length ? fallbackParts[index].trim() : '';

        final streetNumber = componentFor('street_number') ?? '';
        final route = componentFor('route') ?? '';
        final suburb =
            componentFor('sublocality') ??
            componentFor('sublocality_level_1') ??
            componentFor('neighborhood') ??
            fallbackPart(1);
        final city =
            componentFor('locality') ??
            componentFor('administrative_area_level_3') ??
            componentFor('administrative_area_level_2') ??
            fallbackPart(2);
        final province =
            componentFor('administrative_area_level_1') ?? fallbackPart(3);
        final postalCode = componentFor('postal_code') ?? '';
        final estateCandidate =
            componentFor('premise') ?? componentFor('subpremise');

        final streetBase = [
          streetNumber,
          route,
        ].where((part) => part.trim().isNotEmpty).join(' ').trim();
        final fallbackStreet = fallbackPart(0);
        final street = streetBase.isNotEmpty ? streetBase : fallbackStreet;

        setState(() {
          _addressComplexController.text = estateCandidate ?? '';
          _addressStreetController.text = street;
          _addressSuburbController.text = suburb;
          _addressCityController.text = city;
          _addressProvinceController.text = province;
          _addressPostalCodeController.text = postalCode;
          _selectedPlaceDescription = formattedAddress;
          _isReverseGeocoding = false;
          // Build static map URL after successful reverse geocoding
          if (_selectedLat != null && _selectedLng != null) {
            _staticMapUrl = _buildStaticMapUrl(_selectedLat!, _selectedLng!);
          }
        });
        _maybeApplyEstateFromComponents(estateCandidate);
        _refreshAddressDialog();
      } else {
        setState(() {
          _isReverseGeocoding = false;
        });
        _refreshAddressDialog();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not reverse geocode coordinates. Please enter address manually.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (error, stackTrace) {
      AppLogger.error(
        'Error during reverse geocoding: $error',
        name: 'CaptureClaim',
        error: error,
        stackTrace: stackTrace,
      );
      setState(() {
        _isReverseGeocoding = false;
        _gpsCoordinateError = 'Failed to reverse geocode coordinates. Please enter address manually.';
      });
      _refreshAddressDialog();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error reverse geocoding: $error'),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void _maybeApplyEstateFromComponents(String? candidate) {
    final value = candidate?.trim();
    if (value == null || value.isEmpty) {
      return;
    }
    final estatesValue = ref.read(estateOptionsProvider);
    estatesValue.whenData((options) {
      final match = options.firstWhereOrNull(
        (option) => option.label.toLowerCase() == value.toLowerCase(),
      );
      if (match != null) {
        setState(() {
          _selectedEstateId = match.id;
          if (_addressComplexController.text.trim().isEmpty) {
            _addressComplexController.text = match.label;
          }
        });
      } else if (_addressComplexController.text.trim().isEmpty) {
        setState(() {
          _selectedEstateId = null;
          _addressComplexController.text = value;
        });
      }
    });
  }

  bool get _hasCapturedAddress {
    return (_selectedPlaceId != null) ||
        (_selectedLat != null && _selectedLng != null) ||
        _addressStreetController.text.trim().isNotEmpty ||
        _addressSuburbController.text.trim().isNotEmpty ||
        _addressCityController.text.trim().isNotEmpty ||
        _addressProvinceController.text.trim().isNotEmpty ||
        _addressPostalCodeController.text.trim().isNotEmpty;
  }

  @override
  void dispose() {
    _claimNumberController.dispose();
    _notesController.dispose();
    _clientNotesController.dispose();
    _damageDescriptionController.dispose();
    _clientFirstNameController.dispose();
    _clientLastNameController.dispose();
    _clientPrimaryPhoneController.dispose();
    _clientAltPhoneController.dispose();
    _clientEmailController.dispose();
    _addressSearchController.dispose();
    _addressComplexController.dispose();
    _addressUnitController.dispose();
    _addressStreetController.dispose();
    _addressSuburbController.dispose();
    _addressCityController.dispose();
    _addressProvinceController.dispose();
    _addressPostalCodeController.dispose();
    _addressNotesController.dispose();
    _gpsCoordinateController.dispose();
    _providerCompanyController.dispose();
    _providerContactNameController.dispose();
    _providerContactPhoneController.dispose();
    _providerContactEmailController.dispose();
    _providerReferenceController.dispose();
    _dasNumberController.dispose();
    _addressSearchDebounce?.cancel();
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  void _addItem() {
    setState(() {
      _items.add(_ClaimItemFormState());
    });
  }

  void _removeItem(_ClaimItemFormState item) {
    if (_items.length == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('At least one claim item is required.')),
      );
      return;
    }
    setState(() {
      _items.remove(item);
      item.dispose();
    });
  }

  void _clearNewClientFields() {
    _clientFirstNameController.clear();
    _clientLastNameController.clear();
    _clientPrimaryPhoneController.clear();
    _clientAltPhoneController.clear();
    _clientEmailController.clear();
  }

  void _clearGoogleSelection() {
    _addressPredictions = const [];
    _addressSearchController.clear();
    _selectedPlaceId = null;
    _selectedPlaceDescription = null;
    _selectedLat = null;
    _selectedLng = null;
    _staticMapUrl = null;
    _autoStreet = null;
    _autoSuburb = null;
    _autoCity = null;
    _autoProvince = null;
    _autoPostalCode = null;
  }

  void _clearNewAddressFields() {
    _addressComplexController.clear();
    _addressUnitController.clear();
    _addressStreetController.clear();
    _addressSuburbController.clear();
    _addressCityController.clear();
    _addressProvinceController.clear();
    _addressPostalCodeController.clear();
    _addressNotesController.clear();
    _gpsCoordinateController.clear();
    _selectedEstateId = null;
    _addressInputMode = AddressInputMode.search;
    _gpsCoordinateError = null;
    _clearGoogleSelection();
    _addressDialogSetState?.call(() {});
  }

  void _refreshAddressDialog() => _addressDialogSetState?.call(() {});

  void _clearServiceProviderFields() {
    _providerCompanyController.clear();
    _providerContactNameController.clear();
    _providerContactPhoneController.clear();
    _providerContactEmailController.clear();
    _providerReferenceController.clear();
  }

  _AddressSnapshot _captureAddressSnapshot() {
    return _AddressSnapshot(
      addressMode: _addressMode,
      selectedAddressId: _selectedAddress,
      selectedPlaceId: _selectedPlaceId,
      selectedPlaceDescription: _selectedPlaceDescription,
      complex: _addressComplexController.text,
      unit: _addressUnitController.text,
      street: _addressStreetController.text,
      suburb: _addressSuburbController.text,
      city: _addressCityController.text,
      province: _addressProvinceController.text,
      postalCode: _addressPostalCodeController.text,
      latitude: _selectedLat,
      longitude: _selectedLng,
      staticMapUrl: _staticMapUrl,
      estateId: _selectedEstateId,
      searchQuery: _addressSearchController.text,
      notes: _addressNotesController.text,
      autoStreet: _autoStreet,
      autoSuburb: _autoSuburb,
      autoCity: _autoCity,
      autoProvince: _autoProvince,
      autoPostalCode: _autoPostalCode,
    );
  }

  void _restoreAddressSnapshot(_AddressSnapshot snapshot) {
    _addressMode = snapshot.addressMode;
    _selectedAddress = snapshot.selectedAddressId;
    _selectedPlaceId = snapshot.selectedPlaceId;
    _selectedPlaceDescription = snapshot.selectedPlaceDescription;
    _addressComplexController.text = snapshot.complex;
    _addressUnitController.text = snapshot.unit;
    _addressStreetController.text = snapshot.street;
    _addressSuburbController.text = snapshot.suburb;
    _addressCityController.text = snapshot.city;
    _addressProvinceController.text = snapshot.province;
    _addressPostalCodeController.text = snapshot.postalCode;
    _addressNotesController.text = snapshot.notes;
    _selectedLat = snapshot.latitude;
    _selectedLng = snapshot.longitude;
    _staticMapUrl = snapshot.staticMapUrl;
    _selectedEstateId = snapshot.estateId;
    _addressSearchController.text = snapshot.searchQuery;
    _addressPredictions = [];
    _autoStreet = snapshot.autoStreet;
    _autoSuburb = snapshot.autoSuburb;
    _autoCity = snapshot.autoCity;
    _autoProvince = snapshot.autoProvince;
    _autoPostalCode = snapshot.autoPostalCode;
    _refreshAddressDialog();
  }

  Future<void> _handleAddressSearch(String value) async {
    // Only process if we're in search mode and have a valid API setup
    if (_addressInputMode != AddressInputMode.search) {
      AppLogger.debug(
        'Address search skipped: not in search mode (current mode: $_addressInputMode)',
        name: 'CaptureClaim',
      );
      return;
    }
    
    if (!_useWebPlaces && _googlePlace == null) {
      AppLogger.warn(
        'Address search skipped: Places API not available (_useWebPlaces: $_useWebPlaces, _googlePlace: ${_googlePlace != null})',
        name: 'CaptureClaim',
      );
      return;
    }
    
    _addressSearchDebounce?.cancel();
    
    // Clear loading state immediately when user types
    if (value.trim().isEmpty) {
      setState(() {
        _addressPredictions = [];
        _isLoadingAutocomplete = false;
      });
      _refreshAddressDialog();
      return;
    }
    
    // Set loading state
    setState(() => _isLoadingAutocomplete = true);
    _refreshAddressDialog();
    
    _addressSearchDebounce = Timer(const Duration(milliseconds: 350), () async {
      if (value.trim().isEmpty) {
        setState(() {
          _addressPredictions = [];
          _isLoadingAutocomplete = false;
        });
        _refreshAddressDialog();
        return;
      }
      if (_useWebPlaces) {
        try {
          await PlacesWebService.ensureLoaded(Env.googleMapsApiKey);
          final results = await PlacesWebService.autocomplete(value);
          AppLogger.debug(
            'Received ${results.length} results from PlacesWebService',
            name: 'CaptureClaim',
          );
          final predictions = results
              .map(_Prediction.fromWebJson)
              .whereType<_Prediction>()
              .toList(growable: false);
          AppLogger.debug(
            'Created ${predictions.length} predictions after conversion',
            name: 'CaptureClaim',
          );
          setState(() {
            _addressPredictions = predictions;
            _isLoadingAutocomplete = false;
          });
          _refreshAddressDialog();
        } catch (error, stackTrace) {
          AppLogger.error(
            'Error fetching autocomplete suggestions: $error',
            name: 'CaptureClaim',
            error: error,
            stackTrace: stackTrace,
          );
          
          setState(() {
            _addressPredictions = [];
            _isLoadingAutocomplete = false;
          });
          _refreshAddressDialog();
          
          // Provide user-friendly error message
          String errorMessage = 'Unable to search addresses';
          if (Env.googleMapsApiKey.isEmpty) {
            errorMessage = 'Google Maps API key is not configured. Please configure GOOGLE_MAPS_API_KEY.';
          } else {
            final errorStr = error.toString().toLowerCase();
            if (errorStr.contains('api key') || errorStr.contains('invalid key')) {
              errorMessage = 'Invalid Google Maps API key. Please check your configuration.';
            } else if (errorStr.contains('network') || errorStr.contains('connection')) {
              errorMessage = 'Network error. Please check your internet connection.';
            }
          }
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                duration: const Duration(seconds: 4),
              ),
            );
          }
        }
      } else {
        try {
          final response = await _googlePlace!.autocomplete.get(
            value,
            language: 'en',
            components: [Component('country', 'za')],
          );

          setState(() {
            final predictions =
                response?.predictions ?? const <AutocompletePrediction>[];
            _addressPredictions = predictions
                .map(_Prediction.fromMobile)
                .whereType<_Prediction>()
                .toList(growable: false);
            _isLoadingAutocomplete = false;
          });
          _refreshAddressDialog();
        } catch (error, stackTrace) {
          AppLogger.error(
            'Error fetching autocomplete suggestions (legacy): $error',
            name: 'CaptureClaim',
            error: error,
            stackTrace: stackTrace,
          );
          setState(() {
            _addressPredictions = [];
            _isLoadingAutocomplete = false;
          });
          _refreshAddressDialog();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to fetch address suggestions: ${error.toString()}'),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      }
    });
  }

  Future<void> _showAddressDialog() async {
    final snapshot = _captureAddressSnapshot();
    final saved = await showGlassDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            _addressDialogSetState = setModalState;
            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: GlassDialog(
                title: Text(
                  'Address details',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                content: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: _buildAddressDialogContent(),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  GlassButton.primary(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Save address'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (saved != true) {
      setState(() => _restoreAddressSnapshot(snapshot));
    } else {
      // Address was saved - ensure we're in new address mode if we have captured data
      if (_hasCapturedAddress && _addressMode != AddressMode.newAddress) {
        setState(() {
          _addressMode = AddressMode.newAddress;
        });
      } else {
        // Force rebuild to show the captured address in summary card
        setState(() {
          // Controllers already have the data from _selectPrediction
        });
      }
    }
    _addressDialogSetState = null;
  }

  Widget _buildAddressDialogContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (Env.googleMapsApiKey.isNotEmpty) ...[
          Row(
            children: [
              Expanded(
                child: SegmentedButton<AddressInputMode>(
                  segments: const [
                    ButtonSegment<AddressInputMode>(
                      value: AddressInputMode.search,
                      label: Text('Search via Google Maps'),
                      icon: Icon(Icons.search, semanticLabel: 'Search address'),
                    ),
                    ButtonSegment<AddressInputMode>(
                      value: AddressInputMode.manual,
                      label: Text('Enter manually'),
                      icon: Icon(Icons.edit_location_alt, semanticLabel: 'Edit location'),
                    ),
                    ButtonSegment<AddressInputMode>(
                      value: AddressInputMode.gps,
                      label: Text('GPS coordinates'),
                      icon: Icon(Icons.gps_fixed, semanticLabel: 'Use GPS coordinates'),
                    ),
                  ],
                  selected: <AddressInputMode>{_addressInputMode},
                  onSelectionChanged: (selection) {
                    if (selection.isEmpty) return;
                    final next = selection.single;
                    if (_addressInputMode == next) {
                      return;
                    }
                    setState(() {
                      _addressInputMode = next;
                      if (next == AddressInputMode.gps) {
                        // Clear GPS error when switching to GPS mode
                        _gpsCoordinateError = null;
                      }
                    });
                    _refreshAddressDialog();
                  },
                ),
              ),
              const SizedBox(width: 12),
              if (_addressInputMode == AddressInputMode.search)
                IconButton(
                  tooltip: 'Clear selection',
                  onPressed: () {
                    setState(() {
                      _clearGoogleSelection();
                    });
                    _refreshAddressDialog();
                  },
                  icon: const Icon(Icons.clear, semanticLabel: 'Clear'),
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        if (_addressInputMode == AddressInputMode.gps && Env.googleMapsApiKey.isNotEmpty) ...[
          GlassInput.text(
            context: context,
            controller: _gpsCoordinateController,
            label: 'GPS Coordinates',
            hint: 'e.g., -26.2041, 28.0473 or lat: -26.2041, lng: 28.0473',
            prefixIcon: const Icon(Icons.gps_fixed, semanticLabel: 'GPS coordinates'),
            suffixIcon: _gpsCoordinateController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _gpsCoordinateController.clear();
                      setState(() {
                        _selectedLat = null;
                        _selectedLng = null;
                        _staticMapUrl = null;
                        _gpsCoordinateError = null;
                      });
                      _refreshAddressDialog();
                    },
                    icon: const Icon(Icons.clear, semanticLabel: 'Clear'),
                  )
                : null,
            onChanged: _handleGpsCoordinateInput,
            errorText: _gpsCoordinateError,
          ),
          if (_gpsCoordinateError != null) ...[
            const SizedBox(height: 8),
            Text(
              _gpsCoordinateError!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
          if (_selectedLat != null && _selectedLng != null) ...[
            const SizedBox(height: 16),
            Text(
              'Coordinates: ${_selectedLat!.toStringAsFixed(6)}, ${_selectedLng!.toStringAsFixed(6)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            // Static map image
            if (_selectedLat != null && _selectedLng != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _staticMapUrl != null && _staticMapUrl!.isNotEmpty
                      ? Image.network(
                          _staticMapUrl!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            AppLogger.debug(
                              'Static map image loading error: $error. Stack trace: $stackTrace',
                              name: 'CaptureClaim',
                              error: error,
                              stackTrace: stackTrace,
                            );
                            
                            String errorMessage = 'Failed to load map';
                            if (Env.googleMapsApiKey.isEmpty) {
                              errorMessage = 'API key not configured';
                            } else if (error.toString().contains('403') || error.toString().contains('denied')) {
                              errorMessage = 'API key access denied. Check Static Maps API is enabled.';
                            } else if (error.toString().contains('400') || error.toString().contains('invalid')) {
                              errorMessage = 'Invalid request. Check coordinates.';
                            }
                            
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Theme.of(context).colorScheme.error,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      errorMessage,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: Theme.of(context).colorScheme.error,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  if (kDebugMode && Env.googleMapsApiKey.isEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Configure GOOGLE_MAPS_API_KEY',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.7),
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                ),
              )
            else
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Enter GPS coordinates to view map',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            // Reverse geocode button
            GlassButton.outlined(
              onPressed: _isReverseGeocoding ? null : _reverseGeocodeCoordinates,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isReverseGeocoding) ...[
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 8),
                  ] else ...[
                    const Icon(Icons.search, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(_isReverseGeocoding ? 'Reverse geocoding...' : 'Reverse geocode address'),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ] else if (_gpsCoordinateController.text.trim().isEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Enter GPS coordinates or click on the map below to set location.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            // Placeholder for map when no coordinates entered
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map_outlined,
                      size: 48,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter GPS coordinates to view map',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
        ],
        if (_addressInputMode == AddressInputMode.search && Env.googleMapsApiKey.isNotEmpty) ...[
          GlassInput.text(
            context: context,
            controller: _addressSearchController,
            label: 'Search address (Google Maps)',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _addressSearchController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _addressSearchController.clear();
                      setState(() {
                        _addressPredictions = const [];
                        _isLoadingAutocomplete = false;
                      });
                      _refreshAddressDialog();
                    },
                    icon: const Icon(Icons.clear, semanticLabel: 'Clear'),
                  )
                : null,
            onChanged: _handleAddressSearch,
          ),
          if (_isLoadingAutocomplete) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Searching addresses...',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
          if (_addressPredictions.isNotEmpty) ...[
            const SizedBox(height: 8),
            _AddressPredictionsList(
              predictions: _addressPredictions,
              onSelected: _selectPrediction,
            ),
            const SizedBox(height: 8),
          ],
          if (_selectedPlaceDescription != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 12),
              child: _SelectedAddressSummary(
                description: _selectedPlaceDescription!,
                isSelected: true,
              ),
            ),
          if (!_isLoadingAutocomplete &&
              _addressSearchController.text.trim().isEmpty &&
              _addressPredictions.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 12),
              child: Text(
                'Select an address from Google Maps to auto-fill these details. '
                'Switch to "Enter manually" if you can\'t find the address.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
        if (_addressInputMode == AddressInputMode.manual || Env.googleMapsApiKey.isEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _addressInputMode == AddressInputMode.manual
                        ? Icons.edit_location_alt_outlined
                        : Icons.info_outline,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      Env.googleMapsApiKey.isEmpty
                          ? 'Google Maps API key not configured. Enter the address manually.'
                          : 'Manual entry mode. Fill in all address fields below.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _TextField(
            controller: _addressComplexController,
            label: 'Complex / estate',
            isRequired: false,
          ),
          _TextField(
            controller: _addressUnitController,
            label: 'Unit number',
            isRequired: false,
          ),
          _TextField(
            controller: _addressStreetController,
            label: 'Street name',
          ),
          _TextField(controller: _addressSuburbController, label: 'Suburb'),
          _TextField(controller: _addressCityController, label: 'City / Town'),
          _TextField(controller: _addressProvinceController, label: 'Province'),
          _TextField(
            controller: _addressPostalCodeController,
            label: 'Postal code',
          ),
        ],
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: _TextField(
            controller: _addressNotesController,
            label: 'Notes / Comments (optional)',
            isRequired: false,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (_) => _refreshAddressDialog(),
          ),
        ),
        if (Env.googleMapsApiKey.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Add a Google Maps API key to validate addresses automatically.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }

  Future<void> _selectPrediction(_Prediction prediction) async {
    if ((!_useWebPlaces && _googlePlace == null) ||
        prediction.placeId == null) {
      return;
    }

    try {
      List<_AddressComponent> components = [];
      String? formattedAddress;
      double? latitude;
      double? longitude;

      if (_useWebPlaces) {
        if (Env.googleMapsApiKey.isEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Google Maps API key is not configured. Please configure GOOGLE_MAPS_API_KEY.'),
                duration: Duration(seconds: 4),
              ),
            );
          }
          // Fallback to manual entry
          setState(() {
            _selectedPlaceId = prediction.placeId;
            _selectedPlaceDescription = prediction.description;
            _addressSearchController.text = prediction.description;
            _addressPredictions = [];
          });
          _refreshAddressDialog();
          return;
        }

        final details = await PlacesWebService.placeDetails(
          prediction.placeId!,
        );
        if (details == null || details.isEmpty) {
          // Fallback: use prediction description and clear predictions
          setState(() {
            _selectedPlaceId = prediction.placeId;
            _selectedPlaceDescription = prediction.description;
            _addressSearchController.text = prediction.description;
            _addressPredictions = [];
          });
          _refreshAddressDialog();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Address details could not be loaded. Please fill in the address fields manually.',
                ),
                duration: const Duration(seconds: 4),
              ),
            );
          }
          return;
        }
        final rawComponents =
            (details['address_components'] as List<dynamic>? ?? []);
        components = rawComponents
            .map((item) {
              final map = Map<String, dynamic>.from(item as Map);
              return _AddressComponent(
                longName: (map['long_name'] as String?) ?? '',
                types: List<String>.from(map['types'] ?? const []),
              );
            })
            .toList(growable: false);
        formattedAddress = details['formatted_address'] as String?;
        final geometryRaw = details['geometry'];
        final geometry = geometryRaw is Map ? Map<String, dynamic>.from(geometryRaw) : null;
        final locationRaw = geometry?['location'];
        final location =
            locationRaw is Map ? Map<String, dynamic>.from(locationRaw) : null;
        latitude = (location?['lat'] as num?)?.toDouble();
        longitude = (location?['lng'] as num?)?.toDouble();
      } else {
        final details = await _googlePlace!.details.get(
          prediction.placeId!,
          language: 'en',
          fields: 'address_component,geometry,formatted_address',
        );
        if (details == null) return;
        final result = details.result;
        if (result == null) return;
        components = (result.addressComponents ?? [])
            .map(
              (component) => _AddressComponent(
                longName: component.longName ?? '',
                types: component.types ?? const [],
              ),
            )
            .toList(growable: false);
        formattedAddress = result.formattedAddress;
        latitude = result.geometry?.location?.lat;
        longitude = result.geometry?.location?.lng;
      }

      String? componentFor(String type) {
        for (final component in components) {
          if (component.types.contains(type)) {
            return component.longName;
          }
        }
        return null;
      }

      final streetNumber = componentFor('street_number') ?? '';
      final route = componentFor('route') ?? '';
      final fallbackParts = (formattedAddress ?? prediction.description)
          .split(',');
      String fallbackPart(int index) =>
          index < fallbackParts.length ? fallbackParts[index].trim() : '';
      final suburb =
          componentFor('sublocality') ??
          componentFor('sublocality_level_1') ??
          componentFor('neighborhood') ??
          fallbackPart(1);
      final city =
          componentFor('locality') ??
          componentFor('administrative_area_level_3') ??
          componentFor('administrative_area_level_2') ??
          fallbackPart(2);
      final province =
          componentFor('administrative_area_level_1') ?? fallbackPart(3);
      final postalCode = componentFor('postal_code') ?? '';
      final estateCandidate =
          componentFor('premise') ?? componentFor('subpremise');

      final streetBase = [
        streetNumber,
        route,
      ].where((part) => part.trim().isNotEmpty).join(' ').trim();
      final fallbackStreet = fallbackPart(0);
      final street = streetBase.isNotEmpty ? streetBase : fallbackStreet;

      // Update parent state
      setState(() {
        _selectedPlaceId = prediction.placeId;
        _selectedPlaceDescription = formattedAddress ?? prediction.description;
        _addressSearchController.text =
            _selectedPlaceDescription ?? prediction.description;
        _addressComplexController.text = estateCandidate ?? '';
        _addressStreetController.text = street;
        _addressSuburbController.text = suburb;
        _addressCityController.text = city;
        _addressProvinceController.text = province;
        _addressPostalCodeController.text = postalCode;
        _selectedLat = latitude;
        _selectedLng = longitude;
        if (_selectedLat != null && _selectedLng != null) {
          _staticMapUrl = _buildStaticMapUrl(_selectedLat!, _selectedLng!);
        }
        _addressPredictions = [];
        _autoStreet = street.isNotEmpty ? street : null;
        _autoSuburb = suburb.isNotEmpty ? suburb : null;
        _autoCity = city.isNotEmpty ? city : null;
        _autoProvince = province.isNotEmpty ? province : null;
        _autoPostalCode = postalCode.isNotEmpty ? postalCode : null;
      });
      // Refresh dialog UI immediately using dialog's state setter
      _refreshAddressDialog();
      _maybeApplyEstateFromComponents(estateCandidate);
      await _checkForExistingAddressMatch(prediction.placeId!);
      // Refresh again after async operations
      _refreshAddressDialog();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error fetching place details: $e',
        name: 'CaptureClaim',
        error: e,
        stackTrace: stackTrace,
      );
      // On error, at least clear predictions and show the selected description
      setState(() {
        _selectedPlaceId = prediction.placeId;
        _selectedPlaceDescription = prediction.description;
        _addressSearchController.text = prediction.description;
        _addressPredictions = [];
      });
      _refreshAddressDialog();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Unable to load address details. Please fill in the address fields manually.',
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      }
      AppLogger.debug(
        'Error selecting prediction: $e',
        name: 'CaptureClaim',
        error: e,
      );
    }
  }

  String _buildStaticMapUrl(double lat, double lng) {
    // Validate API key
    if (Env.googleMapsApiKey.isEmpty) {
      AppLogger.debug(
        'Warning: Google Maps API key is empty. Static map will not load.',
        name: 'CaptureClaimScreen',
      );
      // Return empty string - the error builder will handle it
      return '';
    }

    final uri = Uri.https('maps.googleapis.com', '/maps/api/staticmap', {
      'center': '$lat,$lng',
      'zoom': '16', // Good zoom level to show address details
      'size': '600x300',
      'scale': '2', // High DPI for better quality
      'maptype': 'roadmap',
      'markers': 'color:red|label:A|$lat,$lng', // Red marker with label
      'key': Env.googleMapsApiKey,
    });
    
    final url = uri.toString();
    
    AppLogger.debug(
      'Built static map URL for coordinates: $lat, $lng. URL length: ${url.length}, API key present: ${Env.googleMapsApiKey.isNotEmpty}',
      name: 'CaptureClaimScreen',
    );
    
    return url;
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _claimNumberController.clear();
    _notesController.clear();
    _clientNotesController.clear();
    _damageDescriptionController.clear();
    _surgeAtDb = false;
    _surgeAtPlug = false;
    _selectedInsurer = null;
    _selectedAddress = null;
    _selectedPriority = PriorityLevel.normal;
    _selectedDamageCause = DamageCause.other;
    _selectedTechnicianId = null;
    _selectedAppointmentDate = null;
    _selectedAppointmentTime = null;
    _addressMode = AddressMode.newAddress;
    _addressInputMode = AddressInputMode.search;
    _includeServiceProvider = false;
    _selectedInsurerLabel = null;
    _clearNewClientFields();
    _clearNewAddressFields();
    _clearServiceProviderFields();
    _dasNumberController.clear();
    _addressSearchDebounce?.cancel();
    _addressSearchDebounce = null;
    for (final item in _items) {
      item.dispose();
    }
    _items
      ..clear()
      ..add(_ClaimItemFormState());
  }

  Future<void> _handleSubmit() async {
    final messenger = ScaffoldMessenger.of(context);
    final profile = ref.read(currentUserProvider).asData?.value;
    if (profile == null) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Unable to determine tenant. Please relogin.'),
        ),
      );
      return;
    }

    if (_selectedInsurer == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Select an insurer before submitting.')),
      );
      return;
    }
    if (_requiresDasNumber && _dasNumberController.text.trim().isEmpty) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('DAS number is required for Digicall claims.'),
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    if (_selectedDamageCause == DamageCause.other &&
        _damageDescriptionController.text.trim().isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Please describe the damage.')),
      );
      return;
    }

    String? clientId;
    ClientInput? clientInput;
    final firstName = _clientFirstNameController.text.trim();
    final lastName = _clientLastNameController.text.trim();
    final primaryPhone = _clientPrimaryPhoneController.text.trim();
    if (firstName.isEmpty || lastName.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Client first and last name are required.'),
        ),
      );
      return;
    }
    final phoneError = Validators.validateSouthAfricanPhone(primaryPhone);
    if (phoneError != null) {
      messenger.showSnackBar(SnackBar(content: Text(phoneError)));
      return;
    }
    final altError = Validators.validateOptionalSouthAfricanPhone(
      _clientAltPhoneController.text,
    );
    if (altError != null) {
      messenger.showSnackBar(SnackBar(content: Text(altError)));
      return;
    }
    final emailError = Validators.validateOptionalEmail(
      _clientEmailController.text,
    );
    if (emailError != null) {
      messenger.showSnackBar(SnackBar(content: Text(emailError)));
      return;
    }
    clientInput = ClientInput(
      firstName: firstName,
      lastName: lastName,
      primaryPhone: primaryPhone,
      altPhone: _clientAltPhoneController.text.trim().isEmpty
          ? null
          : _clientAltPhoneController.text.trim(),
      email: _clientEmailController.text.trim().isEmpty
          ? null
          : _clientEmailController.text.trim(),
    );

    AddressInput? addressInput;
    String? addressId;
    final requiresNewAddress = _addressMode == AddressMode.newAddress;
    if (!requiresNewAddress) {
      if (_selectedAddress == null) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Select an address for the client.')),
        );
        return;
      }
      addressId = _selectedAddress;
    } else {
      final manualStreet = _addressStreetController.text.trim();
      final manualSuburb = _addressSuburbController.text.trim();
      final manualCity = _addressCityController.text.trim();
      final manualProvince = _addressProvinceController.text.trim();
      final manualPostal = _addressPostalCodeController.text.trim();

      final requiresManualFields =
          _addressInputMode == AddressInputMode.manual || Env.googleMapsApiKey.isEmpty;

      // Check if we have GPS coordinates
      final hasGpsCoordinates = _selectedLat != null && _selectedLng != null;
      final isGpsMode = _addressInputMode == AddressInputMode.gps;

      final street = requiresManualFields
          ? manualStreet
          : (manualStreet.isNotEmpty ? manualStreet : (_autoStreet ?? ''));
      final suburb = requiresManualFields
          ? manualSuburb
          : (manualSuburb.isNotEmpty ? manualSuburb : (_autoSuburb ?? ''));
      final city = requiresManualFields
          ? manualCity
          : (manualCity.isNotEmpty ? manualCity : (_autoCity ?? ''));
      final province = requiresManualFields
          ? manualProvince
          : (manualProvince.isNotEmpty
                ? manualProvince
                : (_autoProvince ?? ''));
      final postal = requiresManualFields
          ? manualPostal
          : (manualPostal.isNotEmpty ? manualPostal : (_autoPostalCode ?? ''));

      final hasAllAddressFields = [
        street,
        suburb,
        city,
        province,
        postal,
      ].every((value) => value.isNotEmpty);

      // If GPS mode is selected and GPS coordinates exist, allow saving with just coordinates
      // Address fields are optional in this case
      if (isGpsMode && hasGpsCoordinates) {
        // Allow saving with GPS coordinates only, address fields are optional
        // Use empty strings for missing fields
      } else if (requiresManualFields) {
        if (!hasAllAddressFields) {
          messenger.showSnackBar(
            const SnackBar(
              content: Text(
                'Street, suburb, city, province and postal code are required.',
              ),
            ),
          );
          return;
        }
      } else {
        if (!hasAllAddressFields) {
          messenger.showSnackBar(
            const SnackBar(
              content: Text(
                'Select an address from Google Maps or switch to "Enter manually" and fill in the address details.',
              ),
            ),
          );
          return;
        }
      }

      addressInput = AddressInput(
        estateId: _selectedEstateId,
        complexOrEstate: _addressComplexController.text.trim().isEmpty
            ? null
            : _addressComplexController.text.trim(),
        unitNumber: _addressUnitController.text.trim().isEmpty
            ? null
            : _addressUnitController.text.trim(),
        street: street,
        suburb: suburb,
        city: city,
        province: province,
        postalCode: postal,
        latitude: _selectedLat,
        longitude: _selectedLng,
        googlePlaceId: _selectedPlaceId,
        notes: _addressNotesController.text.trim().isEmpty
            ? null
            : _addressNotesController.text.trim(),
      );
    }

    ServiceProviderInput? serviceProviderInput;
    if (_includeServiceProvider) {
      final companyName = _providerCompanyController.text.trim();
      final contactPhone = _providerContactPhoneController.text.trim();
      final contactEmail = _providerContactEmailController.text.trim();
      final hasAnyInput =
          companyName.isNotEmpty ||
          contactPhone.isNotEmpty ||
          contactEmail.isNotEmpty ||
          _providerContactNameController.text.trim().isNotEmpty ||
          _providerReferenceController.text.trim().isNotEmpty;

      if (!hasAnyInput) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              'Fill in the service provider details or switch the toggle off.',
            ),
          ),
        );
        return;
      }
      if (companyName.isEmpty) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Service provider company name is required.'),
          ),
        );
        return;
      }
      final providerPhoneError = Validators.validateOptionalSouthAfricanPhone(
        contactPhone,
      );
      if (providerPhoneError != null) {
        messenger.showSnackBar(SnackBar(content: Text(providerPhoneError)));
        return;
      }
      final providerEmailError = Validators.validateOptionalEmail(contactEmail);
      if (providerEmailError != null) {
        messenger.showSnackBar(SnackBar(content: Text(providerEmailError)));
        return;
      }
      serviceProviderInput = ServiceProviderInput(
        companyName: companyName,
        contactName: _providerContactNameController.text.trim().isEmpty
            ? null
            : _providerContactNameController.text.trim(),
        contactPhone: contactPhone.isEmpty ? null : contactPhone,
        contactEmail: contactEmail.isEmpty ? null : contactEmail,
        referenceNumber: _providerReferenceController.text.trim().isEmpty
            ? null
            : _providerReferenceController.text.trim(),
      );
    }

    final invalidItem = _items.indexWhere((item) => !item.isValid);
    if (invalidItem != -1) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Item ${invalidItem + 1}: select a brand or capture a custom brand name.',
          ),
        ),
      );
      return;
    }

    final claimNumber = _claimNumberController.text.trim();
    final repository = ref.read(claimRepositoryProvider);
    final existsResult = await repository.claimExists(
      insurerId: _selectedInsurer!,
      claimNumber: claimNumber,
    );
    if (!mounted) return;
    if (existsResult.isErr) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Could not verify claim number: ${existsResult.error}'),
        ),
      );
      return;
    }
    if (existsResult.data) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'A claim with this number already exists for the selected insurer.',
          ),
        ),
      );
      return;
    }

    final controller = ref.read(claimCaptureControllerProvider.notifier);
    final itemsDraft = _items
        .map((item) => item.toDraft())
        .toList(growable: false);
    await controller.submit(
      ClaimDraft(
        tenantId: profile.tenantId,
        claimNumber: claimNumber,
        insurerId: _selectedInsurer!,
        clientId: clientId,
        clientInput: clientInput,
        addressId: addressId,
        addressInput: addressInput,
        serviceProviderInput: serviceProviderInput,
        dasNumber: _requiresDasNumber ? _dasNumberController.text.trim() : null,
        priority: _selectedPriority,
        damageCause: _selectedDamageCause,
        damageDescription: _damageDescriptionController.text.trim().isEmpty
            ? null
            : _damageDescriptionController.text.trim(),
        technicianId: _selectedTechnicianId,
        appointmentDate: _selectedAppointmentDate,
        appointmentTime: _selectedAppointmentTime,
        surgeProtectionAtDb: _surgeAtDb,
        surgeProtectionAtPlug: _surgeAtPlug,
        agentId: profile.id,
        clientNotes: _clientNotesController.text.trim().isEmpty
            ? null
            : _clientNotesController.text.trim(),
        notesInternal: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        items: itemsDraft,
      ),
    );

    if (!mounted) return;

    final state = ref.read(claimCaptureControllerProvider);
    if (state.hasError) {
      final errorMessage = _describeError(state.error);
      messenger.showSnackBar(
        SnackBar(content: Text('${AppStrings.claimCreateFailed}: $errorMessage')),
      );
    } else if (state.hasValue && state.value != null) {
      messenger.showSnackBar(
        const SnackBar(content: Text(AppStrings.claimCreated)),
      );
      ref.read(claimCaptureControllerProvider.notifier).reset();
      setState(_resetForm);
      if (!mounted) return;
      context.goNamed('claim-detail', pathParameters: {'id': state.value!});
    }
  }

  String _describeError(Object? error) {
    if (error is DomainError) {
      // In production, don't expose internal error causes
      if (error is UnknownError) {
        // Only show cause in debug mode for development
        if (kDebugMode && error.cause != null) {
          return '${error.message}: ${error.cause}';
        }
        return error.message;
      }
      return error.message;
    }
    // For non-DomainError exceptions, show generic message in production
    if (kDebugMode) {
      return error?.toString() ?? 'Unexpected error occurred';
    }
    return 'An unexpected error occurred. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    final submission = ref.watch(claimCaptureControllerProvider);
    final insurers = ref.watch(insurerOptionsProvider);
    final brands = ref.watch(brandOptionsProvider);
    final insurerOptions = insurers.asData?.value ?? const <ReferenceOption>[];
    final brandOptions = brands.asData?.value ?? const <ReferenceOption>[];
    final requiresDasNumber = _requiresDasNumber;
    final brandsError = brands.whenOrNull<Object>(error: (error, _) => error);
    final brandsLoading = brands.isLoading;
    final estateNamePreview = _addressComplexController.text.trim().isEmpty
        ? null
        : _addressComplexController.text.trim();
    String effectiveField(String controllerValue, String? autoValue) {
      if (_addressMode == AddressMode.existing) return '';
      final trimmed = controllerValue.trim();
      if (trimmed.isNotEmpty) return trimmed;
      return autoValue ?? '';
    }

    final summaryStreet = effectiveField(
      _addressStreetController.text,
      _autoStreet,
    );
    final summarySuburb = effectiveField(
      _addressSuburbController.text,
      _autoSuburb,
    );
    final summaryCity = effectiveField(_addressCityController.text, _autoCity);
    final summaryProvince = effectiveField(
      _addressProvinceController.text,
      _autoProvince,
    );
    final summaryPostal = effectiveField(
      _addressPostalCodeController.text,
      _autoPostalCode,
    );
    final hasAddressSelection = _hasCapturedAddress;

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('Capture claim'),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CaptureHero(
                      onBackToQueue: () => GoRouter.of(context).go('/claims'),
                      onManageInsurers: () =>
                          GoRouter.of(context).push('/admin/insurers'),
                    ),
                    const SizedBox(height: 24),
                    _SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionTitle(label: 'Claim details'),
                          const SizedBox(height: 16),
                          _TextField(
                            controller: _claimNumberController,
                            label: 'Claim number',
                            validator: Validators.validateClaimNumber,
                          ),
                          _DropdownField(
                            label: 'Insurer',
                            value: _selectedInsurer,
                            options: insurers,
                            onChanged: (value) => setState(() {
                              _selectedInsurer = value;
                              final match = insurerOptions.firstWhereOrNull(
                                (option) => option.id == value,
                              );
                              _selectedInsurerLabel = match?.label;
                              final willRequireDasNumber =
                                  (_selectedInsurerLabel
                                          ?.toLowerCase()
                                          .trim() ??
                                      '') ==
                                  'digicall';
                              if (!willRequireDasNumber) {
                                _dasNumberController.clear();
                              }
                            }),
                          ),
                          if (requiresDasNumber) ...[
                            const SizedBox(height: 12),
                            _TextField(
                              controller: _dasNumberController,
                              label: 'DAS number',
                              textCapitalization: TextCapitalization.characters,
                            ),
                          ],
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<PriorityLevel>(
                                  initialValue: _selectedPriority,
                                  decoration: buildCaptureFieldDecoration(
                                    context,
                                    'Priority',
                                  ),
                                  items: PriorityLevel.values
                                      .map(
                                        (priority) => DropdownMenuItem(
                                          value: priority,
                                          child: Text(_priorityLabel(priority)),
                                        ),
                                      )
                                      .toList(growable: false),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => _selectedPriority = value);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DropdownButtonFormField<DamageCause>(
                                  initialValue: _selectedDamageCause,
                                  decoration: buildCaptureFieldDecoration(
                                    context,
                                    'Damage cause',
                                  ),
                                  items: DamageCause.values
                                      .map(
                                        (cause) => DropdownMenuItem(
                                          value: cause,
                                          child: Text(_damageLabel(cause)),
                                        ),
                                      )
                                      .toList(growable: false),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(
                                        () => _selectedDamageCause = value,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          if (_selectedDamageCause == DamageCause.other) ...[
                            const SizedBox(height: 12),
                            _TextField(
                              controller: _damageDescriptionController,
                              label: 'Damage description',
                              maxLines: 2,
                            ),
                          ],
                          const SizedBox(height: DesignTokens.spaceL),
                          TechnicianSelector(
                            selectedTechnicianId: _selectedTechnicianId,
                            appointmentDate: _selectedAppointmentDate,
                            onTechnicianSelected: (technicianId) {
                              setState(() {
                                _selectedTechnicianId = technicianId;
                              });
                            },
                          ),
                          const SizedBox(height: DesignTokens.spaceM),
                          AppointmentPicker(
                            selectedDate: _selectedAppointmentDate,
                            selectedTime: _selectedAppointmentTime,
                            onDateSelected: (date) {
                              setState(() {
                                _selectedAppointmentDate = date;
                              });
                            },
                            onTimeSelected: (time) {
                              setState(() {
                                _selectedAppointmentTime = time;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionTitle(label: 'Client'),
                          const SizedBox(height: 16),
                          _TextField(
                            controller: _clientFirstNameController,
                            label: 'First name',
                            textCapitalization: TextCapitalization.words,
                          ),
                          _TextField(
                            controller: _clientLastNameController,
                            label: 'Surname',
                            textCapitalization: TextCapitalization.words,
                          ),
                          _TextField(
                            controller: _clientPrimaryPhoneController,
                            label: 'Primary contact number',
                            keyboardType: TextInputType.phone,
                          ),
                          _TextField(
                            controller: _clientAltPhoneController,
                            label: 'Alternate contact number',
                            keyboardType: TextInputType.phone,
                            isRequired: false,
                          ),
                          _TextField(
                            controller: _clientEmailController,
                            label: 'Email (optional)',
                            keyboardType: TextInputType.emailAddress,
                            isRequired: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionTitle(label: 'Address'),
                          const SizedBox(height: 12),
                          _AddressSummaryCard(
                            hasAddress: hasAddressSelection,
                            description:
                                _selectedPlaceDescription ??
                                (summaryStreet.isNotEmpty
                                    ? [
                                        if (_addressComplexController.text
                                            .trim()
                                            .isNotEmpty)
                                          '${_addressComplexController.text.trim()}, ',
                                        summaryStreet,
                                        if (summarySuburb.isNotEmpty)
                                          ', $summarySuburb',
                                        if (summaryCity.isNotEmpty)
                                          ', $summaryCity',
                                      ].join('')
                                    : null),
                            estateName: estateNamePreview,
                            street: summaryStreet,
                            suburb: summarySuburb,
                            city: summaryCity,
                            province: summaryProvince,
                            postalCode: summaryPostal,
                            lat: _selectedLat,
                            lng: _selectedLng,
                            notes: _addressNotesController.text.trim().isEmpty
                                ? null
                                : _addressNotesController.text.trim(),
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Wrap(
                              spacing: 12,
                              runSpacing: 8,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                GlassButton.primary(
                                  onPressed: _showAddressDialog,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        hasAddressSelection
                                            ? Icons.edit_location_alt_outlined
                                            : Icons.add_location_alt_outlined,
                                      ),
                                      const SizedBox(width: DesignTokens.spaceS),
                                      Text(
                                        hasAddressSelection
                                            ? 'Edit address'
                                            : 'Set address',
                                      ),
                                    ],
                                  ),
                                ),
                                if (_addressMode == AddressMode.newAddress &&
                                    _hasCapturedAddress)
                                  TextButton(
                                    onPressed: () =>
                                        setState(_clearNewAddressFields),
                                    child: const Text('Clear'),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SectionTitle(label: 'Service provider'),
                              Row(
                                children: [
                                  Text(
                                    _includeServiceProvider
                                        ? 'Included'
                                        : 'Not included',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                  const SizedBox(width: 8),
                                  Switch.adaptive(
                                    value: _includeServiceProvider,
                                    onChanged: (value) => setState(() {
                                      _includeServiceProvider = value;
                                      if (!value) {
                                        _clearServiceProviderFields();
                                      }
                                    }),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (!_includeServiceProvider)
                            Text(
                              'Toggle on to capture the service provider handling this claim.',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            )
                          else ...[
                            _TextField(
                              controller: _providerCompanyController,
                              label: 'Company name',
                            ),
                            _TextField(
                              controller: _providerContactNameController,
                              label: 'Contact name',
                              textCapitalization: TextCapitalization.words,
                              isRequired: false,
                            ),
                            _TextField(
                              controller: _providerContactPhoneController,
                              label: 'Contact number',
                              keyboardType: TextInputType.phone,
                              isRequired: false,
                            ),
                            _TextField(
                              controller: _providerContactEmailController,
                              label: 'Contact email',
                              keyboardType: TextInputType.emailAddress,
                              isRequired: false,
                            ),
                            _TextField(
                              controller: _providerReferenceController,
                              label: 'Reference number',
                              isRequired: false,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionTitle(label: 'Protection & notes'),
                          const SizedBox(height: 16),
                          _ToggleTile(
                            label: 'Surge protection at distribution board',
                            value: _surgeAtDb,
                            onChanged: (value) =>
                                setState(() => _surgeAtDb = value),
                          ),
                          const SizedBox(height: 12),
                          _ToggleTile(
                            label: 'Surge protection at plug points',
                            value: _surgeAtPlug,
                            onChanged: (value) =>
                                setState(() => _surgeAtPlug = value),
                          ),
                          const SizedBox(height: 16),
                          _TextField(
                            controller: _clientNotesController,
                            label: 'Client notes',
                            maxLines: 3,
                            isRequired: false,
                          ),
                          _TextField(
                            controller: _notesController,
                            label: 'Internal notes',
                            maxLines: 3,
                            isRequired: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionTitle(label: 'Claim items'),
                          const SizedBox(height: 16),
                          ...List.generate(
                            _items.length,
                            (index) {
                              final item = _items[index];
                              return Padding(
                              padding: EdgeInsets.only(
                                bottom: index == _items.length - 1 ? 0 : 12,
                              ),
                              child: _ClaimItemCard(
                                item: item,
                                index: index,
                                onRemove: () => _removeItem(item),
                                brandOptions: brandOptions,
                                brandsLoading: brandsLoading,
                                brandsError: brandsError,
                              ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          GlassButton.secondary(
                            onPressed: _addItem,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add_circle_outline),
                                SizedBox(width: DesignTokens.spaceS),
                                Text('Add item'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 220,
                        child: GlassButton.primary(
                          onPressed: submission.isLoading
                              ? null
                              : _handleSubmit,
                          child: submission.isLoading
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Submit claim'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _priorityLabel(PriorityLevel level) {
    switch (level) {
      case PriorityLevel.low:
        return 'Low';
      case PriorityLevel.normal:
        return 'Normal';
      case PriorityLevel.high:
        return 'High';
      case PriorityLevel.urgent:
        return 'Urgent';
    }
  }

  String _damageLabel(DamageCause cause) {
    switch (cause) {
      case DamageCause.powerSurge:
        return 'Power surge';
      case DamageCause.lightningDamage:
        return 'Lightning damage';
      case DamageCause.liquidDamage:
        return 'Liquid damage';
      case DamageCause.electricalBreakdown:
        return 'Electrical breakdown';
      case DamageCause.mechanicalBreakdown:
        return 'Mechanical breakdown';
      case DamageCause.theft:
        return 'Theft';
      case DamageCause.fire:
        return 'Fire';
      case DamageCause.accidentalImpactDamage:
        return 'Accidental / impact damage';
      case DamageCause.stormDamage:
        return 'Storm damage';
      case DamageCause.wearAndTear:
        return 'Wear & tear';
      case DamageCause.oldAge:
        return 'Old age';
      case DamageCause.negligence:
        return 'Negligence';
      case DamageCause.resultantDamage:
        return 'Resultant damage';
      case DamageCause.other:
        return 'Other';
    }
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.label,
    this.maxLines = 1,
    this.isRequired = true,
    this.validator,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final int maxLines;
  final bool isRequired;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final decoration = buildCaptureFieldDecoration(context, label);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        onChanged: onChanged,
        decoration: decoration,
        validator: (value) {
          if (validator != null) {
            return validator!(value);
          }
          if (!isRequired) return null;
          if (value == null || value.trim().isEmpty) {
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final AsyncValue<List<ReferenceOption>> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final decoration = buildCaptureFieldDecoration(context, label);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: options.when(
        data: (items) => DropdownButtonFormField<String>(
          initialValue: value,
          decoration: decoration,
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item.id,
                  child: Text(item.label),
                ),
              )
              .toList(growable: false),
          onChanged: onChanged,
          validator: (_) {
            if (value == null || value!.isEmpty) {
              return '$label is required';
            }
            return null;
          },
        ),
        loading: () => const ListTile(
          contentPadding: EdgeInsets.zero,
          leading: SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          title: Text('Loading...'),
        ),
        error: (error, _) => ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(
            Icons.error_outline,
            color: RocColors.primaryAccent,
          ),
          title: Text('Failed to load $label options'),
          subtitle: Text(error.toString()),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 22,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClaimItemFormState {
  _ClaimItemFormState()
    : brand = TextEditingController(),
      color = TextEditingController(),
      serial = TextEditingController(),
      notes = TextEditingController();

  final TextEditingController brand;
  final TextEditingController color;
  final TextEditingController serial;
  final TextEditingController notes;
  WarrantyStatus warranty = WarrantyStatus.unknown;
  String? selectedBrandId;
  String? selectedBrandName;
  bool useCustomBrand = false;

  bool get isValid =>
      useCustomBrand ? brand.text.trim().isNotEmpty : selectedBrandId != null;

  ClaimItemDraft toDraft() => ClaimItemDraft(
    brand:
        (useCustomBrand
                ? brand.text.trim()
                : (selectedBrandName ?? brand.text.trim()))
            .trim(),
    color: color.text.trim().isEmpty ? null : color.text.trim(),
    warranty: warranty,
    serialOrModel: serial.text.trim().isEmpty ? null : serial.text.trim(),
    notes: notes.text.trim().isEmpty ? null : notes.text.trim(),
  );

  void dispose() {
    brand.dispose();
    color.dispose();
    serial.dispose();
    notes.dispose();
  }
}

class _ClaimItemCard extends StatefulWidget {
  const _ClaimItemCard({
    required this.item,
    required this.index,
    required this.onRemove,
    required this.brandOptions,
    required this.brandsLoading,
    this.brandsError,
  });

  final _ClaimItemFormState item;
  final int index;
  final VoidCallback onRemove;
  final List<ReferenceOption> brandOptions;
  final bool brandsLoading;
  final Object? brandsError;

  @override
  State<_ClaimItemCard> createState() => _ClaimItemCardState();
}

class _ClaimItemCardState extends State<_ClaimItemCard> {
  static const _otherBrandValue = '__other';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasBrandOptions = widget.brandOptions.isNotEmpty;
    if (!hasBrandOptions && !widget.item.useCustomBrand) {
      widget.item.useCustomBrand = true;
    }
    final showManualField = widget.item.useCustomBrand || !hasBrandOptions;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(
                  label: Text('Item ${widget.index + 1}'),
                  avatar: const Icon(Icons.devices_other_outlined, size: 18),
                  backgroundColor: theme.colorScheme.primary.withValues(
                    alpha: 0.12,
                  ),
                  labelStyle: theme.textTheme.labelLarge,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Remove item',
                  onPressed: widget.onRemove,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (widget.brandsLoading)
              const LinearProgressIndicator(minHeight: 3),
            if (widget.brandsError != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Unable to load brands: ${widget.brandsError}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            if (hasBrandOptions)
              DropdownButtonFormField<String>(
                key: ValueKey(
                  'brand-${widget.index}-${widget.item.useCustomBrand}-${widget.item.selectedBrandId}',
                ),
                initialValue: widget.item.useCustomBrand
                    ? _otherBrandValue
                    : widget.item.selectedBrandId,
                decoration: buildCaptureFieldDecoration(context, 'Brand'),
                items: [
                  for (final option in widget.brandOptions)
                    DropdownMenuItem(
                      value: option.id,
                      child: Text(option.label),
                    ),
                  const DropdownMenuItem(
                    value: _otherBrandValue,
                    child: Text('Other (custom)'),
                  ),
                ],
                onChanged: widget.brandsLoading
                    ? null
                    : (value) {
                        if (value == null) return;
                        if (value == _otherBrandValue) {
                          setState(() {
                            widget.item.useCustomBrand = true;
                            widget.item.selectedBrandId = null;
                            widget.item.selectedBrandName = null;
                            widget.item.brand.clear();
                          });
                        } else {
                          final brand = widget.brandOptions.firstWhere(
                            (option) => option.id == value,
                          );
                          setState(() {
                            widget.item.useCustomBrand = false;
                            widget.item.selectedBrandId = brand.id;
                            widget.item.selectedBrandName = brand.label;
                            widget.item.brand.text = brand.label;
                          });
                        }
                      },
                validator: (_) {
                  if (widget.item.useCustomBrand) return null;
                  if (widget.item.selectedBrandId == null) {
                    return 'Select a brand';
                  }
                  return null;
                },
              )
            else
              InputDecorator(
                decoration: buildCaptureFieldDecoration(context, 'Brand'),
                child: Text(
                  widget.brandsLoading
                      ? 'Loading brands…'
                      : 'No brands found. Enter a custom brand below or add brands in Admin > Brands.',
                ),
              ),
            if (showManualField) ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: widget.item.brand,
                decoration: buildCaptureFieldDecoration(
                  context,
                  'Brand name (custom)',
                ),
                validator: (value) {
                  if (!(widget.item.useCustomBrand || !hasBrandOptions)) {
                    return null;
                  }
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter the brand name';
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 12),
            TextFormField(
              controller: widget.item.serial,
              decoration: buildCaptureFieldDecoration(
                context,
                'Serial or model',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: widget.item.color,
              decoration: buildCaptureFieldDecoration(context, 'Color'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<WarrantyStatus>(
              initialValue: widget.item.warranty,
              decoration: buildCaptureFieldDecoration(
                context,
                'Warranty status',
              ),
              items: WarrantyStatus.values
                  .map(
                    (status) => DropdownMenuItem(
                      value: status,
                      child: Text(_warrantyLabel(status)),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    widget.item.warranty = value;
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: widget.item.notes,
              decoration: buildCaptureFieldDecoration(context, 'Item notes'),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  String _warrantyLabel(WarrantyStatus status) {
    switch (status) {
      case WarrantyStatus.inWarranty:
        return 'In warranty';
      case WarrantyStatus.outOfWarranty:
        return 'Out of warranty';
      case WarrantyStatus.unknown:
        return 'Unknown';
    }
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(DesignTokens.spaceL),
      child: child,
    );
  }
}

class _AddressPredictionsList extends StatelessWidget {
  const _AddressPredictionsList({
    required this.predictions,
    required this.onSelected,
  });

  final List<_Prediction> predictions;
  final ValueChanged<_Prediction> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.hardEdge,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < predictions.length; i++) ...[
              if (i > 0) const Divider(height: 1),
              InkWell(
                onTap: () {
                  onSelected(predictions[i]);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.place_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          predictions[i].description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SelectedAddressSummary extends StatelessWidget {
  const _SelectedAddressSummary({
    required this.description,
    this.isSelected = false,
  });

  final String description;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.7)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.check_circle : Icons.place_outlined,
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? theme.colorScheme.onPrimaryContainer : null,
              ),
            ),
          ),
          if (isSelected)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                'Selected',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AddressSummaryCard extends StatelessWidget {
  const _AddressSummaryCard({
    required this.hasAddress,
    required this.description,
    required this.estateName,
    required this.street,
    required this.suburb,
    required this.city,
    required this.province,
    required this.postalCode,
    required this.lat,
    required this.lng,
    this.notes,
  });

  final bool hasAddress;
  final String? description;
  final String? estateName;
  final String street;
  final String suburb;
  final String city;
  final String province;
  final String postalCode;
  final double? lat;
  final double? lng;
  final String? notes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: hasAddress ? _buildDetails(theme) : _buildPlaceholder(theme),
    );
  }

  Widget _buildDetails(ThemeData theme) {
    final rows = <Widget>[
      if (description != null)
        Text(
          description!,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      const SizedBox(height: 8),
      _DetailRow(label: 'Estate', value: estateName),
      _DetailRow(label: 'Street', value: street),
      _DetailRow(label: 'Suburb', value: suburb),
      _DetailRow(label: 'City / Town', value: city),
      Row(
        children: [
          Expanded(
            child: _DetailRow(label: 'Province', value: province),
          ),
          Expanded(
            child: _DetailRow(label: 'Postal code', value: postalCode),
          ),
        ],
      ),
      if (lat != null && lng != null)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Pinned at ${lat!.toStringAsFixed(5)}, ${lng!.toStringAsFixed(5)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      if (notes != null && notes!.trim().isNotEmpty) ...[
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.note_outlined,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  notes!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ];

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows);
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Row(
      children: [
        Icon(Icons.map_outlined, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'No address captured yet. Use “Set address” to search via Google Maps.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: Text(value!, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _AddressComponent {
  const _AddressComponent({required this.longName, required this.types});

  final String longName;
  final List<String> types;
}

class _AddressSnapshot {
  const _AddressSnapshot({
    required this.addressMode,
    required this.selectedAddressId,
    required this.selectedPlaceId,
    required this.selectedPlaceDescription,
    required this.complex,
    required this.unit,
    required this.street,
    required this.suburb,
    required this.city,
    required this.province,
    required this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.staticMapUrl,
    required this.estateId,
    required this.searchQuery,
    required this.notes,
    this.autoStreet,
    this.autoSuburb,
    this.autoCity,
    this.autoProvince,
    this.autoPostalCode,
  });

  final AddressMode addressMode;
  final String? selectedAddressId;
  final String? selectedPlaceId;
  final String? selectedPlaceDescription;
  final String complex;
  final String unit;
  final String street;
  final String suburb;
  final String city;
  final String province;
  final String postalCode;
  final double? latitude;
  final double? longitude;
  final String? staticMapUrl;
  final String? estateId;
  final String searchQuery;
  final String notes;
  final String? autoStreet;
  final String? autoSuburb;
  final String? autoCity;
  final String? autoProvince;
  final String? autoPostalCode;
}

class _CaptureHero extends StatelessWidget {
  const _CaptureHero({
    required this.onBackToQueue,
    required this.onManageInsurers,
  });

  final VoidCallback onBackToQueue;
  final VoidCallback onManageInsurers;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;
    final textColor = theme.colorScheme.onPrimary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primary.withValues(alpha: 0.22),
            secondary.withValues(alpha: 0.12),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 32,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Capture a new claim',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Verify policy details, capture complete contact information and note every incident detail before dispatch.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: textColor.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.end,
                children: [
                  GlassButton.primary(
                    onPressed: onBackToQueue,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.list_alt_outlined),
                        SizedBox(width: DesignTokens.spaceS),
                        Text('Back to queue'),
                      ],
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: onManageInsurers,
                    icon: const Icon(Icons.domain_outlined),
                    label: const Text('Manage insurers'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textColor.withValues(alpha: 0.9),
                      side: BorderSide(color: textColor.withValues(alpha: 0.4)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _HeroBadge(
                icon: Icons.assignment_turned_in_outlined,
                label: 'Confirm policy and contract status',
              ),
              _HeroBadge(
                icon: Icons.phone_outlined,
                label: 'Capture every client contact detail',
              ),
              _HeroBadge(
                icon: Icons.timer_outlined,
                label: 'Set the right priority and SLA window',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _Prediction {
  const _Prediction({required this.description, required this.placeId});

  final String description;
  final String? placeId;

  static _Prediction? fromMobile(AutocompletePrediction source) {
    final placeId = source.placeId;
    final description = source.description;
    if (placeId == null || description == null || description.isEmpty) {
      return null;
    }
    return _Prediction(description: description, placeId: placeId);
  }

  static _Prediction? fromWebJson(Map<String, dynamic> json) {
    final placeId = json['place_id'] as String?;
    final description = (json['description'] as String?)?.trim();
    if (placeId == null || description == null || description.isEmpty) {
      return null;
    }
    return _Prediction(description: description, placeId: placeId);
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
          Switch.adaptive(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
