import 'package:project_jambam/src/features/c_community_voting/domain/community_theme.dart';

/// Abstract interface for a repository that handles all data operations
/// related to community-submitted themes.
abstract class CommunityThemeRepository {
  /// Fetches a list of all community themes, usually sorted by vote count.
  Future<List<CommunityTheme>> fetchThemes();

  /// Submits a vote for a specific theme.
  /// Throws an exception if the operation fails.
  Future<void> voteForTheme(String themeId);

  /// Submits a new theme suggestion.
  /// Throws an exception if the operation fails.
  Future<void> submitTheme({
    required String title,
    required String description,
  });
} 