import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/warga_model.dart';

class WargaController {
  final CollectionReference wargaCol =
      FirebaseFirestore.instance.collection('warga');

  // GET semua warga
  Stream<List<WargaModel>> getWarga() {
    return wargaCol.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return WargaModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // GET by UID
  Future<WargaModel?> getWargaByUid(String uid) async {
    final result = await wargaCol.doc(uid).get();
    if (result.exists) {
      return WargaModel.fromMap(result.data() as Map<String, dynamic>);
    }
    return null;
  }

  // CREATE warga
  Future<void> addWarga(WargaModel warga) async {
    await wargaCol.doc(warga.uid).set(warga.toMap());
  }

  // UPDATE warga
  Future<void> updateWarga(String uid, Map<String, dynamic> data) async {
    await wargaCol.doc(uid).update(data);
  }

  // DELETE warga
  Future<void> deleteWarga(String uid) async {
    await wargaCol.doc(uid).delete();
  }
}
