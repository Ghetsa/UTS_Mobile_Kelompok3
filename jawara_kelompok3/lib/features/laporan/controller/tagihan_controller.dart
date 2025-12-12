import '../data/models/tagihan_model.dart';
import '../data/services/tagihan_service.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../kependudukan/data/models/keluarga_model.dart';
import '../../kependudukan/data/services/keluarga_service.dart';
import '../presentation/pages/pemasukan/tagih_iuran/tagih_iuran_page.dart';
import '../data/services/pemasukan_lain_service.dart';

class TagihanController {
  final TagihanService _service = TagihanService();
  final PemasukanLainService _pemasukanService = PemasukanLainService();

  // =============================================================
  // 🔵 READ
  // =============================================================
  Future<List<TagihanModel>> fetchAll() async {
    return await _service.getAllTagihan();
  }

  // =============================================================
  // 🟡 UPDATE
  // =============================================================
  Future<bool> updateTagihan(String id, Map<String, dynamic> data) async {
    try {
      // Update the Tagihan status
      final result = await _service.update(id, data);
      
      // Check if the status was updated to "Sudah Dibayar"
      if (result && data['tagihanStatus'] == 'Sudah Dibayar') {
        // Create an entry in Pemasukan Lain
        final tagihan = await _service.getById(id);
        if (tagihan != null) {
          final pemasukanData = {
            'nama': tagihan.keluarga, // Name of the family
            'jenis': 'Tagihan Dibayar', // Description for Pemasukan
            'tanggal': DateTime.now().toString(),
            'nominal': tagihan.nominal, // Amount paid
          };
          // Add to Pemasukan Lain
          await _pemasukanService.add(pemasukanData);
        }
      }

      return result;
    } catch (e) {
      print('Error updating Tagihan: $e');
      return false;
    }
  }

  // =============================================================
  // 🔴 DELETE
  // =============================================================
  Future<bool> deleteTagihan(String id) => _service.delete(id);

  // =============================================================
  // 📄 EXPORT / CETAK PDF
  // =============================================================
  /// Menghasilkan laporan tagihan dalam bentuk PDF dan mengembalikan path file-nya
  Future<String> generatePdf(List<TagihanModel> tagihanData) async {
    final pdf = pw.Document();

    // Pastikan font sudah di-declare di pubspec.yaml
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
      final downloads = Directory('/storage/emulated/0/Download');
      if (await downloads.exists()) {
        dir = downloads;
      } else {
        dir = await getExternalStorageDirectory();
      }
    } else if (Platform.isIOS) {
      dir = await getApplicationDocumentsDirectory();
    } else {
      dir = await getTemporaryDirectory();
    }

    final filePath = '${dir!.path}/tagihan_report_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(filePath);

    await file.writeAsBytes(bytes, flush: true);

    return filePath;
  }
}