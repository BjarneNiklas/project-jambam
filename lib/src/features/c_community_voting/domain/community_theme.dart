import 'package:flutter/foundation.dart';

@immutable
class CommunityTheme {
  const CommunityTheme({
    required this.id,
    required this.title,
    required this.description,
    required this.submitter,
    required this.voteCount,
  });

  final String id;
  final String title;
  final String description;
  final String submitter; // For now, just a name. Later, this could be a User object.
  final int voteCount;
} 