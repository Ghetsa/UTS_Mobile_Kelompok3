import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';

    return Drawer(
      child: Container(
        color:
            AppTheme.lightBlue, // 💙 biru muda lembut untuk background sidebar
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue, // 🔵 biru gelap untuk header
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
                      color: Color(0xFFE0E7FF), // teks biru muda lembut
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
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: const Icon(
                  Icons.receipt_long,
                  color: AppTheme.primaryBlue,
                ),
                title: const Text(
                  "Dashboard",
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  _buildSubMenuItem(
                    "Kegiatan",
                    "/dashboard/kegiatan",
                    context,
                    currentRoute,
                  ),
                  _buildSubMenuItem(
                    "Kependudukan",
                    "/dashboard/kependudukan",
                    context,
                    currentRoute,
                  ),
                  _buildSubMenuItem(
                    "Keuangan",
                    "/dashboard/keuangan",
                    context,
                    currentRoute,
                  ),
                ],
              ),
            ),
            _buildMenuItem(
              Icons.people,
              "Data Warga & Rumah",
              "/data",
              context,
              currentRoute,
            ),

            // === Pemasukan ===
            Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: const Icon(
                  Icons.receipt_long,
                  color: AppTheme.primaryBlue,
                ),
                title: const Text(
                  "Pemasukan",
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  _buildSubMenuItem(
                    "Kategori Iuran",
                    "/pemasukan/pages/kategori",
                    context,
                    currentRoute,
                  ),
                  _buildSubMenuItem(
                    "Tagih Iuran",
                    "/pemasukan/tagihIuran",
                    context,
                    currentRoute,
                  ),
                  _buildSubMenuItem(
                    "Tagihan",
                    "/pemasukan/tagihan",
                    context,
                    currentRoute,
                  ),
                  _buildSubMenuItem(
                    "Pemasukan Lain - Daftar",
                    "/pemasukan/pemasukanLain-daftar",
                    context,
                    currentRoute,
                  ),
                  _buildSubMenuItem(
                    "Pemasukan Lain - Tambah",
                    "/pemasukan/pemasukanLain-tambah",
                    context,
                    currentRoute,
                  ),
                ],
              ),
            ),

            // === Menu utama lain ===
            _buildMenuItem(
              Icons.insert_chart,
              "Laporan Keuangan",
              "/laporan",
              context,
              currentRoute,
            ),
            _buildMenuItem(
              Icons.people_alt,
              "Manajemen Pengguna",
              "/manajemen",
              context,
              currentRoute,
            ),
            _buildMenuItem(
              Icons.swap_horiz,
              "Channel Transfer",
              "/channel",
              context,
              currentRoute,
            ),
            _buildMenuItem(
              Icons.history,
              "Log Aktifitas",
              "/log",
              context,
              currentRoute,
            ),
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
            _buildMenuItem(
              Icons.wallet,
              "Pengeluaran",
              "/pengeluaran",
              context,
              currentRoute,
            ),
            _buildMenuItem(
              Icons.family_restroom,
              "Mutasi Keluarga",
              "/mutasi",
              context,
              currentRoute,
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
        leading: Icon(
          icon,
          color: isActive ? Colors.white : AppTheme.primaryBlue,
        ),
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
        contentPadding: const EdgeInsets.only(left: 60.0), // indent
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
