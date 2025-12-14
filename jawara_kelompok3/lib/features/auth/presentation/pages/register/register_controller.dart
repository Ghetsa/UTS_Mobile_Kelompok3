import 'dart:typed_data';
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
    required String nama,
    required String nik,
    required String noHp,
    required String role,
    required String agama,
    required String pekerjaan,
    Uint8List? fotoIdentitas,
    String? profilePhotoName,
    String? jenis_kelamin,
    String? alamat,
    String? kepemilikan,
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
      // Buat user disimpan di Firebase Auth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;
      String? photoUrl;

      // Upload foto simpan ke Storage
      if (fotoIdentitas != null && profilePhotoName != null) {
        try {
          final storageRef =
              _storage.ref().child('user_photos/$uid/$profilePhotoName');

          await storageRef.putData(fotoIdentitas);
          photoUrl = await storageRef.getDownloadURL();
        } catch (e) {
          // Rollback Auth jika upload gagal
          try {
            await userCredential.user!.delete();
          } catch (_) {}
          await showMessageDialog(
            context: context,
            title: 'Gagal!',
            message: 'Gagal upload foto.\nError: $e',
            success: false,
          );
          return;
        }
      }

      // Simpan data rumah
      DocumentReference rumahRef = _firestore.collection('rumah').doc();
      await rumahRef.set({
        'id': rumahRef.id,
        'alamat': alamat ?? '',
        'kepemilikan': kepemilikan ?? '',
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });

      // Simpan data warga
      await _firestore.collection('warga').doc(uid).set({
        'uid': uid,
        'nik': nik,
        'nama': nama,
        'jenis_kelamin': jenis_kelamin ?? '',
        'no_hp': noHp,
        'id_rumah': rumahRef.id,
        'agama': agama,   
        'pekerjaan': pekerjaan,       
        'status_warga': 'aktif', 
        'photoUrl': photoUrl, 
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });

      // Simpan data user
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'role': role,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });

      // Dialog sukses & redirect
      await showMessageDialog(
        context: context,
        title: 'Berhasil!',
        message: 'Akun berhasil dibuat. Silakan login.',
        success: true,
      );

      // Tambahan: logout user
      await _auth.signOut();

      // Navigasi ke login
      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      String message = 'Terjadi kesalahan, coba lagi.';
      if (e.code == 'email-already-in-use') message = 'Email sudah terdaftar.';
      if (e.code == 'invalid-email') message = 'Email tidak valid.';
      if (e.code == 'weak-password') message = 'Password terlalu lemah.';

      await showMessageDialog(
        context: context,
        title: 'Gagal!',
        message: message,
        success: false,
      );
    } catch (e) {
      await showMessageDialog(
        context: context,
        title: 'Gagal!',
        message: 'Terjadi kesalahan.\nError: $e',
        success: false,
      );
    }
  }
}
