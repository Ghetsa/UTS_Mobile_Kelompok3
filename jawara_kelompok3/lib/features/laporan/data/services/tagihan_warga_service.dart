import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tagihan_model.dart';

class TagihanWargaService {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection('tagihan');

  // Get all tagihan by kepala keluarga id
  Future<List<TagihanModel>> getByKepalaKeluargaId(String id) async {
    try {
      final snap = await _ref.where('id_kepala_warga', isEqualTo: id).get();
      return snap.docs
          .map((d) => TagihanModel.fromFirestore(d.id, d.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('ERROR getByKepalaKeluargaId: $e');
      return [];
    }
  }

  // Get a specific tagihan by its ID
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

  // Update tagihan based on its ID
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

  // Delete a tagihan based on its ID
  Future<bool> delete(String id) async {
    try {
      await _ref.doc(id).delete();
      return true;
    } catch (e) {
      print('ERROR delete Tagihan: $e');
      return false;
    }
  }
}