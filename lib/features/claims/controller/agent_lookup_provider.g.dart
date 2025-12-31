// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_lookup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(agentName)
const agentNameProvider = AgentNameFamily._();

final class AgentNameProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  const AgentNameProvider._({
    required AgentNameFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'agentNameProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$agentNameHash();

  @override
  String toString() {
    return r'agentNameProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    final argument = this.argument as String?;
    return agentName(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AgentNameProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$agentNameHash() => r'1b21154e419705b30a79a1dbfc1958d3255e8572';

final class AgentNameFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String?>, String?> {
  const AgentNameFamily._()
    : super(
        retry: null,
        name: r'agentNameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  AgentNameProvider call(String? agentId) =>
      AgentNameProvider._(argument: agentId, from: this);

  @override
  String toString() => r'agentNameProvider';
}
