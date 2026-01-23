import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/note_model.dart';

class ExportService {
  /// Export note ra file PDF
  static Future<File> exportNoteToPdf(NoteModel note) async {
    final pdf = pw.Document();

    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Title
              pw.Text(
                note.title ?? 'Journal Entry',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 8),

              // Date
              pw.Text(
                note.createdAt != null
                    ? dateFormat.format(note.createdAt!)
                    : '',
                style: const pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.grey,
                ),
              ),

              pw.SizedBox(height: 12),

              // Mood
              if (note.mood != null)
                pw.Text(
                  'Mood: ${note.mood}',
                  style: const pw.TextStyle(fontSize: 14),
                ),

              pw.SizedBox(height: 16),

              pw.Divider(),

              pw.SizedBox(height: 16),

              // Content
              pw.Text(
                note.content ?? '',
                style: const pw.TextStyle(
                  fontSize: 14,
                  lineSpacing: 4,
                ),
              ),
            ],
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();

    final safeTitle =
    (note.title ?? 'journal').replaceAll(RegExp(r'[^\w\s-]'), '');
    final fileName =
        'journal_${safeTitle}_${DateTime.now().millisecondsSinceEpoch}.pdf';

    final file = File('${directory.path}/$fileName');

    await file.writeAsBytes(await pdf.save());

    return file;
  }
}
