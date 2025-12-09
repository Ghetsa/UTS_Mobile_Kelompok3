import 'package:flutter/material.dart';
import '../../../../../../core/layout/header.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../controller/pengeluaran_lain_controller.dart';
import '../../../../data/models/pengeluaran_lain_model.dart';
import '../../../widgets/card/pengeluaran_card.dart';
import '../../../widgets/dialog/detail_pengeluaran_lain_dialog.dart';
import '../../../widgets/dialog/edit_pengeluaran_lain_dialog.dart';
import 'tambah_pengeluaran_lain_page.dart';

class PengeluaranLainDaftarPage extends StatefulWidget {
  const PengeluaranLainDaftarPage({super.key});

  @override
  State<PengeluaranLainDaftarPage> createState() =>
      _PengeluaranLainDaftarPageState();
}

class _PengeluaranLainDaftarPageState extends State<PengeluaranLainDaftarPage> {
  final PengeluaranLainController _controller = PengeluaranLainController();
  List<PengeluaranLainModel> data = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    data = await _controller.fetchAll();
    setState(() {});
  }

  void _confirmDelete(PengeluaranLainModel pengeluaran) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Pengeluaran?"),
        content: Text("Yakin ingin menghapus '${pengeluaran.nama}' ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              final ok = await _controller.delete(pengeluaran.docId);
              if (ok) {
                await loadData();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Pengeluaran berhasil dihapus."),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Gagal menghapus pengeluaran."),
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
      MaterialPageRoute(builder: (_) => const PengeluaranLainTambahPage()),
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
            MainHeader(
              title: "Pengeluaran Lain - Daftar",
              showSearchBar: false,
              showFilterButton: false,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: data.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox,
                            size: 64,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Belum ada pengeluaran",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: data.length,
                      itemBuilder: (_, i) {
                        final item = data[i];
                        final dataMap = {
                          'id': item.docId,
                          'nama': item.nama,
                          'jenis': item.jenis,
                          'tanggal': item.tanggal,
                          'nominal': item.nominal,
                        };
                        return PengeluaranCard(
                          data: dataMap,
                          onDetail: () {
                            showDialog(
                              context: context,
                              barrierColor: Colors.black.withOpacity(0.5),
                              builder: (_) =>
                                  DetailPengeluaranDialog(pengeluaran: dataMap),
                            );
                          },
                          onEdit: () async {
                            final updated = await showDialog<Map<String, dynamic>>(context: context,
                              barrierColor: Colors.black.withOpacity(0.5),
                              builder: (_) =>
                                  EditPengeluaranDialog(pengeluaran: dataMap),
                            );
                            if (updated != null) {
                              await _controller.update(item.docId, updated);
                              loadData();
                            }
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
