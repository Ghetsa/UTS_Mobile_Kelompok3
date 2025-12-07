import 'package:flutter/material.dart';

import '../../../../../core/layout/header.dart';
import '../../../../../core/layout/sidebar.dart';
import '../../../../../core/theme/app_theme.dart';

import '../../data/models/kegiatan_model.dart';
import '../../data/services/kegiatan_service.dart';
import '../../presentation/widgets/kegiatan_card.dart';
import '../../presentation/widgets/kegiatan_filter.dart';
import 'tambah_kegiatan_page.dart';
import 'edit_kegiatan_page.dart';
import 'detail_kegiatan_page.dart';

// ===== IMPORT UNTUK PDF =====
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class DaftarKegiatanPage extends StatefulWidget {
  const DaftarKegiatanPage({super.key});

  @override
  State<DaftarKegiatanPage> createState() => _DaftarKegiatanPageState();
}

class _DaftarKegiatanPageState extends State<DaftarKegiatanPage> {
  final KegiatanService _service = KegiatanService();

  List<KegiatanModel> data = [];
  String search = "";

  // filter state
  String _filterNama = "";
  String _filterPJ = "";
  String? _filterKategori;
  String? _filterStatus;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _loading = true;
    setState(() {});
    data = await _service.getAllKegiatan();
    _loading = false;
    setState(() {});
  }

  void _openFilter() async {
    await showDialog(
      context: context,
      builder: (_) => FilterKegiatanDialog(
        onApply: (f) {
          _filterNama = f['nama'] ?? "";
          _filterPJ = f['penanggung_jawab'] ?? "";
          _filterKategori = f['kategori'];
          _filterStatus = f['status'];
          setState(() {});
        },
      ),
    );
  }

  void _confirmDelete(KegiatanModel item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Kegiatan?"),
        content: Text("Yakin ingin menghapus kegiatan '${item.nama}' ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              final ok = await _service.deleteKegiatan(item.uid);
              if (!mounted) return;
              if (ok) {
                await _load();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Kegiatan berhasil dihapus."),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Gagal menghapus kegiatan."),
                  ),
                );
              }
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  bool _matchFilter(KegiatanModel item) {
    // search bar → nama kegiatan
    if (search.isNotEmpty &&
        !item.nama.toLowerCase().contains(search.toLowerCase())) {
      return false;
    }

    if (_filterNama.isNotEmpty &&
        !item.nama.toLowerCase().contains(_filterNama.toLowerCase())) {
      return false;
    }

    if (_filterPJ.isNotEmpty &&
        !item.penanggungJawab.toLowerCase().contains(_filterPJ.toLowerCase())) {
      return false;
    }

    if (_filterKategori != null &&
        _filterKategori!.isNotEmpty &&
        item.kategori != _filterKategori) {
      return false;
    }

    if (_filterStatus != null &&
        _filterStatus!.isNotEmpty &&
        item.status != _filterStatus) {
      return false;
    }

    return true;
  }

  /// 🔹 CETAK PDF DATA KEGIATAN (sesuai data yang lagi tampil / terfilter)
  Future<void> _cetakPdf() async {
    final list = data.where(_matchFilter).toList();

    if (list.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tidak ada data kegiatan untuk dicetak."),
        ),
      );
      return;
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          pw.Text(
            "Laporan Data Kegiatan",
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

          // Tabel data
          pw.Table.fromTextArray(
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 10,
            ),
            cellStyle: const pw.TextStyle(fontSize: 9),
            headerDecoration: const pw.BoxDecoration(
              color: PdfColors.grey300,
            ),
            headers: [
              'No',
              'Nama',
              'Kategori',
              'Lokasi',
              'Penanggung Jawab',
              'Status',
            ],
            data: List.generate(list.length, (i) {
              final k = list[i];
              return [
                (i + 1).toString(),
                k.nama,
                k.kategori,
                k.lokasi,
                k.penanggungJawab,
                k.status,
              ];
            }),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = data.where(_matchFilter).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      drawer: const AppSidebar(),

      // 🔹 DUA FAB: CETAK PDF (atas) + TAMBAH (bawah)
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "fab_pdf",
            backgroundColor: Colors.red,
            elevation: 4,
            onPressed: _cetakPdf,
            child:
                const Icon(Icons.picture_as_pdf, size: 26, color: Colors.white),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: "fab_add",
            backgroundColor: AppTheme.primaryBlue,
            elevation: 4,
            onPressed: () async {
              final res = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TambahKegiatanPage(),
                ),
              );
              if (res == true) {
                await _load();
              }
            },
            child: const Icon(Icons.add, size: 32, color: Colors.white),
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            MainHeader(
              title: "Data Kegiatan",
              searchHint: "Cari nama kegiatan...",
              showSearchBar: true,
              showFilterButton: true,
              onSearch: (v) => setState(() => search = v.trim()),
              onFilter: _openFilter,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: list.length,
                        itemBuilder: (_, i) {
                          final item = list[i];

                          return KegiatanCard(
                            data: item,
                            onDetail: () => showDialog(
                              context: context,
                              builder: (_) => DetailKegiatanDialog(data: item),
                            ),
                            onEdit: () async {
                              final updated = await showDialog(
                                context: context,
                                builder: (_) => EditKegiatanDialog(data: item),
                              );
                              if (updated == true) {
                                await _load();
                              }
                            },
                            onDelete: () => _confirmDelete(item),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
