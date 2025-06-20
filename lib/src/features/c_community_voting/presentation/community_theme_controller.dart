import 'dart:async';

import 'package:project_jambam/src/features/c_community_voting/data/community_theme_repository_provider.dart';
import 'package:project_jambam/src/features/c_community_voting/domain/community_theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'community_theme_controller.g.dart';

@riverpod
class CommunityThemeController extends _$CommunityThemeController {
  @override
  FutureOr<List<CommunityTheme>> build() {
    return ref.watch(communityThemeRepositoryProvider).fetchThemes();
  }

  Future<void> voteForTheme(String themeId) async {
    final repo = ref.read(communityThemeRepositoryProvider);
    // We don't need to handle loading state here, as it's a quick action.
    // In a real app, you might want to show a small indicator.
    await repo.voteForTheme(themeId);
    // Invalidate the provider to refetch the list with the updated vote count.
    ref.invalidateSelf();
  }

  Future<void> submitTheme({
    required String title,
    required String description,
  }) async {
    final repo = ref.read(communityThemeRepositoryProvider);
    await repo.submitTheme(title: title, description: description);
    ref.invalidateSelf();
  }
} 