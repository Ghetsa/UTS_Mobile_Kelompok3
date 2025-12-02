import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pesan_warga_model.dart';

class PesanWargaService {
  /// Koleksi 'pesan_warga' di Firestore
  final CollectionReference<Map<String, dynamic>> _ref =
      FirebaseFirestore.instance.collection('pesan_warga');

  // ------------------------------------------------------------
  // 🔵 Ambil Semua Pesan Warga
  //    Contoh: untuk halaman "Semua Aspirasi"
  // ------------------------------------------------------------
  Future<List<PesanWargaModel>> getSemuaPesan() async {
    try {
      final snapshot = await _ref.orderBy('created_at', descending: true).get();

      return snapshot.docs
          .map(
            (doc) => PesanWargaModel.fromFirestore(
              doc.id,
              doc.data(),
            ),
          )
          .toList();
    } catch (e, st) {
      // Ini akan kelihatan jelas di debug console kalau Firestore bermasalah
      print('ERROR GET SEMUA PESAN WARGA: $e');
      print(st);
      return [];
    }
  }

  // ------------------------------------------------------------
  // 🟢 Tambah Pesan Warga
  // ------------------------------------------------------------
  Future<bool> tambahPesan(Map<String, dynamic> data) async {
    try {
      await _ref.add({
        ...data,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('ERROR TAMBAH PESAN WARGA: $e');
      return false;
    }
  }

  // Overload kalau mau langsung dari Model
  Future<bool> tambahPesanDariModel(PesanWargaModel model) async {
    try {
      final map = model.toMap();
      map['created_at'] = FieldValue.serverTimestamp();
      map['updated_at'] = FieldValue.serverTimestamp();
      await _ref.add(map);
      return true;
    } catch (e) {
      print('ERROR TAMBAH PESAN WARGA (MODEL): $e');
      return false;
    }
  }

  // ------------------------------------------------------------
  // 🟡 Update Pesan Warga
  // ------------------------------------------------------------
  Future<bool> updatePesan(String docId, Map<String, dynamic> data) async {
    try {
      await _ref.doc(docId).update({
        ...data,
        'updated_at': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('ERROR UPDATE PESAN WARGA: $e');
      return false;
    }
  }

  // Overload kalau mau langsung dari model
  Future<bool> updatePesanDariModel(PesanWargaModel model) async {
    try {
      final map = model.toMap();
      map.remove('created_at'); // jangan sentuh created_at waktu update
      map['updated_at'] = FieldValue.serverTimestamp();
      await _ref.doc(model.docId).update(map);
      return true;
    } catch (e) {
      print('ERROR UPDATE PESAN WARGA (MODEL): $e');
      return false;
    }
  }

  // ------------------------------------------------------------
  // 🔴 Hapus Pesan Warga
  // ------------------------------------------------------------
  Future<bool> deletePesan(String docId) async {
    try {
      await _ref.doc(docId).delete();
      return true;
    } catch (e) {
      print('ERROR DELETE PESAN WARGA: $e');
      return false;
    }
  }

  // ------------------------------------------------------------
  // 🟣 Detail Satu Pesan
  // ------------------------------------------------------------
  Future<PesanWargaModel?> getDetail(String docId) async {
    try {
      final doc = await _ref.doc(docId).get();

      if (!doc.exists) return null;

      return PesanWargaModel.fromFirestore(
        doc.id,
        doc.data()!,
      );
    } catch (e) {
      print('ERROR GET DETAIL PESAN WARGA: $e');
      return null;
    }
  }
}
