import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';

    return Drawer(
      child: Container(
        color: AppTheme.lightBlue, // 💙 Background sidebar biru muda lembut
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue, // 🔵 Header biru tua
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: AppTheme.backgroundBlueWhite,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Admin Jawara",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "admin1@gmail.com",
                    style: TextStyle(
                      color: Color(0xFFE0E7FF),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // === Menu utama ===
            // _buildMenuItem(Icons.dashboard, "Dashboard", "/", context, currentRoute),
            // === Pemasukan ===
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading:
                    const Icon(Icons.receipt_long, color: AppTheme.primaryBlue),
                title: const Text(
                  "Dashboard",
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  _buildSubMenuItem(
                      "Kegiatan", "/dashboard/kegiatan", context, currentRoute),
                  _buildSubMenuItem("Kependudukan", "/dashboard/kependudukan",
                      context, currentRoute),
                  _buildSubMenuItem(
                      "Keuangan", "/dashboard/keuangan", context, currentRoute),
                ],
              ),
            ),

            // === Data Warga & Rumah ===
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: const Icon(Icons.people, color: AppTheme.primaryBlue),
                title: const Text(
                  "Data Warga & Rumah",
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  _buildSubMenuItem(
                      "Warga - Daftar", "/warga/daftar", context, currentRoute),
                  _buildSubMenuItem(
                      "Warga - Tambah", "/warga/tambah", context, currentRoute),
                  _buildSubMenuItem(
                      "Keluarga", "/keluarga", context, currentRoute),
                  _buildSubMenuItem(
                      "Rumah - Daftar", "/rumah/daftar", context, currentRoute),
                  _buildSubMenuItem(
                      "Rumah - Tambah", "/rumah/tambah", context, currentRoute),
                ],
              ),
            ),

            // === Pemasukan (ExpansionTile) ===
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading:
                    const Icon(Icons.receipt_long, color: AppTheme.primaryBlue),
                title: const Text(
                  "Pemasukan",
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  _buildSubMenuItem("Kategori Iuran",
                      "/pemasukan/pages/kategori", context, currentRoute),
                  _buildSubMenuItem("Tagih Iuran", "/pemasukan/tagihIuran",
                      context, currentRoute),
                  _buildSubMenuItem(
                      "Tagihan", "/pemasukan/tagihan", context, currentRoute),
                  _buildSubMenuItem("Pemasukan Lain - Daftar",
                      "/pemasukan/pemasukanLain-daftar", context, currentRoute),
                  _buildSubMenuItem("Pemasukan Lain - Tambah",
                      "/pemasukan/pemasukanLain-tambah", context, currentRoute),
                ],
              ),
            ),

            // === Laporan Keuangan (ExpansionTile) ===
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading:
                    const Icon(Icons.bar_chart, color: AppTheme.primaryBlue),
                title: const Text(
                  "Laporan Keuangan",
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  _buildSubMenuItem("Semua Pemasukan", "/laporan/semua-pemasukan", context, currentRoute),
                  _buildSubMenuItem("Semua Pengeluaran", "/laporan/semua-pengeluaran", context, currentRoute),
                  _buildSubMenuItem("Cetak Laporan", "/laporan/cetak", context, currentRoute),
                ],
              ),
            ),

            // Laporan Keuangan (Menu Utama Lain - Duplikasi)
            _buildMenuItem(
              Icons.insert_chart,
              "Laporan Keuangan",
              "/laporan",
              context,
              currentRoute,
            ),

            // === Channel Transfer (DIUBAH MENJADI ExpansionTile) ===
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: const Icon(
                  Icons.swap_horiz,
                  color: AppTheme.primaryBlue,
                ),
                title: const Text(
                  "Channel Transfer",
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  _buildSubMenuItem(
                    "Daftar Channel",
                    "/channel/channelDaftar",
                    context,
                    currentRoute,
                  ),
                  _buildSubMenuItem(
                    "Tambah Channel",
                    "/channel/channelTambah",
                    context,
                    currentRoute,
                  ),
                ],
              ),
            ),

            // === Log Aktifitas (DIUBAH MENJADI ExpansionTile DENGAN SUB MENU) ===
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: const Icon(
                  Icons.history, // Icon yang sudah ada
                  color: AppTheme.primaryBlue,
                ),
                title: const Text(
                  "Log Aktifitas",
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  // Sub Menu: Semua Aktifitas
                  _buildSubMenuItem(
                    "Semua Aktifitas",
                    "/semuaAktifitas", 
                    context,
                    currentRoute,
                  ),
                  // Anda bisa menambahkan sub menu lain di sini jika diperlukan
                ],
              ),
            ),

            // Menu yang tersisa (tidak diubah)
            _buildMenuItem(
              Icons.message,
              "Pesan Warga",
              "/pesan",
              context,
              currentRoute,
            ),
            _buildMenuItem(
              Icons.event,
              "Kegiatan & Broadcast",
              "/kegiatan",
              context,
              currentRoute,
            ),

            // Pengeluaran
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading:
                    const Icon(Icons.bar_chart, color: AppTheme.primaryBlue),
                title: const Text(
                  "Pengeluaran",
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  _buildSubMenuItem("Dafar", "/pengeluaran/daftar",context, currentRoute),
                  _buildSubMenuItem("Tambah", "/pengeluaran/tambah",context, currentRoute),
                ],
              ),
            ),

            // Mutasi Keluarga with submenu
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: const Icon(Icons.family_restroom,
                    color: AppTheme.primaryBlue),
                title: const Text(
                  "Mutasi Keluarga",
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  _buildSubMenuItem(
                      "Daftar", "/mutasi/daftar", context, currentRoute),
                  _buildSubMenuItem(
                      "Tambah", "/mutasi/tambah", context, currentRoute),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Menu utama biasa
  static Widget _buildMenuItem(
    IconData icon,
    String title,
    String route,
    BuildContext context,
    String currentRoute,
  ) {
    final bool isActive = route == currentRoute;

    return Container(
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primaryBlue : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading:
            Icon(icon, color: isActive ? Colors.white : AppTheme.primaryBlue),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : AppTheme.primaryBlue,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          if (ModalRoute.of(context)?.settings.name != route) {
            Navigator.pushNamed(context, route);
          }
        },
      ),
    );
  }

  /// Submenu
  static Widget _buildSubMenuItem(
    String title,
    String route,
    BuildContext context,
    String currentRoute,
  ) {
    final bool isActive = route == currentRoute;

    return Container(
      decoration: BoxDecoration(
        color: isActive
            ? AppTheme.primaryBlue.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.only(left: 60.0), // indent submenu
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? AppTheme.primaryBlue : const Color(0xFF1E40AF),
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          if (ModalRoute.of(context)?.settings.name != route) {
            Navigator.pushNamed(context, route);
          }
        },
      ),
    );
  }
}
