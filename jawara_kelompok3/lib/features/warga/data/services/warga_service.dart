import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/warga_model.dart';

class WargaService {
  final CollectionReference<Map<String, dynamic>> _col =
      FirebaseFirestore.instance.collection('warga');

  Future<List<WargaModel>> getAllWarga() async {
    try {
      final snapshot = await _col.orderBy('created_at', descending: true).get();

      return snapshot.docs
          .map((doc) => WargaModel.fromFirestore(doc.id, doc.data()))
          .toList();
    } catch (e, st) {
      print('ERROR GET ALL WARGA: $e');
      print(st);
      return [];
    }
  }

  Future<bool> addWarga(WargaModel warga) async {
    try {
      final map = warga.toMap();
      map['created_at'] = FieldValue.serverTimestamp();
      map['updated_at'] = FieldValue.serverTimestamp();

      await _col.add(map);
      return true;
    } catch (e) {
      print("ERROR ADD WARGA: $e");
      return false;
    }
  }

  Future<bool> updateWarga(String docId, Map<String, dynamic> newData) async {
    try {
      await _col.doc(docId).update(newData);
      return true;
    } catch (e, st) {
      print('ERROR UPDATE WARGA: $e');
      print(st);
      return false;
    }
  }

  Future<bool> deleteWarga(String docId) async {
    try {
      await _col.doc(docId).delete();
      return true;
    } catch (e, st) {
      print('ERROR DELETE WARGA: $e');
      print(st);
      return false;
    }
  }

  Future<WargaModel?> getDetail(String docId) async {
    try {
      final doc = await _col.doc(docId).get();
      if (!doc.exists) return null;
      return WargaModel.fromFirestore(doc.id, doc.data()!);
    } catch (e, st) {
      print('ERROR GET DETAIL WARGA: $e');
      print(st);
      return null;
    }
  }
}
