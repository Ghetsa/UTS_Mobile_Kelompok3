import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/auth/presentation/pages/login/login.dart';

// admin dashboard kamu (sesuaikan)
import '../../features/dashboard/presentation/pages/kegiatan_dashboard_page.dart';

// warga dashboard (baru)
import '../../features/WARGA/presentation/pages/warga_dashboard_page.dart';

class RoleRouter extends StatelessWidget {
  const RoleRouter({super.key});

  Future<String> _getRole(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final role = (doc.data()?['role'] ?? 'warga').toString().trim().toLowerCase();
      return role.isEmpty ? 'warga' : role;
    } catch (_) {
      return 'warga';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (_, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final user = snap.data;
        if (user == null) return const LoginScreen();

        return FutureBuilder<String>(
          future: _getRole(user.uid),
          builder: (_, rs) {
            if (!rs.hasData) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            final role = rs.data!;
            if (role == 'admin') return const DashboardKegiatanPage();
            return const WargaDashboardPage();
          },
        );
      },
    );
  }
}
