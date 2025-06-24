import 'package:flutter/foundation.dart';
import 'package:project_jambam/src/features/a_ideation/domain/game_seed.dart';
import 'package:project_jambam/src/features/a_ideation/domain/jam_kit.dart'; // Import existing JamKit for potential reuse of types

/// 📋 Game Kit (Development Blueprint) - Umfassende Blaupause für langfristige Spielentwicklung
/// 
/// Ein Game Kit ist eine umfassende, detaillierte Blaupause für langfristige Spielentwicklung.
/// Er entwickelt sich aus Game Seeds und enthält vollständige Entwicklungsanleitungen.
/// 
/// Eigenschaften:
/// - Umfassend: Vollständige Entwicklungsanleitung
/// - Detailliert: Ausführliche Spezifikationen und Ressourcen
/// - Skalierbar: Für professionelle, kommerzielle Entwicklung
/// - Genre-definiert: Klare Genre-Klassifizierung
/// 
/// Verwendung: Wird für professionelle, langfristige Spielentwicklung verwendet.
@immutable
class DevelopmentBlueprint {
  const DevelopmentBlueprint({
    required this.id,
    required this.title,
    required this.coreConcept, // Detailed core concept
    required this.genres, // EXPLICIT genres for the blueprint
    required this.quests, // Comprehensive quest structure
    required this.assetSpecifications, // Detailed asset requirements
    required this.constructionGuides, // Comprehensive construction guides
    this.sourceGameSeed, // Link back to the original Game Seed
    this.technicalSpecifications, // Technical specifications
    this.monetizationStrategy, // Monetization strategy
    this.targetPlatforms = const [], // Target platforms
    this.estimatedDevelopmentTime, // Estimated development time
    this.createdAt,
  });

  final String id;
  final String title;
  final String coreConcept; // Detailed core concept
  final List<String> genres; // EXPLICIT genres e.g., ['Action-Adventure', 'Open-World-RPG']
  final List<Quest> quests; // Comprehensive quest structure
  final List<AssetSpecification> assetSpecifications; // Detailed asset requirements
  final List<ConstructionGuide> constructionGuides; // Comprehensive construction guides
  final GameSeed? sourceGameSeed; // The Game Seed this Blueprint evolved from
  final String? technicalSpecifications; // Technical specifications
  final String? monetizationStrategy; // Monetization strategy
  final List<String> targetPlatforms; // Target platforms
  final Duration? estimatedDevelopmentTime; // Estimated development time
  final DateTime? createdAt;
}

/// Represents detailed asset requirements for a Development Blueprint.
/// These are comprehensive specifications for professional game development.
@immutable
class AssetSpecification {
  const AssetSpecification({
    required this.type,
    required this.description,
    required this.styleGuide, // Detailed prompt or reference for art style
    this.polycountRange, // e.g., 'low', 'medium', 'high' or specific numbers
    this.textureResolution, // e.g., '256x256', '1024x1024'
    this.animationRequirements, // e.g., 'idle', 'walk', 'attack'
    this.fileFormats = const [], // e.g., 'fbx', 'gltf', 'usd'
  });

  final String type; // e.g., 'character_model', 'environment_prop', 'UI_element'
  final String description;
  final String styleGuide; // Detailed prompt or reference for art style
  final String? polycountRange;
  final String? textureResolution;
  final List<String>? animationRequirements;
  final List<String> fileFormats;
}

// Reusing Quest and ConstructionGuide from jam_kit.dart if they are suitable.
// If not, they would need to be redefined or adapted here.
// For simplicity, assuming they are suitable for reuse.
