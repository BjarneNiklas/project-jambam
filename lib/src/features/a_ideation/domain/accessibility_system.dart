import 'package:flutter/foundation.dart';

@immutable
class AccessibilityProfile {
  const AccessibilityProfile({
    required this.id,
    required this.name,
    required this.description,
    required this.skillLevel,
    required this.learningStyle,
    this.accessibilityNeeds = const [],
    this.preferredLanguages = const ['en'],
    this.timeAvailability = TimeAvailability.flexible,
    this.deviceCapabilities = const [],
    this.learningGoals = const [],
    this.previousExperience = const [],
  });

  final String id;
  final String name;
  final String description;
  final SkillLevel skillLevel;
  final LearningStyle learningStyle;
  final List<AccessibilityNeed> accessibilityNeeds;
  final List<String> preferredLanguages;
  final TimeAvailability timeAvailability;
  final List<DeviceCapability> deviceCapabilities;
  final List<LearningGoal> learningGoals;
  final List<String> previousExperience;
}

enum SkillLevel {
  absoluteBeginner, // No programming experience
  beginner, // Basic computer skills
  intermediate, // Some programming knowledge
  advanced, // Experienced developer
  expert, // Professional game developer
}

enum LearningStyle {
  visual, // Prefers diagrams, videos, visual guides
  auditory, // Prefers audio explanations, podcasts
  kinesthetic, // Prefers hands-on, interactive learning
  reading, // Prefers text-based learning
  social, // Prefers learning with others
  experimental, // Prefers trial and error
}

enum AccessibilityNeed {
  visualImpairment, // Screen readers, high contrast
  hearingImpairment, // Captions, visual indicators
  motorImpairment, // Voice control, simplified UI
  cognitiveImpairment, // Simplified language, step-by-step
  colorBlindness, // Color alternatives, patterns
  dyslexia, // Font options, audio support
  anxiety, // Calm UI, clear expectations
  timeConstraints, // Quick start options
  languageBarrier, // Multi-language support
}

enum TimeAvailability {
  veryLimited, // 15-30 minutes per session
  limited, // 30-60 minutes per session
  flexible, // 1-2 hours per session
  generous, // 2+ hours per session
  unlimited, // Full-time availability
}

enum DeviceCapability {
  lowEndMobile, // Basic smartphone
  modernMobile, // Recent smartphone
  tablet, // iPad, Android tablet
  laptop, // Basic laptop
  desktop, // Gaming PC/workstation
  vrHeadset, // VR/AR capabilities
  multipleDevices, // Cross-device development
}

enum LearningGoal {
  hobby, // Just for fun
  skillDevelopment, // Learn new skills
  careerChange, // Switch to game development
  portfolio, // Build portfolio
  startup, // Create commercial game
  education, // Academic purposes
  social, // Meet like-minded people
}

@immutable
class AdaptiveContent {
  const AdaptiveContent({
    required this.id,
    required this.baseContent,
    required this.adaptations,
    this.accessibilityFeatures = const [],
    this.learningPath = const [],
  });

  final String id;
  final String baseContent;
  final Map<SkillLevel, String> adaptations;
  final List<AccessibilityFeature> accessibilityFeatures;
  final List<LearningStep> learningPath;
}

enum AccessibilityFeature {
  screenReaderSupport,
  highContrastMode,
  largeText,
  voiceNavigation,
  keyboardOnly,
  captions,
  audioDescriptions,
  simplifiedLanguage,
  stepByStepGuide,
  visualAids,
  interactiveTutorials,
  progressTracking,
  adaptiveDifficulty,
}

@immutable
class LearningStep {
  const LearningStep({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.skillLevel,
    this.prerequisites = const [],
    this.resources = const [],
    this.checkpoints = const [],
    this.alternativePaths = const [],
  });

  final String id;
  final String title;
  final String description;
  final Duration duration;
  final SkillLevel skillLevel;
  final List<String> prerequisites;
  final List<LearningResource> resources;
  final List<Checkpoint> checkpoints;
  final List<LearningPath> alternativePaths;
}

@immutable
class LearningResource {
  const LearningResource({
    required this.id,
    required this.title,
    required this.type,
    required this.url,
    required this.skillLevel,
    this.description,
    this.duration,
    this.accessibilityFeatures = const [],
  });

  final String id;
  final String title;
  final ResourceType type;
  final String url;
  final SkillLevel skillLevel;
  final String? description;
  final Duration? duration;
  final List<AccessibilityFeature> accessibilityFeatures;
}

