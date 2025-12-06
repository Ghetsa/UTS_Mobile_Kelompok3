import 'package:flutter/material.dart';
import '../../../../../../core/layout/header.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../widgets/dialog/detail_pemasukan_lain_dialog.dart';
import '../../../widgets/dialog/edit_pemasukan_lain_dialog.dart';
import '../../../widgets/card/pemasukan_lain_card.dart';
import '../../../../data/models/pemasukan_lain_model.dart';

class PemasukanLainDaftarPage extends StatefulWidget {
  const PemasukanLainDaftarPage({super.key});

  @override
  State<PemasukanLainDaftarPage> createState() =>
      _PemasukanLainDaftarPageState();
}

class _PemasukanLainDaftarPageState extends State<PemasukanLainDaftarPage> {
  late List<PemasukanLainModel> pemasukan;

  @override
  void initState() {
    super.initState();
    pemasukan = [
      PemasukanLainModel(
        id: "1",
        nama: "Joki by Firman",
        jenis: "Pendapatan Lainnya",
        tanggal: "13 Oktober 2025",
        nominal: "Rp 49.999.997,00",
      ),
      PemasukanLainModel(
        id: "2",
        nama: "Tes",
        jenis: "Pendapatan Lainnya",
        tanggal: "12 Agustus 2025",
        nominal: "Rp 10.000,00",
      ),
    ];
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
              title: "Pemasukan Lain - Daftar",
              showSearchBar: false,
              showFilterButton: false,
            ),

            const SizedBox(height: 18),

            // Tombol Filter di atas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.yellowDark,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.filter_alt),
                  label: const Text("Filter"),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: pemasukan.length,
                itemBuilder: (context, index) {
                  final item = pemasukan[index];
                  return PemasukanCard(
                    data: item,
                    onDetail: () {
                      // Mengonversi PemasukanLainModel ke Map<String, String>
                      final dataMap = {
                        'id': item.id,
                        'nama': item.nama,
                        'jenis': item.jenis,
                        'tanggal': item.tanggal,
                        'nominal': item.nominal,
                      };
                      showDialog(
                        context: context,
                        barrierColor: Colors.black.withOpacity(0.5),
                        builder: (_) =>
                            DetailPemasukanDialog(pemasukan: dataMap),
                      );
                    },
                    onEdit: () async {
                      final dataMap = {
                        'id': item.id,
                        'nama': item.nama,
                        'jenis': item.jenis,
                        'tanggal': item.tanggal,
                        'nominal': item.nominal,
                      };

                      // Mengonversi Map<String, String> ke PemasukanLainModel
                      final updated = await showDialog<Map<String, String>>(
                        context: context,
                        barrierColor: Colors.black.withOpacity(0.5),
                        builder: (_) => EditPemasukanDialog(pemasukan: dataMap),
                      );
                      if (updated != null) {
                        setState(() {
                          // Mengonversi kembali Map ke PemasukanLainModel
                          pemasukan[index] =
                              PemasukanLainModel.fromMap(updated);
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
