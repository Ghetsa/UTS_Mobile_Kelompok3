import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/kegiatan_model.dart';

class KegiatanService {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection('kegiatan');

  // 🔵 Ambil semua kegiatan
  Future<List<KegiatanModel>> getAllKegiatan() async {
    try {
      final snapshot =
          await _ref.orderBy('tanggal_mulai', descending: true).get();

      return snapshot.docs
          .map((doc) =>
              KegiatanModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('ERROR GET ALL KEGIATAN: $e');
      return [];
    }
  }

  // 🟢 Tambah kegiatan
  Future<bool> addKegiatan(KegiatanModel keg) async {
    try {
      final map = keg.toMap();
      map['created_at'] = FieldValue.serverTimestamp();
      map['updated_at'] = FieldValue.serverTimestamp();

      await _ref.add(map);
      return true;
    } catch (e) {
      print('ERROR ADD KEGIATAN: $e');
      return false;
    }
  }

  // 🟡 Update kegiatan
  Future<bool> updateKegiatan(String docId, Map<String, dynamic> data) async {
    try {
      await _ref.doc(docId).update({
        ...data,
        'updated_at': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('ERROR UPDATE KEGIATAN: $e');
      return false;
    }
  }

  // 🔴 Hapus kegiatan
  Future<bool> deleteKegiatan(String docId) async {
    try {
      await _ref.doc(docId).delete();
      return true;
    } catch (e) {
      print('ERROR DELETE KEGIATAN: $e');
      return false;
    }
  }

  // 🟣 Detail satu kegiatan
  Future<KegiatanModel?> getDetail(String docId) async {
    try {
      final doc = await _ref.doc(docId).get();
      if (!doc.exists) return null;

      return KegiatanModel.fromFirestore(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
    } catch (e) {
      print('ERROR GET DETAIL KEGIATAN: $e');
      return null;
    }
  }
}
