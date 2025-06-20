import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'agent_config_provider.g.dart';

class AgentActivationConfig {
  const AgentActivationConfig({
    this.useMechanics = true,
    this.useMonetization = true,
  });

  final bool useMechanics;
  final bool useMonetization;

  AgentActivationConfig copyWith({
    bool? useMechanics,
    bool? useMonetization,
  }) {
    return AgentActivationConfig(
      useMechanics: useMechanics ?? this.useMechanics,
      useMonetization: useMonetization ?? this.useMonetization,
    );
  }
}

@riverpod
class AgentConfig extends _$AgentConfig {
  @override
  AgentActivationConfig build() {
    return const AgentActivationConfig();
  }

  void setUseMechanics(bool value) {
    state = state.copyWith(useMechanics: value);
  }

  void setUseMonetization(bool value) {
    state = state.copyWith(useMonetization: value);
  }
} 