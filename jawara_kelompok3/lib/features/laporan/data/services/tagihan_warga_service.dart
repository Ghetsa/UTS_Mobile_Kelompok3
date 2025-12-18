import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tagihan_warga_model.dart';

class TagihanWargaService {
  final CollectionReference<Map<String, dynamic>> _ref =
      FirebaseFirestore.instance.collection('tagihan');

  Future<List<TagihanWargaModel>> getByKepalaKeluargaId(String idKepalaWarga) async {
    try {
      final snap = await _ref
          .where('id_kepala_warga', isEqualTo: idKepalaWarga)
          .get();

      final list = snap.docs
          .map((d) => TagihanWargaModel.fromFirestore(d.id, d.data()))
          .toList();

      // ✅ sorting client-side biar ga butuh index
      list.sort((a, b) {
        final ta = a.createdAt?.millisecondsSinceEpoch ?? 0;
        final tb = b.createdAt?.millisecondsSinceEpoch ?? 0;
        return tb.compareTo(ta);
      });

      return list;
    } catch (e) {
      // ignore: avoid_print
      print('ERROR getByKepalaKeluargaId: $e');
      return [];
    }
  }

  Future<TagihanWargaModel?> getById(String id) async {
    try {
      final doc = await _ref.doc(id).get();
      if (!doc.exists) return null;
      return TagihanWargaModel.fromFirestore(doc.id, doc.data() ?? {});
    } catch (e) {
      // ignore: avoid_print
      print('ERROR getById Tagihan: $e');
      return null;
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
      // ignore: avoid_print
      print('ERROR update Tagihan: $e');
      return false;
    }
  }

  Future<bool> delete(String id) async {
    try {
      await _ref.doc(id).delete();
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('ERROR delete Tagihan: $e');
      return false;
    }
  }
}
