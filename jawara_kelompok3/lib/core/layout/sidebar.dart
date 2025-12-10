import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSidebar extends StatefulWidget {
  const AppSidebar({super.key});

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  final Map<String, bool> _expanded = {};
  String? _lastRoute;

  final Duration _animationDuration = const Duration(milliseconds: 300);
  bool _isAnimating = false;

  final Gradient mainGradient = const LinearGradient(
    colors: [
      Color(0xFF48B0E0),
      Color(0xFF0C88C2),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  void initState() {
    super.initState();
    _expanded.addAll({
      'dashboard': false,
      'data_warga': false,
      'keuangan': false,
      'manajemen_pengguna': false,
      'channel_transfer': false,
      'log_aktifitas': false,
      'pesan_warga': false,
      'pengeluaran': false,
      'pengeluaran_lain': false,
      'mutasi_keluarga': false,
    });
  }

  /// ✅ COCOKKAN DENGAN PREFIX ROUTE YANG KAMU PAKAI
  bool _routeMatches(String menuKey, String route) {
    if (route.isEmpty) return false;

    switch (menuKey) {
      case 'dashboard':
        return route.startsWith('/dashboard');
      case 'data_warga':
        return route.startsWith('/data-warga') ||
            route.startsWith('/data-rumah') ||
            route.startsWith('/data-keluarga') ||
            route.startsWith('/mutasi');
      case 'keuangan':
        return route.startsWith('/keuangan') ||
            route.startsWith('/pemasukan') ||
            route.startsWith('/pengeluaran') ||
            route.startsWith('/laporan');
      case 'pengeluaran_lain':
        return route.startsWith('/pengeluaranLain');
      case 'manajemen_pengguna':
        return route.startsWith('/pengguna');
      case 'channel_transfer':
        return route.startsWith('/channel');
      case 'log_aktifitas':
        return route.startsWith('/semuaAktifitas');
      case 'pesan_warga':
        return route.startsWith('/aspirasi');

      case 'pengeluaran':
        return route.startsWith('/pengeluaran');
      case 'mutasi_keluarga':
        return route.startsWith('/mutasi');
      default:
        return false;
    }
  }

  void _ensureInitialExpansion(String currentRoute) {
    if (_lastRoute == currentRoute) return;
    _lastRoute = currentRoute;

    _expanded.forEach((k, _) {
      _expanded[k] = _routeMatches(k, currentRoute);
    });
  }

  void _expandOnlyAnimated(String key, bool expanded) {
    if (_isAnimating) return;

    _isAnimating = true;
    setState(() {
      _expanded[key] = expanded;
    });

    Future.delayed(_animationDuration, () {
      _isAnimating = false;
    });
  }

  Widget _buildSubMenuItem(
    String label,
    String route,
    BuildContext context,
    String currentRoute, {
    VoidCallback? onSelected,
  }) {
    final bool selected = currentRoute == route;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
        if (onSelected != null) onSelected();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? AppTheme.blueExtraLight : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.circle,
              size: 8,
              color: selected ? const Color(0xFF0C88C2) : Colors.grey.shade500,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  color: const Color(0xFF0C88C2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';
    _ensureInitialExpansion(currentRoute);

    return Drawer(
      child: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            decoration: BoxDecoration(gradient: mainGradient),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.3),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child:
                      const Icon(Icons.person, size: 36, color: Colors.white),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Admin Jawara",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "admin1@gmail.com",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          // BODY
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  /// DASHBOARD
                  _buildMenuSection(
                    icon: Icons.dashboard_rounded,
                    title: "Dashboard",
                    keyValue: "dashboard",
                    context: context,
                    currentRoute: currentRoute,
                    children: [
                      _buildSubMenuItem("Kegiatan", "/dashboard/kegiatan",
                          context, currentRoute),
                      _buildSubMenuItem("Kependudukan",
                          "/dashboard/kependudukan", context, currentRoute),
                      _buildSubMenuItem("Keuangan", "/dashboard/keuangan",
                          context, currentRoute),
                    ],
                  ),

                  /// DATA KEPENDUDUKAN
                  _buildMenuSection(
                    icon: Icons.people_alt_rounded,
                    title: "Data Kependudukan",
                    keyValue: "data_warga",
                    context: context,
                    currentRoute: currentRoute,
                    children: [
                      _buildSubMenuItem("Data Warga", "/data-warga/daftar",
                          context, currentRoute),
                      _buildSubMenuItem("Data Rumah", "/data-rumah/daftar",
                          context, currentRoute),
                      _buildSubMenuItem("Data Keluarga", "/data-keluarga",
                          context, currentRoute),
                      _buildSubMenuItem("Mutasi Keluarga", "/mutasi/daftar",
                          context, currentRoute),
                    ],
                  ),

                  /// PESAN WARGA
                  _buildMenuSection(
                    icon: Icons.mark_chat_unread_rounded,
                    title: "Pesan Warga",
                    keyValue: "pesan_warga",
                    context: context,
                    currentRoute: currentRoute,
                    children: [
                      _buildSubMenuItem(
                        "Informasi & Aspirasi",
                        "/aspirasi/informasiAspirasi",
                        context,
                        currentRoute,
                      ),
                      _buildSubMenuItem(
                        "Tambah Aspirasi",
                        "/aspirasi/tambahAspirasi",
                        context,
                        currentRoute,
                      ),
                    ],
                  ),

                  /// PEMASUKAN
                  _buildMenuSection(
                    icon: Icons.payments_rounded,
                    title: "Pemasukan",
                    keyValue: "pemasukan",
                    context: context,
                    currentRoute: currentRoute,
                    children: [
                      _buildSubMenuItem("Kategori Iuran",
                          "/pemasukan/pages/kategori", context, currentRoute),
                      _buildSubMenuItem("Tagih Iuran", "/pemasukan/tagihIuran",
                          context, currentRoute),
                      _buildSubMenuItem("Tagihan", "/pemasukan/tagihan",
                          context, currentRoute),
                      _buildSubMenuItem(
                          "Pemasukan Lain - Daftar",
                          "/pemasukan/pemasukanLain-daftar",
                          context,
                          currentRoute),
                      _buildSubMenuItem(
                          "Pemasukan Lain - Tambah",
                          "/pemasukan/pemasukanLain-tambah",
                          context,
                          currentRoute),
                    ],
                  ),

                  /// PENGELUARAN LAIN
                  _buildMenuSection(
                    icon: Icons.money_off_rounded,
                    title: "Pengeluaran",
                    keyValue: "pengeluaran_lain",
                    context: context,
                    currentRoute: currentRoute,
                    children: [
                      _buildSubMenuItem("Pengeluaran Lain - Daftar",
                          "/pengeluaranLain/daftar", context, currentRoute),
                      _buildSubMenuItem("Pengeluaran Lain - Tambah",
                          "/pengeluaranLain/tambah", context, currentRoute),
                    ],
                  ),

                  /// KEUANGAN (LAPORAN)
                  _buildMenuSection(
                    icon: Icons.bar_chart_rounded,
                    title: "Keuangan",
                    keyValue: "keuangan",
                    context: context,
                    currentRoute: currentRoute,
                    children: [
                      _buildSubMenuItem(
                          "Pemasukan", "/pemasukan", context, currentRoute),
                      _buildSubMenuItem("Pengeluaran",
                          "/laporan/semua-pengeluaran", context, currentRoute),
                    ],
                  ),

                  /// MANAJEMEN PENGGUNA
                  _buildMenuSection(
                    icon: Icons.person_search_rounded,
                    title: "Manajemen Pengguna",
                    keyValue: "manajemen_pengguna",
                    context: context,
                    currentRoute: currentRoute,
                    children: [
                      _buildSubMenuItem("Daftar Pengguna",
                          "/pengguna/penggunaDaftar", context, currentRoute),
                      _buildSubMenuItem("Tambah Pengguna",
                          "/pengguna/penggunaTambah", context, currentRoute),
                    ],
                  ),

                  /// CHANNEL TRANSFER
                  _buildMenuSection(
                    icon: Icons.swap_horiz_rounded,
                    title: "Channel Transfer",
                    keyValue: "channel_transfer",
                    context: context,
                    currentRoute: currentRoute,
                    children: [
                      _buildSubMenuItem("Daftar Channel",
                          "/channel/channelDaftar", context, currentRoute),
                      _buildSubMenuItem("Tambah Channel",
                          "/channel/channelTambah", context, currentRoute),
                    ],
                  ),

                  ListTile(
                    leading: const Icon(Icons.logout_rounded,
                        color: AppTheme.redDark),
                    title: const Text(
                      "Logout",
                      style: TextStyle(
                          color: AppTheme.redDark, fontWeight: FontWeight.bold),
                    ),
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool(
                          'logged_out', true); // tandai sudah logout
                      await FirebaseAuth.instance
                          .signOut(); // logout dari Firebase

                      // Navigasi ke login dan hapus semua route sebelumnya
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMenuSection({
    required IconData icon,
    required String title,
    required String keyValue,
    required BuildContext context,
    required String currentRoute,
    required List<Widget> children,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        key: ValueKey('${keyValue}_${_expanded[keyValue]}'),
        initiallyExpanded: _expanded[keyValue] ?? false,
        onExpansionChanged: (expanded) =>
            _expandOnlyAnimated(keyValue, expanded),
        leading: ShaderMask(
          shaderCallback: (bounds) => mainGradient.createShader(bounds),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0C88C2),
          ),
        ),
        children: children,
      ),
    );
  }
}
