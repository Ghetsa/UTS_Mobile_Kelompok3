import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pemasukan_model.dart';

class PemasukanService {
  final CollectionReference _ref = FirebaseFirestore.instance.collection('pemasukan');

  Future<List<PemasukanModel>> getAll() async {
    try {
      final snap = await _ref.orderBy('created_at', descending: true).get();
      return snap.docs
          .map((d) => PemasukanModel.fromFirestore(d.id, d.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('ERROR getAll Pemasukan: $e');
      return [];
    }
  }

  Future<PemasukanModel?> getById(String id) async {
    try {
      final doc = await _ref.doc(id).get();
      if (!doc.exists) return null;
      return PemasukanModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('ERROR getById Pemasukan: $e');
      return null;
    }
  }

  Future<bool> add(Map<String, dynamic> data) async {
    try {
      await _ref.add({
        ...data,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('ERROR add Pemasukan: $e');
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
      print('ERROR update Pemasukan: $e');
      return false;
    }
  }

  Future<bool> delete(String id) async {
    try {
      await _ref.doc(id).delete();
      return true;
    } catch (e) {
      print('ERROR delete Pemasukan: $e');
      return false;
    }
  }
}
