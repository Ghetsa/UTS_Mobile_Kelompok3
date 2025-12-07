import 'package:flutter/material.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/layout/header.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../widgets/info_box.dart';
import '../../widgets/filter/pengeluaran_filter.dart'; 
import '../../widgets/card/semua_pengeluaran_card.dart';
import '../../../data/models/semua_pengeluaran_model.dart';
import '../../widgets/dialog/detail_semua_pengeluaran_dialog.dart';
import '../../widgets/dialog/edit_semua_pengeluaran_dialog.dart';
import '../../../data/services/semua_pengeluaran_service.dart';
import '../pengeluaran/tambah_pengeluaran_page.dart'; 

class SemuaPengeluaranPage extends StatefulWidget {
  const SemuaPengeluaranPage({super.key});

  @override
  State<SemuaPengeluaranPage> createState() => _SemuaPengeluaranPageState();
}

class _SemuaPengeluaranPageState extends State<SemuaPengeluaranPage> {
  final PengeluaranService _service = PengeluaranService();
  List<PengeluaranModel> dataPengeluaran = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPengeluaranData();
  }

  Future<void> _loadPengeluaranData() async {
    setState(() {
      _loading = true;
    });
    try {
      final data = await _service.getAll();
      setState(() {
        dataPengeluaran = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print("Error fetching pengeluaran data: $e");
    }
  }

  void _showDetailDialog(PengeluaranModel pengeluaran) {
    showDialog(
      context: context,
      builder: (context) => DetailPengeluaranDialog(pengeluaran: pengeluaran),
    );
  }

  void _showEditDialog(PengeluaranModel pengeluaran) async {
    final updatedPengeluaran = await showDialog<PengeluaranModel>(
      context: context,
      builder: (context) => EditPengeluaranDialog(pengeluaran: pengeluaran),
    );

    if (updatedPengeluaran != null) {
      final success = await _service.update(updatedPengeluaran.id, updatedPengeluaran.toMap());
      if (success) {
        setState(() {
          final index = dataPengeluaran.indexWhere((item) => item.id == updatedPengeluaran.id);
          if (index != -1) {
            dataPengeluaran[index] = updatedPengeluaran;
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal memperbarui data')));
      }
    }
  }

  void _deletePengeluaran(String id) async {
    final result = await _service.delete(id);
    if (result) {
      setState(() {
        dataPengeluaran.removeWhere((item) => item.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data berhasil dihapus")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal menghapus data"), backgroundColor: Colors.red));
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
              title: "Semua Pengeluaran",
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
                        builder: (_) => const PengeluaranFilterDialog(), 
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
                          builder: (_) => const TambahPengeluaranPage(),
                        ),
                      );
                      if (result == true) {
                        await _loadPengeluaranData();
                      }
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      "Tambah Pengeluaran",
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
                  : dataPengeluaran.isEmpty
                      ? const Center(child: Text("Belum ada pengeluaran"))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: dataPengeluaran.length,
                          itemBuilder: (_, index) {
                            final item = dataPengeluaran[index];
                            return PengeluaranCard(
                              data: item,
                              onDetail: () {
                                _showDetailDialog(item); // Tampilkan dialog detail
                              },
                              onEdit: () {
                                _showEditDialog(item); // Tampilkan dialog edit
                              },
                              onDelete: () {
                                _deletePengeluaran(item.id); // Tampilkan dialog hapus
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
