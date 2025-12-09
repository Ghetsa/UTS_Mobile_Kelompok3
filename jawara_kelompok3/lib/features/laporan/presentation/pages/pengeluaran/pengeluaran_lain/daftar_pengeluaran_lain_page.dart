import 'package:flutter/material.dart';
import '../../../../../../core/layout/header.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../controller/pengeluaran_lain_controller.dart';
import '../../../../data/models/pengeluaran_lain_model.dart';
import 'tambah_pengeluaran_lain_page.dart';

class DaftarPengeluaranLainPage extends StatefulWidget {
  const DaftarPengeluaranLainPage({super.key});

  @override
  State<DaftarPengeluaranLainPage> createState() =>
      _DaftarPengeluaranLainPageState();
}

class _DaftarPengeluaranLainPageState extends State<DaftarPengeluaranLainPage> {
  final PengeluaranLainController controller = PengeluaranLainController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainHeader(
              title: "Pengeluaran Lain - Daftar",
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
              child: StreamBuilder<List<PengeluaranLainModel>>(
                stream: controller.streamPengeluaran,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snap.hasData || snap.data!.isEmpty) {
                    return const Center(
                        child: Text("Belum ada pengeluaran lainnya."));
                  }

                  final data = snap.data!;

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return _buildPengeluaranCard(context, item);
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

  Widget _buildPengeluaranCard(
      BuildContext context, PengeluaranLainModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon kiri
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.money_off, color: Colors.red),
          ),
          const SizedBox(width: 16),

          // Teks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nama,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                ),
                const SizedBox(height: 4),
                Text("Jenis: ${item.jenis}",
                    style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(height: 2),
                Text("Tanggal: ${item.tanggal}",
                    style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(height: 8),
                Text("Rp ${item.nominal}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.primaryBlue,
                    )),
              ],
            ),
          ),

          // Tombol aksi
          PopupMenuButton(
            onSelected: (value) async {
              if (value == "edit") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TambahPengeluaranLainPage(
                      isEdit: true,
                      dataEdit: item,
                    ),
                  ),
                );
              } else if (value == "hapus") {
                await controller.deletePengeluaran(item.id);
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: "edit", child: Text("Edit")),
              PopupMenuItem(value: "hapus", child: Text("Hapus")),
            ],
          ),
        ],
      ),
    );
  }
}
