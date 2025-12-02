import 'package:flutter/material.dart';
import '../../../data/models/warga_model.dart';
import '../../../data/services/warga_service.dart';
import '../../../../../core/layout/header.dart';
import '../../../../../core/layout/sidebar.dart';
import '../../widgets/card/warga_card.dart';
import '../../widgets/filter/warga_filter.dart';
import 'detail_warga_page.dart';
import 'edit_warga_page.dart'; // pastikan file ini ada

class DaftarWargaPage extends StatefulWidget {
  const DaftarWargaPage({super.key});

  @override
  State<DaftarWargaPage> createState() => _DaftarWargaPageState();
}

class _DaftarWargaPageState extends State<DaftarWargaPage> {
  final WargaService _service = WargaService();
  List<WargaModel> data = [];

  String search = "";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F2F9),
      drawer: const AppSidebar(),

      /// Tombol Tambah
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0C88C2),
        elevation: 4,
        onPressed: () {
          Navigator.pushNamed(context, "/data-warga/tambah")
              .then((_) => loadData());
        },
        child: const Icon(Icons.add, size: 32, color: Colors.white),
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
                    onApply: (filterData) {},
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

                  /// Filter search
                  if (search.isNotEmpty &&
                      !item.nama.toLowerCase().contains(search.toLowerCase())) {
                    return const SizedBox();
                  }

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
