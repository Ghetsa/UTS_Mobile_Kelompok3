import 'package:flutter/material.dart';
import '../../../../data/models/pemasukan_lain_model.dart';
import '../../../../data/services/pemasukan_lain_service.dart';
import '../../../../../../core/layout/header.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../widgets/card/pemasukan_lain_card.dart';
import '../../../widgets/dialog/detail_pemasukan_lain_dialog.dart';
import '../../../widgets/dialog/edit_pemasukan_lain_dialog.dart';

class PemasukanLainDaftarPage extends StatefulWidget {
  const PemasukanLainDaftarPage({super.key});

  @override
  _PemasukanLainDaftarPageState createState() => _PemasukanLainDaftarPageState();
}

class _PemasukanLainDaftarPageState extends State<PemasukanLainDaftarPage> {
  List<PemasukanLainModel> pemasukan = [];
  bool _loading = true;
  final PemasukanLainService _service = PemasukanLainService();

  @override
  void initState() {
    super.initState();
    _fetchPemasukanData();
  }

  Future<void> _fetchPemasukanData() async {
    setState(() {
      _loading = true;
    });

    try {
      final data = await _service.getAll();
      setState(() {
        pemasukan = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print("Error fetching pemasukan data: $e");
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
            MainHeader(title: "Pemasukan Lain - Daftar", showSearchBar: false, showFilterButton: false),
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
                  : pemasukan.isEmpty
                      ? const Center(child: Text("Belum ada data"))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: pemasukan.length,
                          itemBuilder: (context, index) {
                            final item = pemasukan[index];
                            return PemasukanCard(
                              data: item,
                              onDetail: () {
                                final dataMap = {'id': item.id, 'nama': item.nama, 'jenis': item.jenis, 'tanggal': item.tanggal, 'nominal': item.nominal};
                                showDialog(
                                  context: context,
                                  barrierColor: Colors.black.withOpacity(0.5),
                                  builder: (_) => DetailPemasukanDialog(pemasukan: dataMap),
                                );
                              },
                              onEdit: () async {
                                final dataMap = {'id': item.id, 'nama': item.nama, 'jenis': item.jenis, 'tanggal': item.tanggal, 'nominal': item.nominal};
                                final updated = await showDialog<Map<String, String>>(
                                  context: context,
                                  barrierColor: Colors.black.withOpacity(0.5),
                                  builder: (_) => EditPemasukanDialog(pemasukan: dataMap),
                                );
                                if (updated != null) {
                                  setState(() {
                                    pemasukan[index] = PemasukanLainModel.fromMap(updated);
                                  });
                                }
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
