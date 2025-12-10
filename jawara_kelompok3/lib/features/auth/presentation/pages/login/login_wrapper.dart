import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login.dart'; // import LoginScreen

class LoginScreenWrapper extends StatefulWidget {
  const LoginScreenWrapper({super.key});

  @override
  State<LoginScreenWrapper> createState() => _LoginScreenWrapperState();
}

class _LoginScreenWrapperState extends State<LoginScreenWrapper> {
  bool _checkingSession = true;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final auth = FirebaseAuth.instance;

    final loggedOut = prefs.getBool('logged_out') ?? false;
    final user = auth.currentUser;

    if (!loggedOut && user != null) {
      String role = 'warga';
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists && doc.data()!.containsKey('role')) {
          role = doc.data()!['role'].toString();
        }
      } catch (_) {}

      String route = '/dashboard/kegiatan';
      switch (role.toLowerCase()) {
        case 'admin':
          route = '/dashboard/admin';
          break;
        case 'ketua_rt':
        case 'ketuart':
        case 'ketua-rt':
          route = '/dashboard/rt';
          break;
        case 'ketua_rw':
        case 'ketuarw':
        case 'ketua-rw':
          route = '/dashboard/rw';
          break;
        case 'bendahara':
          route = '/dashboard/bendahara';
          break;
        case 'sekretaris':
          route = '/dashboard/sekretaris';
          break;
        case 'warga':
        default:
          route = '/dashboard/kegiatan';
      }

      Navigator.pushReplacementNamed(context, route);
      return;
    }

    setState(() {
      _checkingSession = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingSession) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return const LoginScreen();
  }
}
