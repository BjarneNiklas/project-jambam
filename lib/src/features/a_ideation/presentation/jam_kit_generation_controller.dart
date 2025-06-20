import 'dart:async';

import 'package:project_jambam/src/features/a_ideation/data/jam_kit_repository_provider.dart';
import 'package:project_jambam/src/features/a_ideation/domain/jam_kit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../application/concept_generation_service.dart';

part 'jam_kit_generation_controller.g.dart';

class AgentConfig {
  const AgentConfig({this.useMechanics = true, this.useMonetization = true});
  final bool useMechanics;
  final bool useMonetization;

  AgentConfig copyWith({bool? useMechanics, bool? useMonetization}) {
    return AgentConfig(
      useMechanics: useMechanics ?? this.useMechanics,
      useMonetization: useMonetization ?? this.useMonetization,
    );
  }
}

@riverpod
class JamKitGenerationController extends _$JamKitGenerationController {
  AgentConfig _agentConfig = const AgentConfig();

  @override
  FutureOr<JamKit?> build() {
    // Return null initially, as no Jam Kit has been generated yet.
    return null;
  }

  AgentConfig get currentAgentConfig => _agentConfig;

  void setUseMechanics(bool value) {
    _agentConfig = _agentConfig.copyWith(useMechanics: value);
  }

  void setUseMonetization(bool value) {
    _agentConfig = _agentConfig.copyWith(useMonetization: value);
  }

  Future<void> generateJamKit({
    required List<String> keywords,
    String inspirationMode = 'creative',
    GenerationMode generationMode = GenerationMode.jamKit,
    bool useMechanics = true,
    bool useMonetization = true,
  }) async {
    state = const AsyncLoading();
    final jamKitRepository = ref.read(jamKitRepositoryProvider);

    final input = ConceptGenerationInput(
      keywords: keywords,
      inspirationMode: inspirationMode,
      generationMode: generationMode,
      useMechanics: useMechanics,
      useMonetization: useMonetization,
    );

    state = await AsyncValue.guard(
      () => jamKitRepository.generateJamKit(input),
    );
  }
} 