import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'kegiatan_dashboard_page.dart';

// ✅ halaman warga yang sudah kamu buat
import '../../../WARGA/presentation/pages/warga_dashboard_page.dart';

class DashboardGatePage extends StatefulWidget {
  const DashboardGatePage({super.key});

  @override
  State<DashboardGatePage> createState() => _DashboardGatePageState();
}

class _DashboardGatePageState extends State<DashboardGatePage> {
  Future<String> _getRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = (prefs.getString('role') ?? 'warga').toLowerCase().trim();
    return role;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getRole(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final role = (snap.data ?? 'warga').toLowerCase().trim();

        // ✅ warga masuk ke dashboard warga
        if (role == 'warga') {
          return const WargaDashboardPage();
        }

        // ✅ selain warga = admin/rt/rw/bendahara/sekretaris → dashboard admin yg lama
        return const DashboardKegiatanPage();
      },
    );
  }
}
