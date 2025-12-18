import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../../../../core/layout/header.dart';
import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/aktivitas_model.dart';
import '../widgets/card/log_card.dart';
import '../widgets/badge/log_badge.dart';
import '../widgets/filter/log_filter.dart';

class DaftarLogAktivitasPage extends StatefulWidget {
  const DaftarLogAktivitasPage({super.key});

  @override
  State<DaftarLogAktivitasPage> createState() => _DaftarLogAktivitasPageState();
}

class _DaftarLogAktivitasPageState extends State<DaftarLogAktivitasPage> {
  List<Log> data = [];
  String search = "";
  Map<String, dynamic> filterData = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('log_aktivitas')
        .orderBy('tanggal', descending: true)
        .get();

    setState(() {
      data = snapshot.docs
          .map((doc) => Log.fromFirestore(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> _cetakPdf(List<Log> list) async {
    if (list.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak ada data log untuk dicetak.")),
      );
      return;
    }

    try {
      final pdf = pw.Document();
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          build: (context) => [
            pw.Text("Laporan Data Log Aktivitas",
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text("Dicetak: ${DateTime.now()}",
                style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 16),
            pw.Table.fromTextArray(
              headerStyle:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
              cellStyle: const pw.TextStyle(fontSize: 9),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey300),
              headers: const [
                'No',
                'Aktivitas',
                'Aktor',
                'Tanggal & Jam',
              ],
              data: List.generate(list.length, (i) {
                final u = list[i];
                return [
                  (i + 1).toString(),
                  u.aktivitas,
                  u.role,
                  u.tanggal.toString().substring(0, 16),
                ];
              }),
            ),
          ],
        ),
      );

      await Printing.layoutPdf(onLayout: (format) async => pdf.save());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mencetak PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Terapkan search
    List<Log> filteredList = search.isEmpty
        ? data
        : data
            .where(
                (u) => u.aktivitas.toLowerCase().contains(search.toLowerCase()))
            .toList();

    // Terapkan filter role, nama, dan tanggal
    filteredList = filteredList.where((log) {
      final roleMatch =
          filterData['role'] == null || log.role == filterData['role'];
      final namaMatch = filterData['nama'] == null ||
          log.aktivitas.toLowerCase().contains(
                (filterData['nama'] as String).toLowerCase(),
              );
      final start = filterData['start'] as DateTime?;
      final end = filterData['end'] as DateTime?;
      final tanggalMatch = (start == null ||
              log.tanggal.isAfter(start.subtract(const Duration(days: 1)))) &&
          (end == null ||
              log.tanggal.isBefore(end.add(const Duration(days: 1))));
      return roleMatch && namaMatch && tanggalMatch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE9F2F9),
      drawer: const AppSidebar(),
      floatingActionButton: FloatingActionButton(
        heroTag: 'printLog',
        backgroundColor: Colors.red,
        elevation: 4,
        onPressed: () => _cetakPdf(filteredList),
        child: const Icon(Icons.picture_as_pdf, size: 26, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainHeader(
              title: "Log Aktivitas",
              searchHint: "Cari aktivitas...",
              showSearchBar: true,
              showFilterButton: true,
              onSearch: (value) => setState(() => search = value.trim()),
              onFilter: () async {
                await showDialog(
                  context: context,
                  builder: (_) => FilterLogDialog(onApply: (data) {
                    setState(() {
                      filterData = data;
                    });
                  }),
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: filteredList.length,
                itemBuilder: (_, i) {
                  final log = filteredList[i];
                  return LogCard(
                    data: log,
                    onDetail: null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
