import 'package:project_jambam/src/features/c_community_voting/data/mock_community_theme_repository.dart';
import 'package:project_jambam/src/features/c_community_voting/domain/community_theme_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'community_theme_repository_provider.g.dart';

@riverpod
CommunityThemeRepository communityThemeRepository(Ref ref) {
  return MockCommunityThemeRepository();
} 