// This file will define the abstract interface for a repository that handles
// all data operations related to Jam Kits. The UI layer will depend on this
// abstraction, allowing us to swap out the implementation (e.g., from a mock
// repository to a real API repository) without changing the UI code.

// Future<JamKit> generateJamKit({required List<String> keywords}); 

import 'package:project_jambam/src/features/a_ideation/domain/jam_kit.dart';
import '../application/concept_generation_service.dart';

/// Abstract interface for a repository that handles all data operations
/// related to Jam Kits.
abstract class JamKitRepository {
  /// Takes a set of user-defined keywords and generates a complete "Jam Kit"
  /// using the AI Innovation Assistant.
  Future<JamKit> generateJamKit(ConceptGenerationInput input);

  /// Legacy method for backward compatibility
  @Deprecated('Use generateJamKit(ConceptGenerationInput input) instead')
  Future<JamKit> generateJamKitLegacy({
    required List<String> keywords,
    String? inspirationMode,
  });
} 