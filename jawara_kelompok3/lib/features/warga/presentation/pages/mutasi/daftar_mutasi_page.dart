import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../../../core/layout/header.dart';
import '../../../../../core/layout/sidebar.dart';

import '../../../data/models/mutasi_model.dart';
import '../../../controller/mutasi_controller.dart';
import '../../widgets/card/mutasi_card.dart';
import '../../widgets/filter/mutasi_filter.dart';
import 'tambah_mutasi_page.dart';
import 'edit_mutasi_page.dart';
import 'detail_mutasi_page.dart';

class MutasiDaftarPage extends StatefulWidget {
  const MutasiDaftarPage({super.key});

  @override
  State<MutasiDaftarPage> createState() => _MutasiDaftarPageState();
}

class _MutasiDaftarPageState extends State<MutasiDaftarPage> {
  final MutasiController _controller = MutasiController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await _controller.loadData();
    setState(() {});
  }

  void _onSearch(String value) {
    _controller.setSearch(value);
    setState(() {});
  }

  void _confirmDelete(MutasiModel item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Mutasi?"),
        content: Text(
          "Yakin ingin menghapus mutasi dengan ID dokumen '${item.uid}' ?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              final ok = await _controller.deleteMutasi(item);
              if (!mounted) return;
              if (ok) {
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Mutasi berhasil dihapus."),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Gagal menghapus mutasi."),
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

  /// 🔹 Cetak PDF daftar mutasi (berdasarkan list yang sedang tampil)
  Future<void> _cetakPdf(List<MutasiModel> list) async {
    if (list.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tidak ada data mutasi yang bisa dicetak."),
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
              'Laporan Data Mutasi Warga',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              'Dicetak: ${DateTime.now()}',
              style: const pw.TextStyle(fontSize: 10),
            ),
            pw.SizedBox(height: 16),
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
                'ID Dokumen',
                'Jenis Mutasi',
                'Tanggal',
                'Keterangan',
              ],
              data: List.generate(list.length, (i) {
                final m = list[i];

                // TODO: sesuaikan field di bawah dengan MutasiModel kamu
                final jenis = m.jenisMutasi ?? ''; // kalau namanya beda, ganti
                final ket = m.keterangan ?? ''; // kalau namanya beda, ganti
                final tgl =
                    m.tanggal?.toString() ?? ''; // kalau ada field tanggal

                return [
                  (i + 1).toString(),
                  m.uid,
                  jenis,
                  tgl,
                  ket,
                ];
              }),
            ),
          ],
        ),
      );

      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
      );
    } on MissingPluginException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Fitur cetak PDF belum tersedia di platform ini.\n'
            'Coba jalankan di emulator/device Android atau iOS.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mencetak PDF: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = _controller.filteredData;

    return Scaffold(
      backgroundColor: const Color(0xFFE9F2F9),
      drawer: const AppSidebar(),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'printMutasi',
            backgroundColor: Colors.red,
            elevation: 4,
            onPressed: () => _cetakPdf(list),
            child: const Icon(Icons.picture_as_pdf, color: Colors.white),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'addMutasi',
            backgroundColor: const Color(0xFF0C88C2),
            elevation: 4,
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MutasiTambahPage(),
                ),
              );
              if (result == true) {
                await _load();
              }
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
              title: "Data Mutasi Warga",
              searchHint: "Cari ID / jenis mutasi / keterangan...",
              showSearchBar: true,
              showFilterButton: true,
              onSearch: _onSearch,
              onFilter: () async {
                await showDialog(
                  context: context,
                  builder: (_) => FilterMutasiDialog(
                    onApply: (filterData) {
                      final jenis = filterData['jenis'] as String? ?? "Semua";
                      _controller.setFilterJenis(jenis);
                      setState(() {});
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _load,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final item = list[i];

                    return MutasiCard(
                      data: item,
                      onDetail: () {
                        showDialog(
                          context: context,
                          builder: (_) => DetailMutasiDialog(data: item),
                        );
                      },
                      onEdit: () async {
                        final updated = await showDialog(
                          context: context,
                          builder: (_) => EditMutasiDialog(data: item),
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
