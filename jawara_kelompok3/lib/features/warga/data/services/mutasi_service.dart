import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mutasi_model.dart';

class MutasiService {
  final CollectionReference col =
      FirebaseFirestore.instance.collection('mutasi');

  Future<List<MutasiModel>> getAllMutasi() async {
    final snapshot = await col.orderBy('tanggal', descending: true).get();

    return snapshot.docs
        .map((e) =>
            MutasiModel.fromFirestore(e.id, e.data() as Map<String, dynamic>))
        .toList();
  }

  Future<bool> addMutasi(MutasiModel data) async {
    try {
      await col.add(data.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateMutasi(String id, Map<String, dynamic> newData) async {
    try {
      await col.doc(id).update(newData);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteMutasi(String id) async {
    try {
      await col.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
