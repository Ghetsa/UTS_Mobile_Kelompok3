import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // untuk MissingPluginException
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ⬅️ TAMBAHAN

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/layout/sidebar.dart';
import '../../../../../core/layout/header.dart';

import '../../../data/models/rumah_model.dart';
import '../../../controller/rumah_controller.dart';
import '../../widgets/card/rumah_card.dart';
import '../../widgets/filter/rumah_filter.dart';
import 'detail_rumah_page.dart';
import 'edit_rumah_page.dart';
import 'tambah_rumah_page.dart';

class DaftarRumahPage extends StatefulWidget {
  const DaftarRumahPage({super.key});

  @override
  State<DaftarRumahPage> createState() => _DaftarRumahPageState();
}

class _DaftarRumahPageState extends State<DaftarRumahPage> {
  final RumahController _controller = RumahController();
  List<RumahModel> data = [];

  String search = "";

  /// 🔹 state filter aktif (diisi dari FilterRumahDialog)
  Map<String, dynamic> _activeFilter = {};

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    data = await _controller.fetchAll();
    setState(() {});
  }

  void _confirmDelete(RumahModel rumah) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Rumah?"),
        content: Text("Yakin ingin menghapus rumah di '${rumah.alamat}' ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);

              final ok = await _controller.delete(rumah.docId);

              if (ok) {
                await loadData();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Rumah berhasil dihapus."),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Gagal menghapus rumah."),
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

  void _openAdd() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TambahRumahPage()),
    );

    if (result == true) loadData();
  }

  /// 🔍 Helper: cek apakah 1 rumah lolos filter
  bool _matchFilter(RumahModel r) {
    final fKeyword = (_activeFilter['penghuni'] ?? '').toString().trim();
    final fStatus = (_activeFilter['status'] ?? '').toString().trim();
    final fKepem = (_activeFilter['kepemilikan'] ?? '').toString().trim();

    // Keyword dipakai untuk cari di alamat + nomor rumah
    if (fKeyword.isNotEmpty) {
      final combined = "${r.alamat} ${r.nomor}".toLowerCase();
      if (!combined.contains(fKeyword.toLowerCase())) {
        return false;
      }
    }

    // Status Rumah (abaikan jika kosong / "Semua")
    if (fStatus.isNotEmpty &&
        fStatus.toLowerCase() != 'semua' &&
        r.statusRumah.toLowerCase() != fStatus.toLowerCase()) {
      return false;
    }

    // Kepemilikan (abaikan jika kosong / "Semua")
    if (fKepem.isNotEmpty &&
        fKepem.toLowerCase() != 'semua' &&
        r.kepemilikan.toLowerCase() != fKepem.toLowerCase()) {
      return false;
    }

    return true;
  }

  /// 🔹 CETAK PDF DATA RUMAH (sesuai data yang sedang tampil),
  ///     + kepala keluarga dari keluarga yang menghuni rumah
  Future<void> _cetakPdf(List<RumahModel> list) async {
    if (list.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tidak ada data rumah untuk dicetak."),
        ),
      );
      return;
    }

    try {
      // 🔸 Ambil dulu semua data keluarga → buat map: id_rumah → list kepala_keluarga
      final keluargaSnap =
          await FirebaseFirestore.instance.collection('keluarga').get();

      final Map<String, List<String>> kepalaPerRumah = {};

      for (final doc in keluargaSnap.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final idRumah = (data['id_rumah'] ?? '').toString();
        final kepala = (data['kepala_keluarga'] ?? '').toString();

        if (idRumah.isEmpty || kepala.isEmpty) continue;

        kepalaPerRumah.putIfAbsent(idRumah, () => []);
        if (!kepalaPerRumah[idRumah]!.contains(kepala)) {
          kepalaPerRumah[idRumah]!.add(kepala);
        }
      }

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          build: (context) => [
            pw.Text(
              "Laporan Data Rumah",
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
                'Alamat',
                'No Rumah',
                'RT/RW',
                'Status',
                'Kepemilikan',
                'Kepala Keluarga', // ⬅️ kolom baru
              ],
              data: List.generate(list.length, (i) {
                final r = list[i];

                // cari kepala keluarga berdasarkan id_rumah = docId rumah
                final kkList = kepalaPerRumah[r.docId] ?? [];
                final kepalaKeluarga = kkList.isEmpty ? '-' : kkList.join(', ');

                return [
                  (i + 1).toString(),
                  r.alamat,
                  r.nomor,
                  "${r.rt}/${r.rw}",
                  r.statusRumah,
                  r.kepemilikan,
                  kepalaKeluarga,
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
    // 🔹 Terapkan search + filter sekali, dipakai untuk list & cetak PDF
    final filteredList = data.where((item) {
      // Filter text search global (alamat + rt/rw)
      final searchable = "${item.alamat} ${item.rt}/${item.rw}";
      if (search.isNotEmpty &&
          !searchable.toLowerCase().contains(search.toLowerCase())) {
        return false;
      }

      // Filter dialog
      if (!_matchFilter(item)) return false;

      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      drawer: const AppSidebar(),

      // 🔹 Dua FAB: Cetak PDF (atas, merah) + Tambah (bawah, biru)
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'printRumah',
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
            heroTag: 'addRumah',
            backgroundColor: const Color(0xFF0C88C2),
            elevation: 4,
            onPressed: _openAdd,
            child: const Icon(Icons.add, size: 32, color: Colors.white),
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainHeader(
              title: "Data Rumah",
              searchHint: "Cari alamat / RT RW...",
              showSearchBar: true,
              showFilterButton: true,
              onSearch: (value) {
                setState(() => search = value.trim());
              },
              onFilter: () async {
                await showDialog(
                  context: context,
                  builder: (_) => FilterRumahDialog(
                    onApply: (filterData) {
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

                  return RumahCard(
                    data: item,
                    onDetail: () async {
                      await showDialog(
                        context: context,
                        builder: (_) => DetailRumahDialog(rumah: item),
                      );
                    },
                    onEdit: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (_) => EditRumahDialog(rumah: item),
                      );
                      if (result == true) loadData();
                    },
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
