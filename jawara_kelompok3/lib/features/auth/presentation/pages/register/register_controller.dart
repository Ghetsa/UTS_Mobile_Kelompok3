import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dialogs.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    String? rumahId,
  }) async {
    // Validasi input dasar
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
      // BUAT USER DI FIREBASE AUTH
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final String uid = userCredential.user!.uid;
      String? photoUrl;

      // FUNCTION UPLOAD CLOUDINARY
      Future<String?> _uploadToCloudinary({
        required Uint8List bytes,
        required String filename,
        required String uid,
      }) async {
        try {
          final uri = Uri.parse(
            'https://api.cloudinary.com/v1_1/droup6ar3/image/upload',
          );

          final request = http.MultipartRequest('POST', uri)
            ..fields['upload_preset'] = 'jawara_unsigned'
            ..fields['folder'] = 'jawara/identitas/$uid'
            ..files.add(
              http.MultipartFile.fromBytes(
                'file',
                bytes,
                filename: filename,
              ),
            );

          final response = await request.send();
          final responseData = await response.stream.bytesToString();
          final json = jsonDecode(responseData);

          return json['secure_url'];
        } catch (e) {
          debugPrint('Cloudinary upload error: $e');
          return null;
        }
      }

      // VALIDASI & UPLOAD FOTO IDENTITAS (JIKA ADA)
      if (fotoIdentitas != null && profilePhotoName != null) {
        final fileName = profilePhotoName.toLowerCase();

        if (!fileName.endsWith('.jpg') &&
            !fileName.endsWith('.jpeg') &&
            !fileName.endsWith('.png')) {
          await showMessageDialog(
            context: context,
            title: 'Gagal!',
            message: 'Format foto harus JPG atau PNG',
            success: false,
          );
          return;
        }

        if (fotoIdentitas.lengthInBytes > 1024 * 1024) {
          await showMessageDialog(
            context: context,
            title: 'Gagal!',
            message: 'Ukuran foto maksimal 1 MB',
            success: false,
          );
          return;
        }

        photoUrl = await _uploadToCloudinary(
          bytes: fotoIdentitas,
          filename: profilePhotoName,
          uid: uid,
        );
      }

      // TENTUKAN RUMAH
      if (rumahId == null && alamat != null && alamat.isNotEmpty) {
        final rumahRef = _firestore.collection('rumah').doc();
        await rumahRef.set({
          'id': rumahRef.id,
          'alamat': alamat,
          'status_rumah': 'Dihuni',
          'kepemilikan': kepemilikan ?? '',
          'created_at': FieldValue.serverTimestamp(),
          'updated_at': FieldValue.serverTimestamp(),
        });
        rumahId = rumahRef.id;
      }

      // Validasi terakhir: rumah HARUS ada
      if (rumahId == null) {
        throw Exception('Data rumah tidak valid');
      }

      // SIMPAN DATA WARGA
      await _firestore.collection('warga').doc(uid).set({
        'uid': uid,
        'nik': nik,
        'nama': nama,
        'jenis_kelamin': jenis_kelamin ?? '',
        'no_hp': noHp,
        'id_rumah': rumahId,
        'agama': agama,
        'pekerjaan': pekerjaan,
        'status_warga': 'aktif',
        'photoUrl': photoUrl ?? '',
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });

      // SIMPAN DATA USER
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'role': role,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });

      // NOTIFIKASI SUKSES
      await showMessageDialog(
        context: context,
        title: 'Berhasil!',
        message: 'Akun berhasil dibuat. Silakan login.',
        success: true,
      );

      // Logout & redirect ke login
      await _auth.signOut();
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
        message: 'Terjadi kesalahan.\n$e',
        success: false,
      );
    }
  }
}
