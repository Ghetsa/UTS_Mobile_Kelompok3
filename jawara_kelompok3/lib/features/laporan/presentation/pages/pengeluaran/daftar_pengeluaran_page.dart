import 'package:flutter/material.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../data/models/semua_pengeluaran_model.dart';
import '../../widgets/card/semua_pengeluaran_card.dart';

class PengeluaranDaftarPage extends StatefulWidget {
  const PengeluaranDaftarPage({super.key});

  @override
  State<PengeluaranDaftarPage> createState() => _PengeluaranDaftarPageState();
}

class _PengeluaranDaftarPageState extends State<PengeluaranDaftarPage> {
  late List<PengeluaranModel> pengeluaran;

  @override
  void initState() {
    super.initState();
    pengeluaran = [
      PengeluaranModel(
        id: '1',
        nama: 'Pembelian ATK',
        jenis: 'Operasional',
        tanggal: '13 Oktober 2025',
        nominal: 'Rp 500.000,00',
      ),
      PengeluaranModel(
        id: '2',
        nama: 'Perawatan Kantor',
        jenis: 'Perawatan',
        tanggal: '12 Agustus 2025',
        nominal: 'Rp 1.000.000,00',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      drawer: const AppSidebar(),
      appBar: AppBar(
        title: const Text("Daftar Pengeluaran"),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          children: [
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
                itemCount: pengeluaran.length,
                itemBuilder: (context, index) {
                  final item = pengeluaran[index];
                  return PengeluaranCard(
                    data: item,
                    onDetail: () {
                      showDialog<void>(
                        context: context,
                        barrierColor: Colors.black.withOpacity(0.5),
                        builder: (ctx) => AlertDialog(
                          title: const Text('Detail Pengeluaran'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Nama: ${item.nama}'),
                              Text('Jenis: ${item.jenis}'),
                              Text('Tanggal: ${item.tanggal}'),
                              Text('Nominal: ${item.nominal}'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text('Tutup'),
                            ),
                          ],
                        ),
                      );
                    },
                    onEdit: () async {
                      final updated = await showDialog<PengeluaranModel?>(
                        context: context,
                        barrierColor: Colors.black.withOpacity(0.5),
                        builder: (ctx) {
                          final namaC = TextEditingController(text: item.nama);
                          final jenisC =
                              TextEditingController(text: item.jenis);
                          final tanggalC =
                              TextEditingController(text: item.tanggal);
                          final nominalC =
                              TextEditingController(text: item.nominal);

                          return AlertDialog(
                            title: const Text('Edit Pengeluaran'),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                      controller: namaC,
                                      decoration: const InputDecoration(
                                          labelText: 'Nama')),
                                  TextField(
                                      controller: jenisC,
                                      decoration: const InputDecoration(
                                          labelText: 'Jenis')),
                                  TextField(
                                      controller: tanggalC,
                                      decoration: const InputDecoration(
                                          labelText: 'Tanggal')),
                                  TextField(
                                      controller: nominalC,
                                      decoration: const InputDecoration(
                                          labelText: 'Nominal')),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(null),
                                  child: const Text('Batal')),
                              TextButton(
                                onPressed: () {
                                  final newModel = PengeluaranModel(
                                    id: item.id,
                                    nama: namaC.text,
                                    jenis: jenisC.text,
                                    tanggal: tanggalC.text,
                                    nominal: nominalC.text,
                                  );
                                  Navigator.of(ctx).pop(newModel);
                                },
                                child: const Text('Simpan'),
                              ),
                            ],
                          );
                        },
                      );
                      if (updated != null) {
                        setState(() {
                          final i = pengeluaran.indexOf(item);
                          pengeluaran[i] = updated;
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
