import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/layout/sidebar.dart';
import '../../../../../core/layout/header.dart';

import '../../../data/models/rumah_model.dart';
import '../../../controller/rumah_controller.dart'; // ⬅️ pakai controller
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

              // pakai docId untuk delete
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
            /// HEADER
            MainHeader(
              title: "Data Rumah",
              searchHint: "Cari alamat / penghuni / RT RW...",
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
                      // Nanti bisa dipakai untuk filter RT/RW/status/kepemilikan
                      print("HASIL FILTER RUMAH: $filterData");
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            /// LIST DATA
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: data.length,
                itemBuilder: (_, i) {
                  final item = data[i];

                  // FILTER SEARCH: alamat + rt/rw + penghuni (id keluarga)
                  final searchable =
                      "${item.alamat} ${item.rt}/${item.rw} ${item.penghuniKeluargaId}";
                  if (search.isNotEmpty &&
                      !searchable
                          .toLowerCase()
                          .contains(search.toLowerCase())) {
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
