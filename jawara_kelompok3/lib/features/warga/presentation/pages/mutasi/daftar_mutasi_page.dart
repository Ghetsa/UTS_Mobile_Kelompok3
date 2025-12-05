import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final list = _controller.filteredData;

    return Scaffold(
      backgroundColor: const Color(0xFFE9F2F9),
      drawer: const AppSidebar(),
      floatingActionButton: FloatingActionButton(
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
                      // sementara hanya print
                      print("HASIL FILTER: $filterData");
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
