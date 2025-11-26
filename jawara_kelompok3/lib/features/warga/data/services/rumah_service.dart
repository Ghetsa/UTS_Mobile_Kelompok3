import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/rumah_model.dart';

class RumahService {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection("rumah");

  /// Ambil semua rumah terurut (by alamat)
  Future<List<RumahModel>> getAllRumah() async {
    try {
      final snapshot = await _ref.orderBy('alamat').get();
      return snapshot.docs
          .map((d) => RumahModel.fromFirestore(d.id, d.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("ERROR GET ALL RUMAH: $e");
      return [];
    }
  }

  /// Ambil 1 rumah berdasarkan doc id
  Future<RumahModel?> getById(String id) async {
    try {
      final doc = await _ref.doc(id).get();
      if (!doc.exists) return null;
      return RumahModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
    } catch (e) {
      print("ERROR GET RUMAH BY ID: $e");
      return null;
    }
  }

  /// Tambah rumah (pakai id sebagai doc id jika disediakan)
  Future<bool> addRumah(RumahModel rumah) async {
    try {
      // jika id kosong gunakan add, tapi id pada model direkomendasikan diisi
      if (rumah.id.isEmpty) {
        await _ref.add(rumah.toMap());
      } else {
        await _ref.doc(rumah.id).set(rumah.toMap());
      }
      return true;
    } catch (e) {
      print("ERROR ADD RUMAH: $e");
      return false;
    }
  }

  /// Update rumah
  Future<bool> updateRumah(String id, Map<String, dynamic> data) async {
    try {
      await _ref.doc(id).update({
        ...data,
        "updated_at": FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print("ERROR UPDATE RUMAH: $e");
      return false;
    }
  }

  /// Hapus rumah
  Future<bool> deleteRumah(String id) async {
    try {
      await _ref.doc(id).delete();
      return true;
    } catch (e) {
      print("ERROR DELETE RUMAH: $e");
      return false;
    }
  }
}
