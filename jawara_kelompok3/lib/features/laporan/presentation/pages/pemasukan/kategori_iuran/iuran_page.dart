import 'package:flutter/material.dart';
import '../../../../../../core/layout/header.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../widgets/info_box.dart';
import '../../../widgets/filter/kategori_iuran_filter.dart';
import '../../../widgets/card/kategori_iuran_card.dart';
import '../../../../data/models/kategori_iuran_model.dart';
import '../../../widgets/dialog/detail_kategori_dialog.dart';
import '../../../widgets/dialog/edit_kategori_dialog.dart';

import '../../../../data/services/kategori_iuran_service.dart';

import '../kategori_iuran/tambah_iuran_page.dart';

class KategoriIuranPage extends StatefulWidget {
  const KategoriIuranPage({super.key});

  @override
  State<KategoriIuranPage> createState() => _KategoriIuranPageState();
}

class _KategoriIuranPageState extends State<KategoriIuranPage> {
  final KategoriIuranService _service = KategoriIuranService();
  List<KategoriIuranModel> dataIuran = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await _service.getAll();
    setState(() {
      dataIuran = list;
      _loading = false;
    });
  }

  // Fungsi untuk menampilkan dialog detail kategori iuran
  void _showDetailDialog(KategoriIuranModel kategori) {
    showDialog(
      context: context,
      builder: (context) => DetailKategoriDialog(
        kategori: {
          'nama': kategori.nama,
          'jenis': kategori.jenis,
          'nominal': kategori.nominal,
        },
      ),
    );
  }

  // Fungsi untuk menampilkan dialog edit kategori iuran
  void _showEditDialog(KategoriIuranModel kategori) async {
    final updatedKategori = await showDialog<KategoriIuranModel>(
      context: context,
      builder: (context) => EditIuranDialog(
        iuran: {
          'id': kategori.id,
          'nama': kategori.nama,
          'jenis': kategori.jenis,
          'nominal': kategori.nominal,
        },
      ),
    );

    if (updatedKategori != null) {
      // Menggunakan metode update dari service
      final success = await _service.update(
        updatedKategori.id,
        updatedKategori.toMap(), // Mengonversi model menjadi map
      );

      if (success) {
        setState(() {
          final index =
              dataIuran.indexWhere((item) => item.id == updatedKategori.id);
          if (index != -1) {
            dataIuran[index] = updatedKategori;
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui data')),
        );
      }
    }
  }

  // Fungsi untuk menampilkan dialog hapus kategori iuran
  void _deleteKategori(String id) async {
    final result = await _service.delete(id); // Panggil fungsi delete
    if (result) {
      setState(() {
        // Menghapus data dari UI setelah berhasil dihapus
        dataIuran.removeWhere((item) => item.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data berhasil dihapus")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Gagal menghapus data"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      drawer: const AppSidebar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainHeader(
              title: "Kategori Iuran",
              showSearchBar: false,
              showFilterButton: false,
            ),
            const SizedBox(height: 18),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: InfoBox(),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (_) => const FilterKategoriIuranDialog(),
                      );
                      if (result != null) debugPrint("Filter dipilih: $result");
                    },
                    icon: const Icon(Icons.filter_alt, color: Colors.white),
                    label: const Text(
                      "Filter",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.yellowMediumDark,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push<bool?>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TambahKategoriPage(),
                        ),
                      );
                      if (result == true) {
                        await _load();
                      }
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      "Tambah",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.greenDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : dataIuran.isEmpty
                      ? const Center(child: Text("Belum ada kategori iuran"))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: dataIuran.length,
                          itemBuilder: (_, index) {
                            final item = dataIuran[index];
                            return KategoriIuranCard(
                              row: item,
                              onDetail: () {
                                _showDetailDialog(
                                    item); // Tampilkan dialog detail
                              },
                              onEdit: () {
                                _showEditDialog(item); // Tampilkan dialog edit
                              },
                              onDelete: () {
                                _deleteKategori(
                                    item.id); // Tampilkan dialog hapus
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
