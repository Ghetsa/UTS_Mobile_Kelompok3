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
  // ...existing code...
  List<PengeluaranModel> pengeluaran = [];
  bool _loading = true;
  String search = "";

  final PengeluaranService _service = PengeluaranService();

  // Stream realtime dari Firestore
  Stream<List<PengeluaranModel>> _pengeluaranStream() {
    return FirebaseFirestore.instance
        .collection('pengeluaran')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((qs) => qs.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return PengeluaranModel(
                id: doc.id,
                nama: data['nama'] ?? '',
                jenis: data['jenis'] ?? '',
                tanggal: data['tanggal'] ?? '',
                nominal: data['nominal']?.toString() ?? '',
              );
            }).toList());
  }

  Future<void> _deleteData(String id) async {
    final ok = await _service.delete(id);
    if (ok) {
      setState(() {
        pengeluaran.removeWhere((e) => e.id == id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data berhasil dihapus')));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menghapus data')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      drawer: const AppSidebar(),
      floatingActionButton: GestureDetector(
        onLongPress: () async {
          // Hidden: seed two dummy docs for quick testing
          await _service.seedDummy();
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Dummy pengeluaran ditambahkan')),
          );
        },
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF0C88C2),
          onPressed: () async {
            await Navigator.pushNamed(context, '/pengeluaran/tambah');
            // Dengan StreamBuilder, data akan otomatis muncul saat dokumen baru ditambahkan.
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
              onSearch: (v) => setState(() => search = v.trim()),
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
                    return const Center(child: Text('Gagal memuat data'));
                  }

                  final list = (snapshot.data ?? [])
                      .where((item) => search.isEmpty
                          ? true
                          : item.nama
                              .toLowerCase()
                              .contains(search.toLowerCase()))
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

class PengeluaranService {
  final CollectionReference _pengeluaranCollection =
      FirebaseFirestore.instance.collection('pengeluaran');

  Future<List<PengeluaranModel>> getAll() async {
    try {
      final snapshot = await _pengeluaranCollection.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return PengeluaranModel(
          id: doc.id,
          nama: data['nama'] ?? '',
          jenis: data['jenis'] ?? '',
          tanggal: data['tanggal'] ?? '',
          nominal: data['nominal'] ?? '',
        );
      }).toList();
    } catch (e) {
      print('Error fetching pengeluaran data: $e');
      return [];
    }
  }

  Future<bool> delete(String id) async {
    try {
      await _pengeluaranCollection.doc(id).delete();
      return true;
    } catch (e) {
      print('Error deleting pengeluaran: $e');
      return false;
    }
  }

  // Seed two dummy pengeluaran docs for testing
  Future<void> seedDummy() async {
    final batch = FirebaseFirestore.instance.batch();
    final now = FieldValue.serverTimestamp();

    final d1 = _pengeluaranCollection.doc();
    batch.set(d1, {
      'nama': 'Perawatan Taman',
      'jenis': 'Perawatan',
      'tanggal': '14/12/2025',
      'nominal': '75000',
      'created_at': now,
    });

    final d2 = _pengeluaranCollection.doc();
    batch.set(d2, {
      'nama': 'Konsumsi Rapat',
      'jenis': 'Konsumsi',
      'tanggal': '15/12/2025',
      'nominal': '50000',
      'created_at': now,
    });

    await batch.commit();
  }
}
