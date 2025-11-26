import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/warga_model.dart';

class WargaService {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection("warga");

  /// ------------------------------------------------------------
  /// Ambil Semua Warga (urut nama)
  /// ------------------------------------------------------------
  Future<List<WargaModel>> getAllWarga() async {
    try {
      final snapshot = await _ref.orderBy("nama").get();

      return snapshot.docs
          .map((doc) => WargaModel.fromFirestore(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ))
          .toList();
    } catch (e) {
      print("ERROR GET ALL WARGA: $e");
      return [];
    }
  }

  /// ------------------------------------------------------------
  /// Detail Warga
  /// ------------------------------------------------------------
  Future<WargaModel?> getById(String id) async {
    try {
      final doc = await _ref.doc(id).get();
      if (!doc.exists) return null;

      return WargaModel.fromFirestore(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
    } catch (e) {
      print("ERROR GET DETAIL WARGA: $e");
      return null;
    }
  }

  /// ------------------------------------------------------------
  /// Tambah Warga (uid menjadi ID doc)
  /// ------------------------------------------------------------
  Future<bool> addWarga(WargaModel warga) async {
    try {
      await _ref.doc(warga.uid).set(warga.toMap());
      return true;
    } catch (e) {
      print("ERROR ADD WARGA: $e");
      return false;
    }
  }

  /// ------------------------------------------------------------
  /// Update Warga (tidak ganti UID)
  /// ------------------------------------------------------------
  Future<bool> updateWarga(String id, WargaModel warga) async {
    try {
      await _ref.doc(id).update(warga.toMap());
      return true;
    } catch (e) {
      print("ERROR UPDATE WARGA: $e");
      return false;
    }
  }

  /// ------------------------------------------------------------
  /// Hapus Warga
  /// ------------------------------------------------------------
  Future<bool> deleteWarga(String id) async {
    try {
      await _ref.doc(id).delete();
      return true;
    } catch (e) {
      print("ERROR DELETE WARGA: $e");
      return false;
    }
  }
}
