import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pengeluaran_lain_model.dart';

class PengeluaranLainService {
  final CollectionReference col =
      FirebaseFirestore.instance.collection('pengeluaran');

  // CREATE
  Future<void> addPengeluaran(Map<String, dynamic> data) async {
    await col.add(data);
  }

  // READ (Stream)
  Stream<List<PengeluaranLainModel>> streamPengeluaran() {
    return col.orderBy('tanggal', descending: true).snapshots().map((snap) {
      try {
        return snap.docs.map((doc) {
          try {
            return PengeluaranLainModel.fromJson(
                doc.id, doc.data() as Map<String, dynamic>);
          } catch (e) {
            print('Error parsing document ${doc.id}: $e');
            rethrow;
          }
        }).toList();
      } catch (e) {
        print('Error in streamPengeluaran: $e');
        return [];
      }
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
