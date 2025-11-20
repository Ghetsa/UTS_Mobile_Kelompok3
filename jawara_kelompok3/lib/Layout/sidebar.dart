import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  @override
  void initState() {
    super.initState();
    _expanded.addAll({
      'dashboard': false,
      'data_warga': false,
      'pemasukan': false,
      'laporan_keuangan': false,
      'manajemen_pengguna': false,
      'channel_transfer': false,
      'log_aktifitas': false,
      'pesan_warga': false,
      'pengeluaran': false,
      'mutasi_keluarga': false,
    });
  }

  bool _routeMatches(String menuKey, String route) {
    if (route.isEmpty) return false;

    switch (menuKey) {
      case 'dashboard':
        return route.startsWith('/dashboard');
      case 'data_warga':
        return route.startsWith('/warga') ||
            route.startsWith('/keluarga') ||
            route.startsWith('/rumah');
      case 'pemasukan':
        return route.startsWith('/pemasukan');
      case 'laporan_keuangan':
        return route.startsWith('/laporan');
      case 'manajemen_pengguna':
        return route.startsWith('/pengguna');
      case 'channel_transfer':
        return route.startsWith('/channel');
      case 'log_aktifitas':
        return route.startsWith('/semuaAktifitas');
      case 'pesan_warga':
        return route.startsWith('/informasiAspirasi');
      case 'pengeluaran':
        return route.startsWith('/pengeluaran');
      case 'mutasi_keluarga':
        return route.startsWith('/mutasi');
      default:
        return false;
    }
  }

  void _ensureInitialExpansion(String currentRoute) {
    if (_lastRoute == currentRoute) return; // no change
    _expanded.forEach((k, _) {
      _expanded[k] = _routeMatches(k, currentRoute);
    });
    _lastRoute = currentRoute;
  }

  void _expandOnly(String menuKey, bool expanded) {
    setState(() {
      _expanded.forEach((k, _) {
        _expanded[k] = (k == menuKey) ? expanded : false;
      });
    });
  }

  Future<void> _expandOnlyAnimated(String menuKey, bool expand) async {
    if (_isAnimating) return;

    if (!expand) {
      setState(() => _expanded[menuKey] = false);
      return;
    }

    final currentOpen = _expanded.entries
        .firstWhere((e) => e.value, orElse: () => MapEntry('', false));

    if (currentOpen.key == '' || currentOpen.key == menuKey) {
      setState(() {
        _expanded.forEach((k, _) => _expanded[k] = (k == menuKey));
      });
      return;
    }

    _isAnimating = true;
    setState(() => _expanded[currentOpen.key] = false);

    await Future.delayed(_animationDuration);

    setState(() {
      _expanded.forEach((k, _) => _expanded[k] = (k == menuKey));
    });

    await Future.delayed(const Duration(milliseconds: 40));
    _isAnimating = false;
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';

    _ensureInitialExpansion(currentRoute);

    return Drawer(
      child: Container(
        color: AppTheme.lightBlue,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
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

            // === Dashboard ===
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                key: ValueKey('dashboard_${_expanded['dashboard'] ?? false}'),
                leading:
                    const Icon(Icons.receipt_long, color: AppTheme.primaryBlue),
                title: const Text(
                  "Dashboard",
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                childrenPadding: EdgeInsets.zero,
                initiallyExpanded: _expanded['dashboard'] ?? false,
                onExpansionChanged: (expanded) =>
                    _expandOnlyAnimated('dashboard', expanded),
                children: [
                  _buildSubMenuItem(
                    "Kegiatan",
                    "/dashboard/kegiatan",
                    context,
                    currentRoute,
                    onSelected: () => _expandOnlyAnimated('dashboard', true),
                  ),
                  _buildSubMenuItem(
                    "Kependudukan",
                    "/dashboard/kependudukan",
                    context,
                    currentRoute,
                    onSelected: () => _expandOnlyAnimated('dashboard', true),
                  ),
                  _buildSubMenuItem(
                    "Keuangan",
                    "/dashboard/keuangan",
                    context,
                    currentRoute,
                    onSelected: () => _expandOnlyAnimated('dashboard', true),
                  ),
                ],
              ),
            ),

            // === Data Warga & Rumah ===
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                key: ValueKey('data_warga_${_expanded['data_warga'] ?? false}'),
                leading: const Icon(Icons.people, color: AppTheme.primaryBlue),
                title: const Text(
                  "Data Warga & Rumah",
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                initiallyExpanded: _expanded['data_warga'] ?? false,
                onExpansionChanged: (expanded) =>
                    _expandOnlyAnimated('data_warga', expanded),
                children: [
                  _buildSubMenuItem(
                      "Warga - Daftar", "/warga/daftar", context, currentRoute,
                      onSelected: () =>
                          _expandOnlyAnimated('data_warga', true)),
                  _buildSubMenuItem(
                      "Warga - Tambah", "/warga/tambah", context, currentRoute,
                      onSelected: () =>
                          _expandOnlyAnimated('data_warga', true)),
                  _buildSubMenuItem(
                      "Keluarga", "/keluarga", context, currentRoute,
                      onSelected: () =>
                          _expandOnlyAnimated('data_warga', true)),
                  _buildSubMenuItem(
                      "Rumah - Daftar", "/rumah/daftar", context, currentRoute,
                      onSelected: () =>
                          _expandOnlyAnimated('data_warga', true)),
                  _buildSubMenuItem(
                      "Rumah - Tambah", "/rumah/tambah", context, currentRoute,
                      onSelected: () =>
                          _expandOnlyAnimated('data_warga', true)),
                ],
              ),
            ),

            // === Pemasukan ===
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                key: ValueKey('pemasukan_${_expanded['pemasukan'] ?? false}'),
                leading:
                    const Icon(Icons.receipt_long, color: AppTheme.primaryBlue),
                title: const Text(
                  "Pemasukan",
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                initiallyExpanded: _expanded['pemasukan'] ?? false,
                onExpansionChanged: (expanded) =>
                    _expandOnlyAnimated('pemasukan', expanded),
                children: [
                  _buildSubMenuItem("Kategori Iuran",
                      "/pemasukan/pages/kategori", context, currentRoute,
                      onSelected: () => _expandOnlyAnimated('pemasukan', true)),
                  _buildSubMenuItem("Tagih Iuran", "/pemasukan/tagihIuran",
                      context, currentRoute,
                      onSelected: () => _expandOnlyAnimated('pemasukan', true)),
                  _buildSubMenuItem(
                      "Tagihan", "/pemasukan/tagihan", context, currentRoute,
                      onSelected: () => _expandOnlyAnimated('pemasukan', true)),
                  _buildSubMenuItem("Pemasukan Lain - Daftar",
                      "/pemasukan/pemasukanLain-daftar", context, currentRoute,
                      onSelected: () => _expandOnlyAnimated('pemasukan', true)),
                  _buildSubMenuItem("Pemasukan Lain - Tambah",
                      "/pemasukan/pemasukanLain-tambah", context, currentRoute,
                      onSelected: () => _expandOnlyAnimated('pemasukan', true)),
                ],
              ),
            ),

            // === Laporan Keuangan ===
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                key: ValueKey(
                    'laporan_keuangan_${_expanded['laporan_keuangan'] ?? false}'),
                leading:
                    const Icon(Icons.bar_chart, color: AppTheme.primaryBlue),
                title: const Text(
                  "Laporan Keuangan",
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                initiallyExpanded: _expanded['laporan_keuangan'] ?? false,
                onExpansionChanged: (expanded) =>
                    _expandOnlyAnimated('laporan_keuangan', expanded),
                children: [
                  _buildSubMenuItem("Semua Pemasukan",
                      "/laporan/semua-pemasukan", context, currentRoute,
                      onSelected: () =>
                          _expandOnlyAnimated('laporan_keuangan', true)),
                  _buildSubMenuItem("Semua Pengeluaran",
                      "/laporan/semua-pengeluaran", context, currentRoute,
                      onSelected: () =>
                          _expandOnlyAnimated('laporan_keuangan', true)),
                  _buildSubMenuItem(
                      "Cetak Laporan", "/laporan/cetak", context, currentRoute,
                      onSelected: () =>
                          _expandOnlyAnimated('laporan_keuangan', true)),
                ],
              ),
            ),

            // === Manajemen Pengguna (ExpansionTile) ===
            Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                key: ValueKey(
                    'manajemen_pengguna_${_expanded['manajemen_pengguna'] ?? false}'),
                leading: const Icon(
                  Icons.receipt_long,
                  color: AppTheme.primaryBlue,
                ),
                title: const Text(
                  "Manajemen Pengguna",
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                initiallyExpanded: _expanded['manajemen_pengguna'] ?? false,
                onExpansionChanged: (expanded) =>
                    _expandOnlyAnimated('manajemen_pengguna', expanded),
                children: [
                  _buildSubMenuItem(
                    "Daftar Pengguna",
                    "/pengguna/penggunaDaftar",
                    context,
                    currentRoute,
                    onSelected: () =>
                        _expandOnlyAnimated('manajemen_pengguna', true),
                  ),
                  _buildSubMenuItem(
                    "Tambah Pengguna",
                    "/pengguna/penggunaTambah",
                    context,
                    currentRoute,
                    onSelected: () =>
                        _expandOnlyAnimated('manajemen_pengguna', true),
                  ),
                ],
              ),
            ),

            // === Channel Transfer ===
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                key: ValueKey(
                    'channel_transfer_${_expanded['channel_transfer'] ?? false}'),
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
                initiallyExpanded: _expanded['channel_transfer'] ?? false,
                onExpansionChanged: (expanded) =>
                    _expandOnlyAnimated('channel_transfer', expanded),
                children: [
                  _buildSubMenuItem(
                    "Daftar Channel",
                    "/channel/channelDaftar",
                    context,
                    currentRoute,
                    onSelected: () =>
                        _expandOnlyAnimated('channel_transfer', true),
                  ),
                  _buildSubMenuItem(
                    "Tambah Channel",
                    "/channel/channelTambah",
                    context,
                    currentRoute,
                    onSelected: () =>
                        _expandOnlyAnimated('channel_transfer', true),
                  ),
                ],
              ),
            ),

            // === Log Aktifitas ===
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                key: ValueKey(
                    'log_aktifitas_${_expanded['log_aktifitas'] ?? false}'),
                leading: const Icon(
                  Icons.history,
                  color: AppTheme.primaryBlue,
                ),
                title: const Text(
                  "Log Aktifitas",
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                initiallyExpanded: _expanded['log_aktifitas'] ?? false,
                onExpansionChanged: (expanded) =>
                    _expandOnlyAnimated('log_aktifitas', expanded),
                children: [
                  _buildSubMenuItem(
                    "Semua Aktifitas",
                    "/semuaAktifitas",
                    context,
                    currentRoute,
                    onSelected: () =>
                        _expandOnlyAnimated('log_aktifitas', true),
                  ),
                ],
              ),
            ),

            // === Pesan Warga ===
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                key: ValueKey(
                    'pesan_warga_${_expanded['pesan_warga'] ?? false}'),
                leading: const Icon(
                  Icons.message,
                  color: AppTheme.primaryBlue,
                ),
                title: const Text(
                  "Pesan Warga",
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                initiallyExpanded: _expanded['pesan_warga'] ?? false,
                onExpansionChanged: (expanded) =>
                    _expandOnlyAnimated('pesan_warga', expanded),
                children: [
                  _buildSubMenuItem(
                    "Informasi Aspirasi",
                    "/informasiAspirasi",
                    context,
                    currentRoute,
                    onSelected: () => _expandOnlyAnimated('pesan_warga', true),
                  ),
                ],
              ),
            ),

            // === Menu Broadcast ===
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                key: ValueKey(
                    'KegiatanBroadcast_${_expanded['KegiatanBroadcast'] ?? false}'),
                leading: const Icon(Icons.event, color: AppTheme.primaryBlue),
                title: const Text(
                  "Kegiatan & Broadcast",
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                initiallyExpanded: _expanded['KegiatanBroadcast'] ?? false,
                onExpansionChanged: (expanded) =>
                    _expandOnlyAnimated('KegiatanBroadcast', expanded),
                children: [
                  _buildSubMenuItem("Kegiatan - Daftar", "/kegiatan/daftar",
                      context, currentRoute,
                      onSelected: () =>
                          _expandOnlyAnimated('KegiatanBroadcast', true)),
                  _buildSubMenuItem("Kegiatan - Tambah", "/kegiatan/tambah",
                      context, currentRoute,
                      onSelected: () =>
                          _expandOnlyAnimated('KegiatanBroadcast', true)),
                  _buildSubMenuItem("Broadcast - Daftar", "/broadcast/daftar",
                      context, currentRoute,
                      onSelected: () =>
                          _expandOnlyAnimated('KegiatanBroadcast', true)),
                  _buildSubMenuItem("Broadcast - Tambah", "/broadcast/tambah",
                      context, currentRoute,
                      onSelected: () =>
                          _expandOnlyAnimated('KegiatanBroadcast', true)),
                ],
              ),
            ),

            // Pengeluaran
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                key: ValueKey(
                    'pengeluaran_${_expanded['pengeluaran'] ?? false}'),
                leading:
                    const Icon(Icons.bar_chart, color: AppTheme.primaryBlue),
                title: const Text(
                  "Pengeluaran",
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                initiallyExpanded: _expanded['pengeluaran'] ?? false,
                onExpansionChanged: (expanded) =>
                    _expandOnlyAnimated('pengeluaran', expanded),
                children: [
                  _buildSubMenuItem(
                      "Daftar", "/pengeluaran/daftar", context, currentRoute,
                      onSelected: () =>
                          _expandOnlyAnimated('pengeluaran', true)),
                  _buildSubMenuItem(
                      "Tambah", "/pengeluaran/tambah", context, currentRoute,
                      onSelected: () =>
                          _expandOnlyAnimated('pengeluaran', true)),
                ],
              ),
            ),

            // Mutasi Keluarga with submenu
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                key: ValueKey(
                    'mutasi_keluarga_${_expanded['mutasi_keluarga'] ?? false}'),
                leading: const Icon(Icons.family_restroom,
                    color: AppTheme.primaryBlue),
                title: const Text(
                  "Mutasi Keluarga",
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                initiallyExpanded: _expanded['mutasi_keluarga'] ?? false,
                onExpansionChanged: (expanded) =>
                    _expandOnlyAnimated('mutasi_keluarga', expanded),
                children: [
                  _buildSubMenuItem(
                      "Daftar", "/mutasi/daftar", context, currentRoute,
                      onSelected: () =>
                          _expandOnlyAnimated('mutasi_keluarga', true)),
                  _buildSubMenuItem(
                      "Tambah", "/mutasi/tambah", context, currentRoute,
                      onSelected: () =>
                          _expandOnlyAnimated('mutasi_keluarga', true)),
                ],
              ),
            ),

            // === Logout ===
            ListTile(
              leading: const Icon(Icons.logout, color: AppTheme.primaryBlue),
              title: const Text(
                "Logout",
                style: TextStyle(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Konfirmasi Logout"),
                      content: const Text("Apakah Anda yakin ingin logout?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Batal"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.redMediumDark,
                            foregroundColor: AppTheme.grayMediumLight,
                          ),
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Logout"),
                        ),
                      ],
                    );
                  },
                );

                if (confirm == true) {
                  // tutup drawer SETELAH dialog
                  Navigator.pop(context);

                  try {
                    await FirebaseAuth.instance.signOut();
                  } catch (e) {}

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                }
              },
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
    String currentRoute, {
    VoidCallback? onSelected,
  }) {
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
          if (onSelected != null) onSelected();

          Navigator.pop(context);
          if (ModalRoute.of(context)?.settings.name != route) {
            Navigator.pushNamed(context, route);
          }
        },
      ),
    );
  }
}
