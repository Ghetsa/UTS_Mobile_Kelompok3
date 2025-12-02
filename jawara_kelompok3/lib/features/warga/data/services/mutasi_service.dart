import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mutasi_model.dart';

class MutasiService {
  // Pakai generic biar e.data() langsung Map<String, dynamic>
  final CollectionReference<Map<String, dynamic>> col =
      FirebaseFirestore.instance.collection('mutasi');

  Future<List<MutasiModel>> getAllMutasi() async {
    try {
      final snapshot = await col.orderBy('tanggal', descending: true).get();

      return snapshot.docs
          .map(
            (e) => MutasiModel.fromFirestore(
              e.id,
              e.data(),
            ),
          )
          .toList();
    } catch (e, st) {
      print('ERROR GET ALL MUTASI: $e');
      print(st);
      return [];
    }
  }

  Future<bool> addMutasi(MutasiModel data) async {
    try {
      await col.add(data.toMap());
      return true;
    } catch (e) {
      print('ERROR ADD MUTASI: $e');
      return false;
    }
  }

  Future<bool> updateMutasi(String id, Map<String, dynamic> newData) async {
    try {
      await col.doc(id).update(newData);
      return true;
    } catch (e) {
      print('ERROR UPDATE MUTASI: $e');
      return false;
    }
  }

  Future<bool> deleteMutasi(String id) async {
    try {
      await col.doc(id).delete();
      return true;
    } catch (e) {
      print('ERROR DELETE MUTASI: $e');
      return false;
    }
  }
}
