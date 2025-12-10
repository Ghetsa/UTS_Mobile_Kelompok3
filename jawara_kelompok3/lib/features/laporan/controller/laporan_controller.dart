import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../data/models/laporan_keuangan_model.dart';
import '../data/services/laporan_service.dart';

class LaporanController {
  final LaporanService _service = LaporanService();

  Future<Uint8List> generatePdf({
    required DateTime startDate,
    required DateTime endDate,
    required String jenisLaporan, // "Semua" | "Pemasukan" | "Pengeluaran"
  }) async {
    final List<LaporanKeuanganModel> data = await _service.getLaporan(
      startDate: startDate,
      endDate: endDate,
      jenis: jenisLaporan,
    );

    if (data.isEmpty) {
      throw Exception("Tidak ada data pada rentang tanggal & jenis ini");
    }

    final doc = pw.Document();

    final periodeText =
        "${_formatDate(startDate)} s/d ${_formatDate(endDate)}";

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return [
            pw.Text(
              "Laporan Keuangan",
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              "Periode: $periodeText",
              style: const pw.TextStyle(fontSize: 12),
            ),
            pw.SizedBox(height: 16),

            // Tabel Laporan Keuangan
            pw.Table.fromTextArray(
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
              cellStyle: const pw.TextStyle(fontSize: 9),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
              headers: const [
                'No',
                'Tanggal',
                'Keterangan',
                'Jenis',
                'Nominal',
              ],
              data: List.generate(data.length, (i) {
                final item = data[i];
                return [
                  (i + 1).toString(),
                  _formatDate(item.tanggal),
                  item.keterangan,
                  item.jenis,
                  _formatCurrency(item.nominal),
                ];
              }),
            ),
          ];
        },
      ),
    );

    return doc.save();
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  String _formatCurrency(int value) {
    final s = value.toString();
    final buffer = StringBuffer();
    int counter = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buffer.write(s[i]);
      counter++;
      if (counter == 3 && i != 0) {
        buffer.write('.');
        counter = 0;
      }
    }
    final reversed = buffer.toString().split('').reversed.join();
    return "Rp $reversed";
  }
}
