import 'package:flutter/material.dart';
import '../../../../../../core/layout/header.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../widgets/dialog/detail_pemasukan_dialog.dart';
import '../../widgets/dialog/edit_pemasukan_dialog.dart';
import '../../../data/models/pemasukan_model.dart';
import '../../../data/services/pemasukan_service.dart';
import '../../widgets/card/pemasukan_card.dart';

class SemuaPemasukanPage extends StatefulWidget {
  const SemuaPemasukanPage({super.key});

  @override
  _SemuaPemasukanPageState createState() => _SemuaPemasukanPageState();
}

class _SemuaPemasukanPageState extends State<SemuaPemasukanPage> {
  final PemasukanService _service = PemasukanService();
  List<PemasukanModel> dataPemasukan = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPemasukanData();
  }

  Future<void> _loadPemasukanData() async {
    setState(() {
      _loading = true;
    });

    try {
      final data = await _service.getAll();
      setState(() {
        dataPemasukan = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print("Error fetching pemasukan data: $e");
    }
  }

  void _showDetailDialog(PemasukanModel pemasukan) {
    showDialog(
      context: context,
      builder: (context) => DetailPemasukanDialog(pemasukan: pemasukan),
    );
  }

  void _showEditDialog(PemasukanModel pemasukan) async {
    final updatedPemasukan = await showDialog<PemasukanModel>(
      context: context,
      builder: (context) => EditPemasukanDialog(pemasukan: pemasukan),
    );

    if (updatedPemasukan != null) {
      final success = await _service.update(updatedPemasukan.id, updatedPemasukan.toMap());
      if (success) {
        setState(() {
          final index = dataPemasukan.indexWhere((item) => item.id == updatedPemasukan.id);
          if (index != -1) {
            dataPemasukan[index] = updatedPemasukan;
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal memperbarui data')));
      }
    }
  }

  void _deletePemasukan(String id) async {
    final result = await _service.delete(id);
    if (result) {
      setState(() {
        dataPemasukan.removeWhere((item) => item.id == id);
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
            MainHeader(title: "Semua Pemasukan", showSearchBar: false, showFilterButton: false),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.yellowDark,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.filter_alt),
                  label: const Text("Filter"),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : dataPemasukan.isEmpty
                      ? const Center(child: Text("Belum ada data"))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: dataPemasukan.length,
                          itemBuilder: (context, index) {
                            final item = dataPemasukan[index];
                            return PemasukanCard(
                              data: item,
                              onDetail: () {
                                _showDetailDialog(item);
                              },
                              onEdit: () {
                                _showEditDialog(item);
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
