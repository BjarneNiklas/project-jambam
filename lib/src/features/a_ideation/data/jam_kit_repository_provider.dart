import 'package:project_jambam/src/features/a_ideation/application/concept_generation_service.dart';
import 'package:project_jambam/src/features/a_ideation/data/api_jam_kit_repository.dart';
import 'package:project_jambam/src/features/a_ideation/data/agentic_concept_generation_service.dart';
import 'package:project_jambam/src/features/a_ideation/domain/jam_kit_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:project_jambam/src/features/a_ideation/data/llm_concept_generation_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'jam_kit_repository_provider.g.dart';

@riverpod
ConceptGenerationService conceptGenerationService(Ref ref) {
  // --- EXPERIMENT: Switch between RAG and Agenten-Modus ---
  // RAG-Modus:
  // return RagConceptGenerationService(
  //   knowledgeRetriever: ref.watch(knowledgeRetrieverServiceProvider),
  //   llmService: LlmConceptGenerationService(),
  // );

  // Agenten-Modus:
  return AgenticConceptGenerationService(
    llmService: LlmConceptGenerationService(),
  );
}

@riverpod
JamKitRepository jamKitRepository(Ref ref) {
  // This is where the magic happens. We provide the *real* repository,
  // which in turn depends on our real AI service.
  return ApiJamKitRepository(
    conceptGenerationService: ref.watch(conceptGenerationServiceProvider),
  );
  // To switch back to mock data, simply comment out the line above and
  // uncomment the line below.
  // return MockJamKitRepository();
} 