import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pemasukan_lain_model.dart';

class PemasukanLainService {
  final CollectionReference _ref = FirebaseFirestore.instance.collection('pemasukan_lain');

  Future<List<PemasukanLainModel>> getAll() async {
    try {
      final snap = await _ref.orderBy('created_at', descending: true).get();
      return snap.docs
          .map((d) => PemasukanLainModel.fromFirestore(d.id, d.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('ERROR getAll PemasukanLain: $e');
      return [];
    }
  }

  Future<bool> add(Map<String, dynamic> data) async {
    try {
      await _ref.add({
        ...data,
        'created_at': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('ERROR add PemasukanLain: $e');
      return false;
    }
  }

  Future<bool> update(String id, Map<String, dynamic> data) async {
    try {
      await _ref.doc(id).update({
        ...data,
        'updated_at': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('ERROR update PemasukanLain: $e');
      return false;
    }
  }

  Future<bool> delete(String id) async {
    try {
      await _ref.doc(id).delete();
      return true;
    } catch (e) {
      print('ERROR delete PemasukanLain: $e');
      return false;
    }
  }

  Future<PemasukanLainModel?> getById(String id) async {
    try {
      final doc = await _ref.doc(id).get();
      if (!doc.exists) return null;
      return PemasukanLainModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('ERROR getById PemasukanLain: $e');
      return null;
    }
  }
}