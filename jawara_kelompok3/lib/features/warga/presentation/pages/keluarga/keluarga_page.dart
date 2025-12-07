import 'package:flutter/material.dart';
import '../../../data/models/keluarga_model.dart';
import '../../../controller/keluarga_controller.dart';

import '../../../../../core/layout/header.dart';
import '../../../../../core/layout/sidebar.dart';
import '../../widgets/card/keluarga_card.dart';
import '../../widgets/filter/keluarga_filter.dart';
import '../keluarga/tambah_keluarga_page.dart';

import 'kelola_anggota_keluarga_page.dart';
import 'detail_keluarga_page.dart';
import 'edit_keluarga_page.dart';

class DaftarKeluargaPage extends StatefulWidget {
  const DaftarKeluargaPage({super.key});

  @override
  State<DaftarKeluargaPage> createState() => _DaftarKeluargaPageState();
}

class _DaftarKeluargaPageState extends State<DaftarKeluargaPage> {
  final KeluargaController _controller = KeluargaController();

  List<KeluargaModel> data = [];

  String search = "";

  /// 🔹 state filter aktif (diisi dari FilterKeluargaDialog)
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

  // ============================
  // HAPUS KELUARGA
  // ============================
  void _confirmDelete(KeluargaModel item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Keluarga?"),
        content:
            Text("Yakin ingin menghapus keluarga '${item.kepalaKeluarga}'?"),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus"),
            onPressed: () async {
              Navigator.pop(context);
              final ok = await _controller.delete(item.uid);
              if (ok) loadData();
            },
          ),
        ],
      ),
    );
  }

  /// 🔍 Helper: cek apakah 1 keluarga lolos filter
  bool _matchFilter(KeluargaModel k) {
    final fNama =
        (_activeFilter['nama_kepala'] ?? '').toString().trim().toLowerCase();
    final fStatus = (_activeFilter['status_keluarga'] ?? '')
        .toString()
        .trim()
        .toLowerCase();
    final fRumah =
        (_activeFilter['id_rumah'] ?? '').toString().trim().toLowerCase();

    // nama kepala keluarga
    if (fNama.isNotEmpty && !k.kepalaKeluarga.toLowerCase().contains(fNama)) {
      return false;
    }

    // status keluarga (abaikan jika kosong / "semua")
    if (fStatus.isNotEmpty &&
        fStatus != 'semua' &&
        k.statusKeluarga.toLowerCase() != fStatus) {
      return false;
    }

    // id_rumah (docId) mengandung teks
    if (fRumah.isNotEmpty && !k.idRumah.toLowerCase().contains(fRumah)) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F2F9),
      drawer: const AppSidebar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0C88C2),
        onPressed: () async {
          final res = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahKeluargaPage()),
          );
          if (res == true) loadData();
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: SafeArea(
        child: Column(
          children: [
            MainHeader(
              title: "Data Keluarga",
              searchHint: "Cari kepala keluarga...",
              showSearchBar: true,
              showFilterButton: true,
              onSearch: (v) => setState(() => search = v.trim()),
              onFilter: () => showDialog(
                context: context,
                builder: (_) => FilterKeluargaDialog(
                  onApply: (f) {
                    setState(() {
                      _activeFilter = f;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: data.length,
                itemBuilder: (_, i) {
                  final item = data[i];

                  // 🔍 text search utama
                  if (search.isNotEmpty &&
                      !item.kepalaKeluarga
                          .toLowerCase()
                          .contains(search.toLowerCase())) {
                    return const SizedBox();
                  }

                  // 🎯 filter dari dialog
                  if (!_matchFilter(item)) {
                    return const SizedBox();
                  }

                  return KeluargaCard(
                    data: item,
                    onDetail: () async {
                      final refresh = await showDialog<bool>(
                        context: context,
                        builder: (_) => DetailKeluargaPage(data: item),
                      );
                      if (refresh == true) {
                        await loadData();
                      }
                    },
                    onEdit: () async {
                      final updated = await showDialog<bool>(
                        context: context,
                        builder: (_) => EditKeluargaPage(data: item),
                      );
                      if (updated == true) {
                        await loadData();
                      }
                    },
                    onDelete: () => _confirmDelete(item),
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
