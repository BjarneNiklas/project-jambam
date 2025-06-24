import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io'; // For File operations
import 'package:project_jambam/src/features/a_ideation/data/research_agent.dart'; // Assuming ResearchResult is here

class ExportService {
  Future<void> exportToPdf(ResearchResult result, String fileName) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text(result.title, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            ),
            pw.Paragraph(text: result.summary, style: const pw.TextStyle(fontSize: 12)),
            pw.SizedBox(height: 20),
            if (result.keyInsights.isNotEmpty) ...[
              pw.Header(level: 1, text: 'Key Insights'),
              ...result.keyInsights.map((insight) => pw.Bullet(text: insight, style: const pw.TextStyle(fontSize: 10))),
              pw.SizedBox(height: 20),
            ],
            if (result.sources.isNotEmpty) ...[
              pw.Header(level: 1, text: 'Sources'),
              ...result.sources.map((source) {
                // Assuming ResearchSource has a 'name' and 'url' or similar, adjust as needed
                // For simplicity, just listing source names. A real implementation might make URLs clickable.
                // final sourceName = source.source.toString().split('.').last; // Example, adapt to your ResearchSource structure
                return pw.Bullet(text: source.source); // Placeholder, adapt to how you want to display sources
              }),
            ],
          ];
        },
      ),
    );

    await Printing.sharePdf(bytes: await pdf.save(), filename: '$fileName.pdf');
  }

  Future<void> exportToMarkdown(ResearchResult result, String fileName) async {
    final StringBuffer markdownContent = StringBuffer();

    // Title
    markdownContent.writeln('# ${result.title}');
    markdownContent.writeln();

    // Summary
    markdownContent.writeln('## Summary');
    markdownContent.writeln(result.summary);
    markdownContent.writeln();

    // Key Insights
    if (result.keyInsights.isNotEmpty) {
      markdownContent.writeln('## Key Insights');
      for (final insight in result.keyInsights) {
        markdownContent.writeln('- $insight');
      }
      markdownContent.writeln();
    }

    // Sources
    if (result.sources.isNotEmpty) {
      markdownContent.writeln('## Sources');
      for (final source in result.sources) {
        // Assuming ResearchSource has a 'name' and 'url' or similar
        // markdownContent.writeln('- ${source.name}: ${source.url}'); // Example, adapt
        markdownContent.writeln('- ${source.source}'); // Placeholder, adapt
      }
      markdownContent.writeln();
    }

    // Attempt to save to a file first, then share the file path or content
    try {
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/$fileName.md';
      final file = File(filePath);
      await file.writeAsString(markdownContent.toString());
      // ignore: deprecated_member_use
      await Share.shareFiles([filePath], text: 'Research Export: ${result.title}');
    } catch (e) {
      // Fallback to sharing text directly if file saving/sharing fails
      await Share.share(markdownContent.toString(), subject: 'Research Export: ${result.title}');
    }
  }
}
