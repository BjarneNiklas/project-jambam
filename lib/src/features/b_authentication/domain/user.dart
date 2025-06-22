import 'package:flutter/foundation.dart';
import 'package:project_jambam/src/features/a_ideation/domain/accessibility_system.dart';

@immutable
class User {
  const User({
    required this.id,
    required this.email,
    required this.displayName,
    this.avatar,
    this.bio,
    this.interests = const [],
    this.skillLevel = SkillLevel.beginner,
    this.learningStyle = LearningStyle.visual,
    this.accessibilityNeeds = const [],
    this.reputation = 0,
    this.badges = const [],
    this.researchPoints = 0,
    this.followers = const [],
    this.following = const [],
    this.isEmailVerified = false,
    this.isAnonymous = false, // Added isAnonymous field
    this.createdAt,
    this.lastActive,
    this.preferences = const UserPreferences(),
    this.statistics = const UserStatistics(),
  });

  final String id;
  final String email;
  final String displayName;
  final String? avatar;
  final String? bio;
  final List<String> interests;
  final SkillLevel skillLevel;
  final LearningStyle learningStyle;
  final List<AccessibilityNeed> accessibilityNeeds;
  final int reputation;
  final List<String> badges;
  final int researchPoints;
  final List<String> followers; // User IDs
  final List<String> following; // User IDs
  final bool isEmailVerified;
  final bool isAnonymous; // Added field
  final DateTime? createdAt;
  final DateTime? lastActive;
  final UserPreferences preferences;
  final UserStatistics statistics;

  /// Create a copy of this user with updated fields
  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? avatar,
    String? bio,
    List<String>? interests,
    SkillLevel? skillLevel,
    LearningStyle? learningStyle,
    List<AccessibilityNeed>? accessibilityNeeds,
    int? reputation,
    List<String>? badges,
    int? researchPoints,
    List<String>? followers,
    List<String>? following,
    bool? isEmailVerified,
    bool? isAnonymous, // Added isAnonymous
    DateTime? createdAt,
    DateTime? lastActive,
    UserPreferences? preferences,
    UserStatistics? statistics,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      skillLevel: skillLevel ?? this.skillLevel,
      learningStyle: learningStyle ?? this.learningStyle,
      accessibilityNeeds: accessibilityNeeds ?? this.accessibilityNeeds,
      reputation: reputation ?? this.reputation,
      badges: badges ?? this.badges,
      researchPoints: researchPoints ?? this.researchPoints,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isAnonymous: isAnonymous ?? this.isAnonymous, // Added isAnonymous
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      preferences: preferences ?? this.preferences,
      statistics: statistics ?? this.statistics,
    );
  }

  // /// Check if user is anonymous
  // bool get isAnonymous => email.isEmpty || email == 'anonymous@jambam.com'; // Removed getter

  /// Check if user is verified
  bool get isVerified => isEmailVerified;

  /// Get user level based on reputation
  UserLevel get level {
    if (reputation >= 10000) return UserLevel.legend;
    if (reputation >= 5000) return UserLevel.expert;
    if (reputation >= 1000) return UserLevel.advanced;
    if (reputation >= 100) return UserLevel.intermediate;
    return UserLevel.beginner;
  }

  /// Get user role based on badges and activity
  UserRole get role {
    if (badges.contains('admin')) return UserRole.admin;
    if (badges.contains('moderator')) return UserRole.moderator;
    if (badges.contains('researcher')) return UserRole.researcher;
    if (badges.contains('inspirator')) return UserRole.inspirator;
    if (badges.contains('developer')) return UserRole.developer;
    return UserRole.contributor;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User(id: $id, email: $email, displayName: $displayName)';
  }
}

/// User levels based on reputation
enum UserLevel {
  beginner, // 0-99 reputation
  intermediate, // 100-999 reputation
  advanced, // 1000-4999 reputation
  expert, // 5000-9999 reputation
  legend, // 10000+ reputation
}

/// User roles based on badges and activity
enum UserRole {
  contributor, // Basic community member
  inspirator, // Creates popular jam seeds
  developer, // Creates jam kits and games
  researcher, // Conducts experiments in jam lab
  moderator, // Community moderator
  admin, // System administrator
}

/// User preferences
class UserPreferences {
  const UserPreferences({
    this.notifications = const NotificationPreferences(),
    this.privacy = const PrivacyPreferences(),
    this.accessibility = const AccessibilityPreferences(),
    this.theme = ThemePreference.system,
    this.language = 'en',
  });

  final NotificationPreferences notifications;
  final PrivacyPreferences privacy;
  final AccessibilityPreferences accessibility;
  final ThemePreference theme;
  final String language;
}

class NotificationPreferences {
  const NotificationPreferences({
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.communityUpdates = true,
    this.researchUpdates = true,
    this.achievementNotifications = true,
    this.followerNotifications = true,
  });

  final bool emailNotifications;
  final bool pushNotifications;
  final bool communityUpdates;
  final bool researchUpdates;
  final bool achievementNotifications;
  final bool followerNotifications;
}

class PrivacyPreferences {
  const PrivacyPreferences({
    this.profileVisibility = ProfileVisibility.public,
    this.showEmail = false,
    this.showActivity = true,
    this.allowFollowRequests = true,
    this.allowMessages = true,
  });

  final ProfileVisibility profileVisibility;
  final bool showEmail;
  final bool showActivity;
  final bool allowFollowRequests;
  final bool allowMessages;
}

enum ProfileVisibility {
  public,
  followers,
  private,
}

class AccessibilityPreferences {
  const AccessibilityPreferences({
    this.screenReaderSupport = true,
    this.highContrastMode = false,
    this.largeText = false,
    this.reducedMotion = false,
    this.voiceNavigation = false,
  });

  final bool screenReaderSupport;
  final bool highContrastMode;
  final bool largeText;
  final bool reducedMotion;
  final bool voiceNavigation;
}

enum ThemePreference {
  light,
  dark,
  system,
}

/// User statistics
class UserStatistics {
  const UserStatistics({
    this.jamSeedsCreated = 0,
    this.jamKitsGenerated = 0,
    this.communityContributions = 0,
    this.experimentsConducted = 0,
    this.followers = 0,
    this.following = 0,
    this.reputation = 0,
    this.badges = const [],
    this.researchPoints = 0,
    this.totalPlayTime = Duration.zero,
    this.lastActive,
  });

  final int jamSeedsCreated;
  final int jamKitsGenerated;
  final int communityContributions;
  final int experimentsConducted;
  final int followers;
  final int following;
  final int reputation;
  final List<String> badges;
  final int researchPoints;
  final Duration totalPlayTime;
  final DateTime? lastActive;
} 