enum ResourceType {
  video,
  article,
  interactive,
  codeExample,
  template,
  community,
  mentor,
  tool,
}

@immutable
class Checkpoint {
  const Checkpoint({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.criteria = const [],
    this.feedback = const [],
  });

  final String id;
  final String title;
  final String description;
  final CheckpointType type;
  final List<String> criteria;
  final List<String> feedback;
}

enum CheckpointType {
  quiz,
  practical,
  review,
  peer,
  mentor,
  automated,
}

@immutable
class LearningPath {
  const LearningPath({
    required this.id,
    required this.name,
    required this.description,
    required this.targetSkillLevel,
    required this.steps,
    this.estimatedDuration,
    this.successRate,
    this.alternatives = const [],
  });

  final String id;
  final String name;
  final String description;
  final SkillLevel targetSkillLevel;
  final List<LearningStep> steps;
  final Duration? estimatedDuration;
  final double? successRate;
  final List<LearningPath> alternatives;
}

@immutable
class OnboardingFlow {
  const OnboardingFlow({
    required this.id,
    required this.steps,
    this.adaptiveQuestions = const [],
    this.recommendations = const [],
  });

  final String id;
  final List<OnboardingStep> steps;
  final List<AdaptiveQuestion> adaptiveQuestions;
  final List<Recommendation> recommendations;
}

@immutable
class OnboardingStep {
  const OnboardingStep({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.options = const [],
    this.helpText,
    this.skipOption = false,
  });

  final String id;
  final String title;
  final String description;
  final OnboardingStepType type;
  final List<String> options;
  final String? helpText;
  final bool skipOption;
}

enum OnboardingStepType {
  skillAssessment,
  goalSetting,
  timeAvailability,
  deviceCheck,
  accessibilityNeeds,
  learningStyle,
  experienceLevel,
  interests,
  communityPreferences,
}

@immutable
class AdaptiveQuestion {
  const AdaptiveQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.logic,
  });

  final String id;
  final String question;
  final List<QuestionOption> options;
  final QuestionLogic logic;
}

@immutable
class QuestionOption {
  const QuestionOption({
    required this.id,
    required this.text,
    required this.value,
    this.nextQuestion,
    this.recommendations = const [],
  });

  final String id;
  final String text;
  final String value;
  final String? nextQuestion;
  final List<String> recommendations;
}

@immutable
class QuestionLogic {
  const QuestionLogic({
    this.skillLevelAdjustment = 0,
    this.learningStyleWeight = const {},
    this.accessibilityFlags = const [],
    this.timeAdjustment = 0,
  });

  final int skillLevelAdjustment;
  final Map<LearningStyle, double> learningStyleWeight;
  final List<AccessibilityNeed> accessibilityFlags;
  final int timeAdjustment;
}

@immutable
class Recommendation {
  const Recommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.priority,
    this.resources = const [],
    this.community = const [],
    this.tools = const [],
  });

  final String id;
  final String title;
  final String description;
  final RecommendationType type;
  final int priority;
  final List<LearningResource> resources;
  final List<String> community;
  final List<String> tools;
}

enum RecommendationType {
  learningPath,
  community,
  tool,
  mentor,
  project,
  challenge,
  resource,
}

@immutable
class ProgressTracker {
  const ProgressTracker({
    required this.userId,
    required this.currentPath,
    required this.completedSteps,
    required this.skillLevel,
    this.achievements = const [],
    this.challenges = const [],
    this.nextSteps = const [],
    this.mentorConnections = const [],
  });

  final String userId;
  final LearningPath currentPath;
  final List<String> completedSteps;
  final SkillLevel skillLevel;
  final List<Achievement> achievements;
  final List<Challenge> challenges;
  final List<LearningStep> nextSteps;
  final List<String> mentorConnections;
}

@immutable
class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.earnedAt,
    this.badge,
    this.points,
  });

  final String id;
  final String title;
  final String description;
  final AchievementType type;
  final DateTime earnedAt;
  final String? badge;
  final int? points;
}

enum AchievementType {
  skill,
  community,
  project,
  learning,
  mentorship,
  innovation,
}

@immutable
class Challenge {
  const Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.duration,
    this.rewards = const [],
    this.support = const [],
  });

  final String id;
  final String title;
  final String description;
  final SkillLevel difficulty;
  final Duration duration;
  final List<String> rewards;
  final List<String> support;
} 