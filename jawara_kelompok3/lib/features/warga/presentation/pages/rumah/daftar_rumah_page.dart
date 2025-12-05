import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      drawer: const AppSidebar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryBlue,
        elevation: 4,
        onPressed: _openAdd,
        child: const Icon(Icons.add, size: 32, color: Colors.white),
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
                itemCount: data.length,
                itemBuilder: (_, i) {
                  final item = data[i];

                  // 🔍 Filter text search global (alamat + rt/rw)
                  final searchable = "${item.alamat} ${item.rt}/${item.rw}";
                  if (search.isNotEmpty &&
                      !searchable
                          .toLowerCase()
                          .contains(search.toLowerCase())) {
                    return const SizedBox();
                  }

                  // 🎯 Filter berdasarkan dialog
                  if (!_matchFilter(item)) {
                    return const SizedBox();
                  }

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
