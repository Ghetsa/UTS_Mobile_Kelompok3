import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tagihan_model.dart';

class TagihanService {
  final CollectionReference _ref = FirebaseFirestore.instance.collection('tagihan');

  Future<List<TagihanModel>> getAll() async {
    try {
      final snap = await _ref.orderBy('created_at', descending: true).get();
      return snap.docs
          .map((d) => TagihanModel.fromFirestore(d.id, d.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('ERROR getAll Tagihan: $e');
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
      print('ERROR add Tagihan: $e');
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
      print('ERROR update Tagihan: $e');
      return false;
    }
  }

  Future<bool> delete(String id) async {
    try {
      await _ref.doc(id).delete();
      return true;
    } catch (e) {
      print('ERROR delete Tagihan: $e');
      return false;
    }
  }

  Future<TagihanModel?> getById(String id) async {
    try {
      final doc = await _ref.doc(id).get();
      if (!doc.exists) return null;
      return TagihanModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('ERROR getById Tagihan: $e');
      return null;
    }
  }
}
