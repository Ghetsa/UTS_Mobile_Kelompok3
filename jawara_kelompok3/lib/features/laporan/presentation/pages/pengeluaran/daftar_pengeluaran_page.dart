import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/layout/header.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/theme/app_theme.dart';

import '../../../data/models/semua_pengeluaran_model.dart';
import '../../../data/services/semua_pengeluaran_service.dart';
import '../../widgets/card/semua_pengeluaran_card.dart';

class PengeluaranDaftarPage extends StatefulWidget {
  const PengeluaranDaftarPage({super.key});

  @override
  State<PengeluaranDaftarPage> createState() => _PengeluaranDaftarPageState();
}

class _PengeluaranDaftarPageState extends State<PengeluaranDaftarPage> {
  // Sumber data (Service utama yang dipakai di halaman lain juga)
  final PengeluaranService _service = PengeluaranService();

  // State UI
  final List<PengeluaranModel> _pengeluaranCache = [];
  String _search = "";

  // Stream realtime dari Firestore (menggunakan factory dari model agar robust)
  Stream<List<PengeluaranModel>> _pengeluaranStream() {
    return FirebaseFirestore.instance
        .collection('pengeluaran')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((qs) => qs.docs
            .map(
              (doc) => PengeluaranModel.fromFirestore(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ),
            )
            .toList());
  }

  Future<void> _deleteData(String id) async {
    final ok = await _service.delete(id);
    if (ok) {
      setState(() {
        _pengeluaranCache.removeWhere((e) => e.id == id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil dihapus')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus data')),
        );
      }
    }
  }

  // Opsional: seed dummy untuk pengujian cepat (long press FAB)
  Future<void> _seedDummy() async {
    final col = FirebaseFirestore.instance.collection('pengeluaran');
    final batch = FirebaseFirestore.instance.batch();
    final now = FieldValue.serverTimestamp();

    final d1 = col.doc();
    batch.set(d1, {
      'nama': 'Perawatan Taman',
      'jenis': 'Perawatan',
      'tanggal': '14/12/2025', // simpan String atau seragamkan sesuai kebutuhan
      'nominal': '75000', // boleh String/number, tapi konsistenkan
      'created_at': now,
    });

    final d2 = col.doc();
    batch.set(d2, {
      'nama': 'Konsumsi Rapat',
      'jenis': 'Konsumsi',
      'tanggal': '15/12/2025',
      'nominal': '50000',
      'created_at': now,
    });

    await batch.commit();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dummy pengeluaran ditambahkan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      drawer: const AppSidebar(),
      floatingActionButton: GestureDetector(
        onLongPress: _seedDummy, // tahan lama untuk seed data uji
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF0C88C2),
          onPressed: () async {
            await Navigator.pushNamed(context, '/pengeluaran/tambah');
            // Dengan StreamBuilder, data otomatis ter-update setelah kembali
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainHeader(
              title: "Daftar Pengeluaran",
              searchHint: "Cari pengeluaran...",
              showSearchBar: true,
              showFilterButton: false,
              onSearch: (v) => setState(() => _search = v.trim()),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<PengeluaranModel>>(
                stream: _pengeluaranStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    // Tampilkan pesan error asli untuk memudahkan debug
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Gagal memuat data: ${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  final List<PengeluaranModel> data =
                      snapshot.data ?? const <PengeluaranModel>[];
                  // simpan ke cache (opsional)
                  _pengeluaranCache
                    ..clear()
                    ..addAll(data);

                  final list = data
                      .where((item) => _search.isEmpty
                          ? true
                          : item.nama
                              .toLowerCase()
                              .contains(_search.toLowerCase()))
                      .toList();

                  if (list.isEmpty) {
                    return const Center(child: Text('Belum ada data'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return PengeluaranCard(
                        data: item,
                        onDetail: () {
                          showDialog<void>(
                            context: context,
                            barrierColor: Colors.black.withOpacity(0.5),
                            builder: (ctx) => AlertDialog(
                              title: const Text('Detail Pengeluaran'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nama: ${item.nama}'),
                                  Text('Jenis: ${item.jenis}'),
                                  Text('Tanggal: ${item.tanggal}'),
                                  Text('Nominal: ${item.nominal}'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: const Text('Tutup'),
                                ),
                              ],
                            ),
                          );
                        },
                        onDelete: () => _deleteData(item.id),
                      );
                    },
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
