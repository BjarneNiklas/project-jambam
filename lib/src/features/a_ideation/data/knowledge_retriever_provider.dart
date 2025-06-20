import 'package:project_jambam/src/features/a_ideation/data/knowledge_retriever_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'knowledge_retriever_provider.g.dart';

@Riverpod(keepAlive: true)
KnowledgeRetrieverService knowledgeRetrieverService(Ref ref) {
  // We return the service instance itself.
  // The loading of the knowledge base will be triggered manually in main.dart
  return KnowledgeRetrieverService();
} 