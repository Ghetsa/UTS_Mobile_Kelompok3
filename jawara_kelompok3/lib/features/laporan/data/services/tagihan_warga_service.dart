import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/tagihan_warga_model.dart';

class TagihanWargaService {
  final CollectionReference _tagihanRef = FirebaseFirestore.instance.collection('tagihan');
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<TagihanWargaModel>> getTagihanWarga(String keluargaId) async {
    try {
      final querySnapshot = await _tagihanRef
          .where('keluarga', isEqualTo: keluargaId)
          .orderBy('created_at', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => TagihanWargaModel.fromFirestore(
              doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching tagihan: $e');
      return [];
    }
  }

    Future<bool> bayarTagihan(
    String tagihanId,
    String nominal,
    String catatan,
  ) async {
    try {
      await _tagihanRef.doc(tagihanId).update({
        'tagihanStatus': 'Sudah Dibayar',
        'nominalDibayar': nominal,
        'catatanPembayaran': catatan,
        'tanggalBayar': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Error updating tagihan status: $e');
      return false;
    }
  }
}