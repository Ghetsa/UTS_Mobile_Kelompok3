import 'package:flutter/material.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../controller/pengeluaran_lain_controller.dart';
import '../../../../data/models/pengeluaran_lain_model.dart';
import 'tambah_pengeluaran_lain_page.dart';

class DaftarPengeluaranLainPage extends StatelessWidget {
  DaftarPengeluaranLainPage({super.key});

  final PengeluaranLainController controller = PengeluaranLainController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengeluaran Lain")),
      drawer: const AppSidebar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TambahPengeluaranLainPage(),
            ),
          );
        },
      ),
      body: StreamBuilder<List<PengeluaranLainModel>>(
        stream: controller.streamPengeluaran,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snap.hasData || snap.data!.isEmpty) {
            return const Center(child: Text("Belum ada pengeluaran tambahan."));
          }

          final data = snap.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, i) {
              final x = data[i];

              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(x.nama),
                  subtitle: Text(
                    "Jenis: ${x.jenis}\n"
                    "Tanggal: ${x.tanggal}\n"
                    "Nominal: Rp ${x.nominal}",
                  ),
                  trailing: PopupMenuButton(
                    onSelected: (value) async {
                      if (value == "edit") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TambahPengeluaranLainPage(
                              isEdit: true,
                              dataEdit: x,
                            ),
                          ),
                        );
                      } else if (value == "hapus") {
                        await controller.deletePengeluaran(x.id);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: "edit", child: Text("Edit")),
                      PopupMenuItem(value: "hapus", child: Text("Hapus")),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
