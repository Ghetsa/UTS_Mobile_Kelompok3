import 'package:flutter/material.dart';
import '../data/services/aktivitas_service.dart';
import '../data/models/aktivitas_model.dart';

class AktivitasController {
  final LogService _logService = LogService();

  /// Tambah log baru
  Future<void> tambahLog({
    required String aktivitas,
    required String role,
    DateTime? tanggal,
  }) async {
    try {
      final log = Log(
        docId: '', // Firestore otomatis buat ID
        aktivitas: aktivitas,
        role: role,
        tanggal: tanggal ?? DateTime.now(),
      );

      await _logService.tambahLog(log);
      debugPrint('Log berhasil ditambahkan: $aktivitas');
    } catch (e) {
      debugPrint('Gagal menambahkan log: $e');
    }
  }

  /// Ambil semua log sebagai Stream
  Stream<List<Log>> getAllLogs() {
    return _logService.getAllLogs();
  }

  /// Tambah log otomatis untuk aksi CRUD
  Future<void> logTambah(String entity, String namaEntity, String role) async {
    await tambahLog(
      aktivitas: 'Menambahkan $entity: $namaEntity',
      role: role,
    );
  }

  Future<void> logUbah(String entity, String namaEntity, String role) async {
    await tambahLog(
      aktivitas: 'Mengubah $entity: $namaEntity',
      role: role,
    );
  }

  Future<void> logHapus(String entity, String namaEntity, String role) async {
    await tambahLog(
      aktivitas: 'Menghapus $entity: $namaEntity',
      role: role,
    );
  }
}
