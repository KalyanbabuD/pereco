import 'dart:typed_data';
import 'package:flutter/material.dart' as mt;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:get/get.dart';
import '../app_colors.dart';

class PdfExportHelper {
  /// Generates a PDF with a tabular structure and opens an in-app PDF preview.
  /// The in-app preview automatically includes Share, Print, and Save buttons.
  static Future<void> openTablePdfPreview({
    required String title,
    required List<String> headers,
    required List<List<String>> data,
    required String filename,
  }) async {
    // Generate the PDF Document
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Title
            pw.Header(
              level: 0,
              child: pw.Center(
                child: pw.Text(
                  title,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              margin: const pw.EdgeInsets.only(bottom: 24),
              decoration: const pw.BoxDecoration(),
            ),
            
            // Table
            pw.TableHelper.fromTextArray(
              headers: headers,
              data: data,
              border: null,
              headerStyle: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColor.fromInt(0xFF2980B9), // Matching standard blue header
              ),
              rowDecoration: const pw.BoxDecoration(
                color: PdfColors.white,
              ),
              oddRowDecoration: const pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFF9F9F9),
              ),
              cellHeight: 30,
              cellAlignments: {
                for (int i = 0; i < headers.length; i++) i: pw.Alignment.center,
              },
            ),
          ];
        },
      ),
    );

    // Open the generated PDF in an in-app preview screen
    Get.to(() => _PdfPreviewScreen(
          title: title,
          pdfBytes: pdf.save(),
          filename: filename,
        ));
  }
}

class _PdfPreviewScreen extends mt.StatelessWidget {
  final String title;
  final Future<Uint8List> pdfBytes;
  final String filename;

  const _PdfPreviewScreen({
    mt.Key? key,
    required this.title,
    required this.pdfBytes,
    required this.filename,
  }) : super(key: key);

  @override
  mt.Widget build(mt.BuildContext context) {
    return mt.Scaffold(
      appBar: mt.AppBar(
        title: mt.Text(title),
        backgroundColor: AppColors.cardDarkBlue,
        foregroundColor: mt.Colors.white,
        actions: [
          mt.IconButton(
            icon: const mt.Icon(mt.Icons.share),
            onPressed: () async {
              final bytes = await pdfBytes;
              await Printing.sharePdf(bytes: bytes, filename: filename);
            },
          ),
        ],
      ),
      body: PdfPreview(
        build: (format) => pdfBytes,
        pdfFileName: filename,
        useActions: false,
        canChangeOrientation: false,
        canChangePageFormat: false,
      ),
    );
  }
}
