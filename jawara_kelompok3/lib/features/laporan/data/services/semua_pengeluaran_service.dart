import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/semua_pengeluaran_model.dart';

class PengeluaranService {
  final CollectionReference _ref = FirebaseFirestore.instance.collection("pengeluaran");

  // GET all data
  Future<List<PengeluaranModel>> getAll() async {
    try {
      final snap = await _ref.orderBy("tanggal").get();
      return snap.docs.map((d) => PengeluaranModel.fromFirestore(d.id, d.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print("ERROR getAll pengeluaran: $e");
      return [];
    }
  }

  // GET by ID
  Future<PengeluaranModel?> getById(String id) async {
    try {
      final doc = await _ref.doc(id).get();
      if (!doc.exists) return null;
      return PengeluaranModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
    } catch (e) {
      print("ERROR getById pengeluaran: $e");
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
      print("ERROR add pengeluaran: $e");
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
      print("ERROR update pengeluaran: $e");
      return false;
    }
  }

  // DELETE
  Future<bool> delete(String id) async {
    try {
      await _ref.doc(id).delete();
      return true;
    } catch (e) {
      print("ERROR delete pengeluaran: $e");
      return false;
    }
  }
}
