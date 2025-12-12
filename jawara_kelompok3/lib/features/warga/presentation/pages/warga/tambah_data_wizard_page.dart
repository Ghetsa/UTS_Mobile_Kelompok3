import 'package:flutter/material.dart';
import '../../../../../core/layout/header.dart';
import '../../../../../core/theme/app_theme.dart';

// PAGES (sesuai struktur kamu)
import '../warga/tambah_warga_page.dart';
import '../keluarga/tambah_keluarga_page.dart';
import '../mutasi/tambah_mutasi_page.dart';

class TambahDataWizardPage extends StatelessWidget {
  const TambahDataWizardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F2F9),
      body: SafeArea(
        child: Column(
          children: [
            const MainHeader(
              title: "Tambah Data",
              showSearchBar: false,
              showFilterButton: false,
            ),
            const SizedBox(height: 18),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _MenuCard(
                    title: "👶 Bayi baru lahir (anggota keluarga)",
                    subtitle: "Tambah warga baru lalu langsung masuk ke keluarga",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TambahWargaPage(
                            modeBayi: true,
                          ),
                        ),
                      );
                    },
                  ),
                  _MenuCard(
                    title: "📦 Keluarga pindah masuk",
                    subtitle: "Buat keluarga + pilih rumah + pilih kepala keluarga",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TambahKeluargaPage(),
                        ),
                      );
                    },
                  ),
                  _MenuCard(
                    title: "🚚 Mutasi pindah keluar/masuk/dalam",
                    subtitle: "Catat mutasi dan (opsional) update status warga",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MutasiTambahPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black26.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
