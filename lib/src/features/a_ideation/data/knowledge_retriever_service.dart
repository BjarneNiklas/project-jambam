import 'package:flutter/services.dart' show rootBundle;

class KnowledgeRetrieverService {
  List<_KnowledgeDocument> _documents = [];

  Future<void> loadKnowledgeBase() async {
    final content = await rootBundle.loadString('docs/KNOWLEDGE_BASE.md');
    final docStrings = content.split('---')..removeWhere((s) => s.trim().isEmpty);

    _documents = docStrings.map((s) => _KnowledgeDocument.fromString(s)).toList();
  }

  List<String> retrieveRelevantSnippets(List<String> keywords) {
    if (_documents.isEmpty) return [];

    final keywordSet = keywords.map((k) => k.toLowerCase()).toSet();
    final scoredDocs = <(_KnowledgeDocument, int)>[];

    for (final doc in _documents) {
      int score = 0;
      final searchableText = doc.searchableText.toLowerCase();

      for (final keyword in keywordSet) {
        if (searchableText.contains(keyword)) {
          score++;
        }
      }

      if (score > 0) {
        scoredDocs.add((doc, score));
      }
    }

    // Sort by score, highest first
    scoredDocs.sort((a, b) => b.$2.compareTo(a.$2));

    // Return the formatted content of the top 1-2 documents
    return scoredDocs.take(2).map((d) => d.$1.formattedContent).toList();
  }
}

class _KnowledgeDocument {
  const _KnowledgeDocument({
    required this.id,
    required this.title,
    required this.content,
  });

  factory _KnowledgeDocument.fromString(String rawString) {
    final id = _extractValue(rawString, 'DOC_ID');
    final title = _extractValue(rawString, 'TITLE');
    final content = _extractValue(rawString, 'CONTENT');
    return _KnowledgeDocument(id: id, title: title, content: content);
  }

  final String id;
  final String title;
  final String content;

  String get searchableText => '$title $content';
  String get formattedContent => 'Inspiration from "$title":\n$content';

  static String _extractValue(String text, String key) {
    final regex = RegExp(r'\*\*' + key + r':\*\*\s*(.*)', caseSensitive: false);
    final match = regex.firstMatch(text);
    return match?.group(1)?.trim() ?? '';
  }
} 