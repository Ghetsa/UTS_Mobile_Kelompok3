import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../../../../core/layout/header.dart';
import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/pengguna_model.dart';
import '../widgets/card/pengguna_card.dart';
import '../widgets/filter/pengguna_filter.dart';
import 'detail_pengguna_page.dart';
import 'edit_pengguna_page.dart';
import 'tambah_pengguna_page.dart';

class DaftarPenggunaPage extends StatefulWidget {
  const DaftarPenggunaPage({super.key});

  @override
  State<DaftarPenggunaPage> createState() => _DaftarPenggunaPageState();
}

class _DaftarPenggunaPageState extends State<DaftarPenggunaPage> {
  List<User> data = [];
  String search = "";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('created_at', descending: true)
        .get();

    setState(() {
      data = snapshot.docs
          .map((doc) => User.fromFirestore(doc.id, doc.data()))
          .toList();
    });
  }

  void _confirmDelete(User item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Pengguna"),
        content: Text("Yakin ingin menghapus '${item.nama}' ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: AppTheme.redMedium),
            onPressed: () async {
              // Hapus dari Firestore
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(item.docId)
                  .delete();

              // Hapus dari list lokal agar UI langsung update
              setState(() {
                data.removeWhere((u) => u.docId == item.docId);
              });

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Pengguna berhasil dihapus."),
                  backgroundColor: AppTheme.greenMedium,
                ),
              );
            },
            child: const Text("Hapus"), // <-- harus di dalam ElevatedButton
          ),
        ],
      ),
    );
  }

  // CETAK PDF DATA PENGGUNA
  Future<void> _cetakPdf(List<User> list) async {
    if (list.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tidak ada data pengguna untuk dicetak."),
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
              "Laporan Data Pengguna",
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

            // Tabel data pengguna
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
                'Nama',
                'Email',
                'NIK',
                'No HP',
                'JK',
                'Role',
                'Status',
              ],
              data: List.generate(list.length, (i) {
                final u = list[i];
                return [
                  (i + 1).toString(),
                  u.nama,
                  u.email,
                  u.nik,
                  u.noHp,
                  u.jenisKelamin.toUpperCase(),
                  u.role,
                  u.statusPengguna,
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
        SnackBar(
          content: Text('Gagal mencetak PDF: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter search
    final filteredList = search.isEmpty
        ? data
        : data
            .where(
              (u) => u.nama.toLowerCase().contains(search.toLowerCase()),
            )
            .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE9F2F9),
      drawer: const AppSidebar(),

      // Dua FAB: cetak PDF + tambah pengguna
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'printPengguna',
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
            heroTag: 'addPengguna',
            backgroundColor: const Color(0xFF0C88C2),
            elevation: 4,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TambahPenggunaPage()),
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
            // HEADER
            MainHeader(
              title: "Data Pengguna",
              searchHint: "Cari nama pengguna...",
              showSearchBar: true,
              showFilterButton: true,
              onSearch: (value) {
                setState(() => search = value.trim());
              },
              onFilter: () async {
                await showDialog(
                  context: context,
                  builder: (_) => FilterPenggunaDialog(
                    onApply: (filterData) {},
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // LIST PENGGUNA
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: filteredList.length,
                itemBuilder: (_, i) {
                  final user = filteredList[i];

                  return PenggunaCard(
                    data: user,
                    onDetail: () {
                      showDialog(
                        context: context,
                        builder: (_) => DetailPenggunaPage(user: user),
                      );
                    },
                    onEdit: () async {
                      final updated = await showDialog(
                        context: context,
                        builder: (_) => EditPenggunaPage(user: user),
                      );
                      if (updated == true) _loadData();
                    },
                    onDelete: () => _confirmDelete(user),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
