import '../data/models/tagihan_model.dart';
import '../data/services/tagihan_service.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class TagihanController {
  final TagihanService _service = TagihanService();

  // =============================================================
  // 🔵 READ
  // =============================================================
  Future<List<TagihanModel>> fetchAll() => _service.getAll();
  Future<TagihanModel?> fetchById(String id) => _service.getById(id);

  // =============================================================
  // 🟡 UPDATE
  // =============================================================
  Future<bool> update(String id, Map<String, dynamic> data) =>
      _service.update(id, data);

  // =============================================================
  // 🔴 DELETE
  // =============================================================
  Future<bool> delete(String id) => _service.delete(id);

  // =============================================================
  // 📄 EXPORT / CETAK PDF
  // =============================================================
  /// Menghasilkan laporan tagihan dalam bentuk PDF dan mengembalikan path file-nya
  Future<String> generatePdf(List<TagihanModel> tagihanData) async {
    final pdf = pw.Document();

    // Pastikan font sudah di-declare di pubspec.yaml
    // assets:
    //   - assets/fonts/Roboto-Regular.ttf
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Text(
                "LAPORAN DATA TAGIHAN",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  font: ttf,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: const pw.FlexColumnWidth(3), // Nama KK
                1: const pw.FlexColumnWidth(2), // Periode
                2: const pw.FlexColumnWidth(2), // Nominal
                3: const pw.FlexColumnWidth(2), // Status
              },
              children: [
                // Header
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.grey300,
                  ),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        "Nama Kepala Keluarga",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          font: ttf,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        "Periode",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          font: ttf,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        "Nominal",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          font: ttf,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        "Status Tagihan",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          font: ttf,
                        ),
                      ),
                    ),
                  ],
                ),

                // Data
                ...tagihanData.map((tagihan) {
                  return pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(
                          tagihan.keluarga,
                          style: pw.TextStyle(font: ttf),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(
                          tagihan.periode,
                          style: pw.TextStyle(font: ttf),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(
                          tagihan.nominal,
                          style: pw.TextStyle(font: ttf),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(
                          tagihan.tagihanStatus,
                          style: pw.TextStyle(font: ttf),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ];
        },
      ),
    );

    // ====== SIMPAN FILE PDF KE STORAGE ======
    final bytes = await pdf.save();

    Directory? dir;

    if (Platform.isAndroid) {
      // Coba pakai folder Download bawaan
      final downloads = Directory('/storage/emulated/0/Download');
      if (await downloads.exists()) {
        dir = downloads;
      } else {
        // fallback ke external storage app
        dir = await getExternalStorageDirectory();
      }
    } else if (Platform.isIOS) {
      dir = await getApplicationDocumentsDirectory();
    } else {
      // Web / desktop → sementara pakai temporary
      dir = await getTemporaryDirectory();
    }

    final filePath = '${dir!.path}/tagihan_report_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(filePath);

    await file.writeAsBytes(bytes, flush: true);

    return filePath;
  }
}
