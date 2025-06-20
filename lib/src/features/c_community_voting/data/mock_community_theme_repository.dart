import 'dart:math';

import 'package:project_jambam/src/features/c_community_voting/domain/community_theme.dart';
import 'package:project_jambam/src/features/c_community_voting/domain/community_theme_repository.dart';

class MockCommunityThemeRepository implements CommunityThemeRepository {
  final List<CommunityTheme> _themes = [
    const CommunityTheme(
      id: 'theme-1',
      title: 'Cyber-Noir Detective',
      description: 'A story-driven game in a rainy, neon-lit city.',
      submitter: 'UserA',
      voteCount: 128,
    ),
    const CommunityTheme(
      id: 'theme-2',
      title: 'Solar Punk Utopia',
      description: 'A crafting and exploration game about building a sustainable future.',
      submitter: 'UserB',
      voteCount: 95,
    ),
    const CommunityTheme(
      id: 'theme-3',
      title: 'Arcane Kitchen Mayhem',
      description: 'A chaotic cooking game with magical ingredients.',
      submitter: 'UserC',
      voteCount: 72,
    ),
  ];

  @override
  Future<List<CommunityTheme>> fetchThemes() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _themes.sort((a, b) => b.voteCount.compareTo(a.voteCount));
    return _themes;
  }

  @override
  Future<void> voteForTheme(String themeId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _themes.indexWhere((t) => t.id == themeId);
    if (index != -1) {
      final theme = _themes[index];
      _themes[index] = CommunityTheme(
        id: theme.id,
        title: theme.title,
        description: theme.description,
        submitter: theme.submitter,
        voteCount: theme.voteCount + 1,
      );
    }
  }

  @override
  Future<void> submitTheme({
    required String title,
    required String description,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newTheme = CommunityTheme(
      id: 'theme-${Random().nextInt(1000)}',
      title: title,
      description: description,
      submitter: 'CurrentUser', // In a real app, this would be the actual user
      voteCount: 1,
    );
    _themes.add(newTheme);
  }
} 