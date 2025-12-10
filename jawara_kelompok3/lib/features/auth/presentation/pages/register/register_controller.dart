import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dialogs.dart';

class RegisterController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> registerUser({
    required BuildContext context,
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String nik,
    required String phone,
    required String role,
    Uint8List? profilePhotoBytes, // untuk web
    String? profilePhotoName, // untuk nama file
    String? gender,
    String? address,
    String? ownershipStatus,
  }) async {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      await showMessageDialog(
          context: context,
          title: 'Gagal!',
          message: 'Email dan password wajib diisi',
          success: false);
      return;
    }

    if (password != confirmPassword) {
      await showMessageDialog(
          context: context,
          title: 'Gagal!',
          message: 'Password dan konfirmasi password tidak cocok',
          success: false);
      return;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String? photoUrl;

      // Upload file ke Firebase Storage
      if (profilePhotoBytes != null && profilePhotoName != null) {
        try {
          final ref = _storage.ref().child(
              'user_photos/${userCredential.user!.uid}/$profilePhotoName');
          await ref.putData(profilePhotoBytes);
          photoUrl = await ref.getDownloadURL();
        } catch (e) {
          await userCredential.user!.delete();
          await showMessageDialog(
              context: context,
              title: 'Gagal!',
              message: 'Gagal upload foto profil.\nError: $e',
              success: false);
          return;
        }
      }

      // Simpan data user ke Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'nama_lengkap': name,
        'role': role,
        'nik': nik,
        'telepon': phone,
        'gender': gender ?? '',
        'alamat': address ?? '',
        'status_kepemilikan': ownershipStatus ?? '',
        'foto': photoUrl ?? '',
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });

      await showMessageDialog(
          context: context,
          title: 'Berhasil!',
          message: 'Akun berhasil dibuat. Silakan login.',
          success: true);

      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      String message = 'Terjadi kesalahan, coba lagi';
      if (e.code == 'email-already-in-use') message = 'Email sudah terdaftar';
      if (e.code == 'invalid-email') message = 'Email tidak valid';
      if (e.code == 'weak-password') message = 'Password terlalu lemah';

      await showMessageDialog(
          context: context, title: 'Gagal!', message: message, success: false);
    } catch (e) {
      await showMessageDialog(
          context: context,
          title: 'Gagal!',
          message: 'Terjadi kesalahan.\nError: $e',
          success: false);
    }
  }
}
