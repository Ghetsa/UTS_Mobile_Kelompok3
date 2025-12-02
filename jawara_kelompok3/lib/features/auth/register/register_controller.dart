import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../firebase_options.dart';
import 'dialogs.dart';

class RegisterController {
  late FirebaseAuth _auth;

  RegisterController() {
    initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _auth = FirebaseAuth.instance;
  }

  Future<void> registerUser({
    required BuildContext context,
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String nik,
    required String phone,
    required String role,
    String? gender,
    String? address,
    String? ownershipStatus,
    String? fileName,
  }) async {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      await showMessageDialog(
        context: context,
        title: 'Gagal!',
        message: 'Email dan password wajib diisi',
        success: false,
      );
      return;
    }

    if (password != confirmPassword) {
      await showMessageDialog(
        context: context,
        title: 'Gagal!',
        message: 'Password dan konfirmasi password tidak cocok',
        success: false,
      );
      return;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'nama_lengkap': name,
        'role': role,
        'nik': nik,
        'telepon': phone,
        'gender': gender ?? '',
        'alamat': address ?? '',
        'status_kepemilikan': ownershipStatus ?? '',
        'foto': fileName ?? '',
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });

      await showMessageDialog(
        context: context,
        title: 'Berhasil!',
        message: 'Akun berhasil dibuat. Silakan login.',
        success: true,
      );

      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      String message = 'Terjadi kesalahan, coba lagi';

      if (e.code == 'email-already-in-use') message = 'Email sudah terdaftar';
      if (e.code == 'invalid-email') message = 'Email tidak valid';
      if (e.code == 'weak-password') message = 'Password terlalu lemah';

      await showMessageDialog(context: context, title: 'Gagal!', message: message, success: false);
    }
  }
}
