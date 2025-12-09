import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pengeluaran_lain_model.dart';

class PengeluaranLainService {
  final CollectionReference col =
      FirebaseFirestore.instance.collection('pengeluaran_lain');

  // CREATE
  Future<void> addPengeluaran(Map<String, dynamic> data) async {
    await col.add(data);
  }

  // READ (Stream)
  Stream<List<PengeluaranLainModel>> streamPengeluaran() {
    return col.orderBy('tanggal', descending: true).snapshots().map((snap) {
      return snap.docs.map((doc) {
        return PengeluaranLainModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // UPDATE
  Future<void> updatePengeluaran(String id, Map<String, dynamic> data) async {
    await col.doc(id).update(data);
  }

  // DELETE
  Future<void> deletePengeluaran(String id) async {
    await col.doc(id).delete();
  }
}
