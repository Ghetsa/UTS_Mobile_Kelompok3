import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/kategori_iuran_model.dart';

class KategoriIuranService {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection("kategori_iuran");

  // READ all
  Future<List<KategoriIuranModel>> getAll() async {
    try {
      final snap = await _ref.orderBy("nama").get();
      return snap.docs
          .map((d) => KategoriIuranModel.fromFirestore(
                d.id,
                d.data() as Map<String, dynamic>,
              ))
          .toList();
    } catch (e) {
      print("ERROR getAll kategori_iuran: $e");
      return [];
    }
  }

  // READ by id
  Future<KategoriIuranModel?> getById(String id) async {
    try {
      final doc = await _ref.doc(id).get();
      if (!doc.exists) return null;
      return KategoriIuranModel.fromFirestore(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
    } catch (e) {
      print("ERROR getById kategori_iuran: $e");
      return null;
    }
  }

  // CREATE
  Future<bool> add(Map<String, dynamic> data) async {
    try {
      await _ref.add({
        ...data,
        "created_at": FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print("ERROR add kategori_iuran: $e");
      return false;
    }
  }

  // UPDATE
  Future<bool> update(String id, Map<String, dynamic> data) async {
    try {
      await _ref.doc(id).update({
        ...data,
        'updated_at': FieldValue.serverTimestamp(), 
      });
      return true;
    } catch (e) {
      print("ERROR update kategori_iuran: $e");
      return false;
    }
  }

  // DELETE
  Future<bool> delete(String id) async {
    try {
      await _ref.doc(id).delete();
      return true;
    } catch (e) {
      print("ERROR delete kategori_iuran: $e");
      return false;
    }
  }
}
