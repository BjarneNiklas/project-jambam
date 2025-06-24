import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_jambam/src/features/a_ideation/data/research_agent.dart';

void main() {
  group('ResearchAgent Tests', () {
    late ResearchAgent researchAgent;

    setUp(() {
      researchAgent = ResearchAgent();
    });

    test('should create ResearchAgent instance', () {
      expect(researchAgent, isA<ResearchAgent>());
    });

    test('should validate source with DOI', () {
      final source = ResearchSource(
        title: 'Test Paper',
        authors: ['Author 1', 'Author 2'],
        abstract: 'Test abstract',
        url: 'https://example.com',
        source: 'Test Journal',
        year: 2025,
        citations: 10,
        qualityScore: 0.8,
        doi: '10.1000/test.2025',
        type: ResearchSourceType.academic,
      );

      expect(researchAgent.validateSource(source), isTrue);
    });

    test('should validate source with verifiable URL', () {
      final source = ResearchSource(
        title: 'Test Paper',
        authors: ['Author 1', 'Author 2'],
        abstract: 'Test abstract',
        url: 'https://arxiv.org/abs/test',
        source: 'ArXiv',
        year: 2025,
        citations: 5,
        qualityScore: 0.7,
        doi: '',
        type: ResearchSourceType.preprint,
      );

      expect(researchAgent.validateSource(source), isTrue);
    });

    test('should not validate source without DOI or verifiable URL', () {
      final source = ResearchSource(
        title: 'Test Paper',
        authors: ['Author 1', 'Author 2'],
        abstract: 'Test abstract',
        url: 'https://random-blog.com/test',
        source: 'Random Blog',
        year: 2025,
        citations: 1,
        qualityScore: 0.3,
        doi: '',
        type: ResearchSourceType.report,
      );

      expect(researchAgent.validateSource(source), isFalse);
    });

    test('should export results in BibTeX format', () {
      final sources = [
        ResearchSource(
          title: 'Test Paper 1',
          authors: ['Author 1', 'Author 2'],
          abstract: 'Test abstract 1',
          url: 'https://example.com/1',
          source: 'Test Journal',
          year: 2025,
          citations: 10,
          qualityScore: 0.8,
          doi: '10.1000/test1.2025',
          type: ResearchSourceType.academic,
        ),
      ];

      final result = ResearchResult(
        topic: 'Test Topic',
        sources: sources,
        summary: 'Test summary',
        timestamp: DateTime(2025, 1, 1),
        searchQuery: 'test',
      );

      final bibtex = researchAgent.exportResults(result, ExportFormat.bibtex);
      
      expect(bibtex, contains('@article{source1,'));
      expect(bibtex, contains('title = {Test Paper 1},'));
      expect(bibtex, contains('author = {Author 1 and Author 2},'));
      expect(bibtex, contains('doi = {10.1000/test1.2025},'));
    });

    test('should export results in APA format', () {
      final sources = [
        ResearchSource(
          title: 'Test Paper 1',
          authors: ['Author 1', 'Author 2'],
          abstract: 'Test abstract 1',
          url: 'https://example.com/1',
          source: 'Test Journal',
          year: 2025,
          citations: 10,
          qualityScore: 0.8,
          doi: '10.1000/test1.2025',
          type: ResearchSourceType.academic,
        ),
      ];

      final result = ResearchResult(
        topic: 'Test Topic',
        sources: sources,
        summary: 'Test summary',
        timestamp: DateTime(2025, 1, 1),
        searchQuery: 'test',
      );

      final apa = researchAgent.exportResults(result, ExportFormat.apa);
      
      expect(apa, contains('1. Author 1, Author 2 (2025). Test Paper 1. Test Journal.'));
      expect(apa, contains('DOI: 10.1000/test1.2025'));
      expect(apa, contains('URL: https://example.com/1'));
    });

    test('should export results in JSON format', () {
      final sources = [
        ResearchSource(
          title: 'Test Paper 1',
          authors: ['Author 1', 'Author 2'],
          abstract: 'Test abstract 1',
          url: 'https://example.com/1',
          source: 'Test Journal',
          year: 2025,
          citations: 10,
          qualityScore: 0.8,
          doi: '10.1000/test1.2025',
          type: ResearchSourceType.academic,
        ),
      ];

      final result = ResearchResult(
        topic: 'Test Topic',
        sources: sources,
        summary: 'Test summary',
        timestamp: DateTime(2025, 1, 1),
        searchQuery: 'test',
      );

      final json = researchAgent.exportResults(result, ExportFormat.json);
      final decoded = Map<String, dynamic>.from(jsonDecode(json));
      
      expect(decoded['topic'], equals('Test Topic'));
      expect(decoded['sources'], isA<List>());
      expect(decoded['summary'], equals('Test summary'));
    });

    test('ResearchSource should convert to JSON correctly', () {
      final source = ResearchSource(
        title: 'Test Paper',
        authors: ['Author 1', 'Author 2'],
        abstract: 'Test abstract',
        url: 'https://example.com',
        source: 'Test Journal',
        year: 2025,
        citations: 10,
        qualityScore: 0.8,
        doi: '10.1000/test.2025',
        type: ResearchSourceType.academic,
      );

      final json = source.toJson();
      
      expect(json['title'], equals('Test Paper'));
      expect(json['authors'], equals(['Author 1', 'Author 2']));
      expect(json['year'], equals(2025));
      expect(json['doi'], equals('10.1000/test.2025'));
    });

    test('ResearchResult should convert to JSON correctly', () {
      final sources = [
        ResearchSource(
          title: 'Test Paper',
          authors: ['Author 1'],
          abstract: 'Test',
          url: 'https://example.com',
          source: 'Test Journal',
          year: 2025,
          citations: 10,
          qualityScore: 0.8,
          doi: '10.1000/test.2025',
          type: ResearchSourceType.academic,
        ),
      ];

      final result = ResearchResult(
        topic: 'Test Topic',
        sources: sources,
        summary: 'Test summary',
        timestamp: DateTime(2025, 1, 1),
        searchQuery: 'test',
      );

      final json = result.toJson();
      
      expect(json['topic'], equals('Test Topic'));
      expect(json['sources'], isA<List>());
      expect(json['summary'], equals('Test summary'));
      expect(json['searchQuery'], equals('test'));
    });
  });
} 