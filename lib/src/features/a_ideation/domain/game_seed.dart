import 'package:flutter/foundation.dart';

/// 🎮 Game Seed - Spielidee für langfristige Projekte
/// 
/// Ein Game Seed ist eine konkrete, aber flexible Spielidee für langfristige Projekte.
/// Er enthält explizite Genre-Zuweisungen und wird oft durch das KI-Multi-Agenten-System generiert.
/// 
/// Eigenschaften:
/// - Genre-spezifisch: Enthält explizite Genre-Zuweisungen
/// - Flexibel: Ermöglicht verschiedene Umsetzungsansätze
/// - Langfristig: Für professionelle Spielentwicklung gedacht
/// - KI-generiert: Oft durch KI-Multi-Agenten-System erstellt
/// 
/// Verwendung: Dient als Startpunkt für professionelle Spielentwicklung, kann sich zu einer Development Blueprint entwickeln.
@immutable
class GameSeed {
  const GameSeed({
    required this.id,
    required this.title,
    required this.coreConcept, // Core concept with genre focus
    required this.suggestedMechanics, // Suggested game mechanics
    required this.roughStoryIdea, // Rough story idea
    required this.genres, // EXPLICIT genres for this game seed
    this.inspirationElements = const [], // Keywords, ideas, references
    this.creativeConstraints = const [], // Guidelines, not rules
    this.suggestedArtStyle, // Suggested art style
    this.targetAudience, // Target audience
    this.monetizationStrategy, // Monetization strategy
    this.aiGenerated = true, // True if AI-generated, false if community-created
    this.createdAt,
  });

  final String id;
  final String title;
  final String coreConcept; // Core concept with genre focus
  final List<String> suggestedMechanics; // Suggested game mechanics
  final String roughStoryIdea; // Rough story idea
  final List<String> genres; // EXPLICIT genres e.g., ['Action-Adventure', 'Sandbox']
  final List<String> inspirationElements; // Keywords, ideas, references
  final List<String> creativeConstraints; // Guidelines, not rules
  final String? suggestedArtStyle; // Suggested art style
  final String? targetAudience; // Target audience
  final String? monetizationStrategy; // Monetization strategy
  final bool aiGenerated; // True if AI-generated, false if community-created
  final DateTime? createdAt;
}
