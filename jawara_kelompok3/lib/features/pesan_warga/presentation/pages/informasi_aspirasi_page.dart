import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../../core/layout/header.dart';
import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/pesan_warga_model.dart';
import '../../data/services/pesan_warga_service.dart';
import '../widgets/card/aspirasi_card.dart';
import '../widgets/filter/aspirasi_filter_dialog.dart';
import 'detail_aspirasi_page.dart';
import 'edit_aspirasi_page.dart';
import 'tambah_aspirasi_page.dart';

class InformasiAspirasi extends StatefulWidget {
  const InformasiAspirasi({super.key});

  @override
  State<InformasiAspirasi> createState() => _InformasiAspirasiState();
}

class _InformasiAspirasiState extends State<InformasiAspirasi> {
  final PesanWargaService _service = PesanWargaService();
  List<PesanWargaModel> _data = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _data = await _service.getSemuaPesan();
    setState(() {});
  }

  void _confirmDelete(PesanWargaModel model) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Aspirasi"),
        content: Text('Yakin ingin menghapus "${model.isiPesan}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Batal")),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: AppTheme.redMedium),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Hapus",
              style: TextStyle(color: AppTheme.putihFull),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _service.deletePesan(model.docId);
      if (success) {
        _loadData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Aspirasi berhasil dihapus."),
            backgroundColor: AppTheme.greenMedium,
          ),
        );
      }
    }
  }

  Future<void> _openFilterDialog() async {
    await showDialog(
      context: context,
      builder: (_) => AspirasiFilterDialog(
        initialSearch: _searchQuery,
        initialStatus: null,
        onApply: (filterData) {
          setState(() {
            _searchQuery = filterData['search'] ?? '';
          });
        },
        onReset: () {
          setState(() {
            _searchQuery = '';
          });
        },
      ),
    );
  }

  // ==========================
  // CETAK PDF
  // ==========================
  Future<void> _cetakPdf(List<PesanWargaModel> list) async {
    if (list.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tidak ada data aspirasi untuk dicetak."),
        ),
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
            pw.Text(
              "Laporan Data Aspirasi Warga",
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              "Dicetak: ${DateTime.now()}",
              style: const pw.TextStyle(fontSize: 10),
            ),
            pw.SizedBox(height: 16),
            pw.Table.fromTextArray(
              headerStyle:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
              cellStyle: const pw.TextStyle(fontSize: 9),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
              headers: const [
                'No',
                'ID Pesan',
                'Isi Pesan',
                'Kategori',
                'Status',
                'Created At',
                'Updated At'
              ],
              data: List.generate(list.length, (i) {
                final p = list[i];
                return [
                  (i + 1).toString(),
                  p.idPesan,
                  p.isiPesan,
                  p.kategori,
                  p.status,
                  p.createdAt?.toString() ?? "-",
                  p.updatedAt?.toString() ?? "-",
                ];
              }),
            ),
          ],
        ),
      );

      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mencetak PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _searchQuery.isEmpty
        ? _data
        : _data
            .where((p) =>
                p.isiPesan.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                p.idPesan.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE9F2F9),
      drawer: const AppSidebar(),

      // Dua FAB: cetak PDF + tambah aspirasi
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'printAspirasi',
            backgroundColor: Colors.red,
            elevation: 4,
            onPressed: () => _cetakPdf(filteredList),
            child:
                const Icon(Icons.picture_as_pdf, size: 26, color: Colors.white),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'addAspirasi',
            backgroundColor: const Color(0xFF0C88C2),
            elevation: 4,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TambahAspirasiPage()),
              ).then((_) => _loadData());
            },
            child: const Icon(Icons.add, size: 32, color: Colors.white),
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainHeader(
              title: "Semua Aspirasi",
              searchHint: "Cari isi pesan / ID pesan...",
              showSearchBar: true,
              showFilterButton: true,
              onSearch: (value) => setState(() => _searchQuery = value.trim()),
              onFilter: _openFilterDialog,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: filteredList.length,
                itemBuilder: (_, i) {
                  final p = filteredList[i];
                  return AspirasiCard(
                    data: p,
                    onDetail: () {
                      showDialog(
                        context: context,
                        builder: (_) => DetailAspirasi(model: p),
                      );
                    },
                    onEdit: () async {
                      final updated = await showDialog(
                        context: context,
                        builder: (_) => EditAspirasi(model: p),
                      );
                      if (updated == true) _loadData();
                    },
                    onDelete: () => _confirmDelete(p),
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
