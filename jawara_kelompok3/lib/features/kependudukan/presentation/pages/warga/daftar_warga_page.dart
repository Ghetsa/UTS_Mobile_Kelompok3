import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // untuk MissingPluginException
import 'package:printing/printing.dart'; // cetak / share PDF
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../../../data/models/warga_model.dart';
import '../../../data/services/warga_service.dart';
import '../../../../../core/layout/header.dart';
import '../../../../../core/layout/sidebar.dart';
import '../../widgets/card/warga_card.dart';
import '../../widgets/filter/warga_filter.dart';
import 'detail_warga_page.dart';
import 'edit_warga_page.dart';

class DaftarWargaPage extends StatefulWidget {
  const DaftarWargaPage({super.key});

  @override
  State<DaftarWargaPage> createState() => _DaftarWargaPageState();
}

class _DaftarWargaPageState extends State<DaftarWargaPage> {
  final WargaService _service = WargaService();
  List<WargaModel> data = [];

  String search = "";

  /// 🔹 state filter aktif (diisi dari dialog)
  Map<String, dynamic> _activeFilter = {};

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    data = await _service.getAllWarga();
    setState(() {});
  }

  /// KONFIRMASI HAPUS
  void _confirmDelete(WargaModel item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Warga?"),
        content: Text("Yakin ingin menghapus '${item.nama}' ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);

              final success = await _service.deleteWarga(item.docId);

              if (success) {
                loadData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Warga berhasil dihapus."),
                    backgroundColor: Colors.red,
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

  /// 🔍 Helper: cek apakah 1 warga lolos filter
  bool _matchFilter(WargaModel w) {
    final fNama = (_activeFilter['nama'] ?? '').toString().trim();
    final fJK = (_activeFilter['jenis_kelamin'] ?? '').toString().trim();
    final fAgama = (_activeFilter['agama'] ?? '').toString().trim();
    final fPend = (_activeFilter['pendidikan'] ?? '').toString().trim();
    final fStatus = (_activeFilter['status_warga'] ?? '').toString().trim();
    final fRumah = (_activeFilter['id_rumah'] ?? '').toString().trim();

    // Nama: pakai contains (case-insensitive)
    if (fNama.isNotEmpty &&
        !w.nama.toLowerCase().contains(fNama.toLowerCase())) {
      return false;
    }

    // Jenis kelamin: exact match (l/p)
    if (fJK.isNotEmpty && w.jenisKelamin.toLowerCase() != fJK.toLowerCase()) {
      return false;
    }

    // Agama: exact (case-insensitive)
    if (fAgama.isNotEmpty && w.agama.toLowerCase() != fAgama.toLowerCase()) {
      return false;
    }

    // Pendidikan: boleh contains, biar fleksibel (D4, S1, dll)
    if (fPend.isNotEmpty &&
        !w.pendidikan.toLowerCase().contains(fPend.toLowerCase())) {
      return false;
    }

    // Status warga
    if (fStatus.isNotEmpty &&
        w.statusWarga.toLowerCase() != fStatus.toLowerCase()) {
      return false;
    }

    // ID Rumah (docId rumah)
    if (fRumah.isNotEmpty && w.idRumah.toLowerCase() != fRumah.toLowerCase()) {
      return false;
    }

    return true;
  }

  /// 🔹 CETAK PDF DATA WARGA (sesuai data yang lagi tampil / terfilter)
  Future<void> _cetakPdf(List<WargaModel> list) async {
    if (list.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tidak ada data warga untuk dicetak."),
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
              "Laporan Data Warga",
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

            // Tabel data warga
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
                'NIK',
                'Nama',
                'No KK',
                'JK',
                'Status',
                'No HP',
              ],
              data: List.generate(list.length, (i) {
                final w = list[i];
                return [
                  (i + 1).toString(),
                  w.nik,
                  w.nama,
                  w.noKk,
                  w.jenisKelamin.toUpperCase(), // L / P
                  w.statusWarga,
                  w.noHp,
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
    // 🔹 Terapkan search + filter sekali, dipakai untuk list & print
    final filteredList = data.where((item) {
      // 1) Filter search nama
      if (search.isNotEmpty &&
          !item.nama.toLowerCase().contains(search.toLowerCase())) {
        return false;
      }

      // 2) Filter berdasarkan filter dialog
      if (!_matchFilter(item)) return false;

      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE9F2F9),
      drawer: const AppSidebar(),

      /// 🔹 Dua FAB: cetak PDF (atas) + tambah Warga (bawah)
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'printWarga',
            backgroundColor: Colors.red,
            elevation: 4,
            onPressed: () => _cetakPdf(filteredList),
            child: const Icon(
              Icons.picture_as_pdf,
              size: 26,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'addWarga',
            backgroundColor: const Color(0xFF0C88C2),
            elevation: 4,
            onPressed: () {
              Navigator.pushNamed(context, "/data-warga/tambah")
                  .then((_) => loadData());
            },
            child: const Icon(Icons.add, size: 32, color: Colors.white),
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            MainHeader(
              title: "Data Warga",
              searchHint: "Cari nama warga...",
              showSearchBar: true,
              showFilterButton: true,
              onSearch: (value) {
                setState(() => search = value.trim());
              },
              onFilter: () async {
                await showDialog(
                  context: context,
                  builder: (_) => FilterWargaDialog(
                    onApply: (filterData) {
                      // simpan filter yang diterapkan
                      setState(() {
                        _activeFilter = filterData;
                      });
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: filteredList.length,
                itemBuilder: (_, i) {
                  final item = filteredList[i];

                  return WargaCard(
                    data: item,

                    /// DETAIL
                    onDetail: () {
                      showDialog(
                        context: context,
                        builder: (_) => DetailWargaPage(data: item),
                      );
                    },

                    /// EDIT
                    onEdit: () async {
                      final updated = await showDialog(
                        context: context,
                        builder: (_) => EditWargaPage(data: item),
                      );

                      if (updated == true) {
                        loadData();
                      }
                    },

                    /// DELETE
                    onDelete: () => _confirmDelete(item),
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
