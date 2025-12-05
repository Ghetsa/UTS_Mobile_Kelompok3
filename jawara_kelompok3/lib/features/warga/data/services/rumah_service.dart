import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/rumah_model.dart';

class RumahService {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection("rumah");

  // ============================================================
  // 🔵 GET SEMUA RUMAH
  // ============================================================
  Future<List<RumahModel>> getAllRumah() async {
    try {
      // bisa juga orderBy('nomor') kalau mau urut nomor rumah
      final snapshot = await _ref.orderBy('alamat').get();

      return snapshot.docs
          .map(
            (doc) => RumahModel.fromFirestore(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (e) {
      print("❌ ERROR GET ALL RUMAH: $e");
      return [];
    }
  }

  // ============================================================
  // 🟣 GET SATU RUMAH BERDASARKAN DOC ID
  // ============================================================
  Future<RumahModel?> getByDocId(String docId) async {
    try {
      final doc = await _ref.doc(docId).get();

      if (!doc.exists) return null;

      return RumahModel.fromFirestore(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
    } catch (e) {
      print("❌ ERROR GET RUMAH BY DOC ID: $e");
      return null;
    }
  }

  // ============================================================
  // 🟢 TAMBAH RUMAH
  // ============================================================
  Future<bool> addRumah(RumahModel rumah) async {
    try {
      // Di model terbaru, 'id' kita anggap sebagai docId
      if (rumah.id.isEmpty) {
        // docId otomatis dari Firestore
        await _ref.add(rumah.toMap());
      } else {
        // pakai id yang kamu set sendiri
        await _ref.doc(rumah.id).set(rumah.toMap());
      }
      return true;
    } catch (e) {
      print("❌ ERROR ADD RUMAH: $e");
      return false;
    }
  }

  // ============================================================
  // 🟡 UPDATE RUMAH
  // ============================================================
  Future<bool> updateRumah(String docId, Map<String, dynamic> data) async {
    try {
      await _ref.doc(docId).update({
        ...data,
        "updated_at": FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print("❌ ERROR UPDATE RUMAH: $e");
      return false;
    }
  }

  // ============================================================
  // 🔴 DELETE RUMAH
  // ============================================================
  Future<bool> deleteRumah(String docId) async {
    try {
      await _ref.doc(docId).delete();
      return true;
    } catch (e) {
      print("❌ ERROR DELETE RUMAH: $e");
      return false;
    }
  }

  // ============================================================
  // 🟦 GET NAMA KEPALA KELUARGA DARI KOLEKSI /keluarga
  // ============================================================
  Future<String?> getNamaKepalaKeluarga(String keluargaId) async {
    try {
      final ref = FirebaseFirestore.instance.collection("keluarga");
      final doc = await ref.doc(keluargaId).get();

      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;

      // Di struktur kamu: nama kepala keluarga disimpan di "kepala_keluarga"
      if (data.containsKey("kepala_keluarga")) {
        return data["kepala_keluarga"] as String?;
      }

      // fallback kalau suatu saat pakai nama lain
      if (data.containsKey("nama_kepala_keluarga")) {
        return data["nama_kepala_keluarga"] as String?;
      }

      if (data.containsKey("nama")) {
        return data["nama"] as String?;
      }

      return null;
    } catch (e) {
      print("❌ ERROR GET NAMA KEPALA KELUARGA: $e");
      return null;
    }
  }

   Future<String?> getAlamatRumahByDocId(String docId) async {
    try {
      final doc = await _ref.doc(docId).get();
      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;
      return data['alamat'] as String? ?? '';
    } catch (e) {
      print('ERROR GET ALAMAT RUMAH BY DOC ID: $e');
      return null;
    }
  }
}
