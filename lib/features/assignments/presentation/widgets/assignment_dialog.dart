import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../../../core/widgets/glass_dialog.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../claims/presentation/widgets/technician_selector.dart';
import '../../../claims/presentation/widgets/appointment_picker.dart';
import '../../controller/assignment_controller.dart';

/// Dialog for assigning or reassigning a technician to a job.
class AssignmentDialog extends ConsumerStatefulWidget {
  const AssignmentDialog({
    super.key,
    required this.claimId,
    this.currentTechnicianId,
    this.currentAppointmentDate,
    this.currentAppointmentTime,
  });

  final String claimId;
  final String? currentTechnicianId;
  final DateTime? currentAppointmentDate;
  final String? currentAppointmentTime;

  @override
  ConsumerState<AssignmentDialog> createState() => _AssignmentDialogState();
}

class _AssignmentDialogState extends ConsumerState<AssignmentDialog> {
  String? _selectedTechnicianId;
  DateTime? _selectedAppointmentDate;
  String? _selectedAppointmentTime;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedTechnicianId = widget.currentTechnicianId;
    _selectedAppointmentDate = widget.currentAppointmentDate;
    _selectedAppointmentTime = widget.currentAppointmentTime;
  }

  Future<void> _save() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final controller = ref.read(assignmentControllerProvider.notifier);
      await controller.assignTechnician(
        claimId: widget.claimId,
        technicianId: _selectedTechnicianId,
        appointmentDate: _selectedAppointmentDate,
        appointmentTime: _selectedAppointmentTime,
      );

      if (!mounted) return;
      
      Navigator.of(context).pop(true); // Return true to indicate success
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Technician and appointment updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update assignment: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassDialog(
      title: Text(
        widget.currentTechnicianId != null ? 'Reassign Technician' : 'Assign Technician',
      ),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
      ),
      actions: [
        GlassButton.ghost(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        GlassButton.primary(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}

