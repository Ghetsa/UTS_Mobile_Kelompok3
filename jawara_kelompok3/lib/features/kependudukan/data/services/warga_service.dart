import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/warga_model.dart';

class WargaService {
  final CollectionReference<Map<String, dynamic>> _col =
      FirebaseFirestore.instance.collection('warga');

  final CollectionReference<Map<String, dynamic>> _keluargaCol =
      FirebaseFirestore.instance.collection('keluarga');

  // ============================================================
  // 🔵 GET SEMUA WARGA
  // ============================================================
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

  // ============================================================
  // 🟢 TAMBAH WARGA (AUTO SET NO.KK JIKA ADA KELUARGA)
  // ============================================================
  Future<bool> addWarga(WargaModel warga) async {
    try {
      final map = warga.toMap();

      // Jika id_keluarga terisi → ambil nomor KK
      if (warga.idKeluarga.isNotEmpty) {
        final kk = await _getNoKK(warga.idKeluarga);
        map['no_kk'] = kk ?? "";
      }

      map['created_at'] = FieldValue.serverTimestamp();
      map['updated_at'] = FieldValue.serverTimestamp();

      await _col.add(map);
      return true;
    } catch (e) {
      print("ERROR ADD WARGA: $e");
      return false;
    }
  }

  // ============================================================
  // 🟡 UPDATE WARGA (AUTO UPDATE NO.KK)
  // ============================================================
  Future<bool> updateWarga(String docId, Map<String, dynamic> newData) async {
    try {
      String? newKK;

      // Jika id_keluarga diganti atau diisi
      if (newData.containsKey('id_keluarga')) {
        final String idKeluargaBaru = newData['id_keluarga'];

        if (idKeluargaBaru.isEmpty) {
          // Warga dilepas dari keluarga → kosongkan no_kk
          newKK = "";
        } else {
          // Ambil nomor KK dari keluarga baru
          newKK = await _getNoKK(idKeluargaBaru) ?? "";
        }

        newData['no_kk'] = newKK;
      }

      await _col.doc(docId).update({
        ...newData,
        'updated_at': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e, st) {
      print('ERROR UPDATE WARGA: $e');
      print(st);
      return false;
    }
  }

  // ============================================================
  // 🔴 HAPUS WARGA
  // ============================================================
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

  // ============================================================
  // 🟣 DETAIL SATU WARGA
  // ============================================================
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

  // ============================================================
  // 🟤 AMBIL SEMUA WARGA BERDASARKAN id_rumah
  // ============================================================
  Future<List<WargaModel>> getWargaByRumahId(String rumahDocId) async {
    try {
      final snap = await _col.where('id_rumah', isEqualTo: rumahDocId).get();

      return snap.docs
          .map((doc) => WargaModel.fromFirestore(doc.id, doc.data()))
          .toList();
    } catch (e, st) {
      print("ERROR GET WARGA BY RUMAH ID: $e");
      print(st);
      return [];
    }
  }

  // ============================================================
  // 🔶 AMBIL SEMUA WARGA BERDASARKAN id_keluarga
  // ============================================================
  Future<List<WargaModel>> getWargaByKeluargaId(String keluargaDocId) async {
    try {
      final snap =
          await _col.where('id_keluarga', isEqualTo: keluargaDocId).get();

      return snap.docs
          .map((doc) => WargaModel.fromFirestore(doc.id, doc.data()))
          .toList();
    } catch (e, st) {
      print("ERROR GET WARGA BY KELUARGA ID: $e");
      print(st);
      return [];
    }
  }

  // ============================================================
  // 🔷 HITUNG JUMLAH WARGA BERDASARKAN id_keluarga
  // ============================================================
  Future<int> countWargaByKeluarga(String keluargaDocId) async {
    try {
      final snap =
          await _col.where('id_keluarga', isEqualTo: keluargaDocId).get();
      return snap.size;
    } catch (e, st) {
      print("ERROR COUNT WARGA BY KELUARGA: $e");
      print(st);
      return 0;
    }
  }

  // ============================================================
  // 🟪 HELPER: AMBIL NO KK DARI KOLEKSI KELUARGA
  // ============================================================
  Future<String?> _getNoKK(String keluargaDocId) async {
    try {
      final doc = await _keluargaCol.doc(keluargaDocId).get();
      if (!doc.exists) return null;

      final data = doc.data()!;
      return data['no_kk'] ?? "";
    } catch (e) {
      print("ERROR GET NO KK: $e");
      return null;
    }
  }

  Future<bool> assignToKeluargaAtomic({
    required String wargaDocId,
    required String keluargaId,
    required String rumahId,
    String? noKk,
  }) async {
    try {
      final wargaRef = _col.doc(wargaDocId);

      await FirebaseFirestore.instance.runTransaction((tx) async {
        final snap = await tx.get(wargaRef);
        if (!snap.exists) {
          throw Exception("Warga tidak ditemukan");
        }

        final data = snap.data() as Map<String, dynamic>;
        final String currentKeluarga = (data['id_keluarga'] ?? '').toString();

        // ✅ KUNCI: kalau sudah punya keluarga -> STOP
        if (currentKeluarga.isNotEmpty && currentKeluarga != keluargaId) {
          throw Exception("Warga sudah menjadi anggota keluarga lain.");
        }

        tx.update(wargaRef, {
          'id_keluarga': keluargaId,
          'id_rumah': rumahId,
          if (noKk != null) 'no_kk': noKk,
          'updated_at': FieldValue.serverTimestamp(),
        });
      });

      return true;
    } catch (e) {
      // ignore: avoid_print
      print("assignToKeluargaAtomic ERROR: $e");
      return false;
    }
  }

  Future<bool> removeFromKeluargaAtomic({
    required String wargaDocId,
    required String keluargaId,
  }) async {
    try {
      final wargaRef = _col.doc(wargaDocId);

      await FirebaseFirestore.instance.runTransaction((tx) async {
        final snap = await tx.get(wargaRef);
        if (!snap.exists) throw Exception("Warga tidak ditemukan");

        final data = snap.data() as Map<String, dynamic>;
        final String currentKeluarga = (data['id_keluarga'] ?? '').toString();

        // cuma boleh lepas kalau dia memang anggota keluarga itu
        if (currentKeluarga != keluargaId) {
          throw Exception("Warga bukan anggota keluarga ini.");
        }

        tx.update(wargaRef, {
          'id_keluarga': '',
          'no_kk': '',
          'updated_at': FieldValue.serverTimestamp(),
        });
      });

      return true;
    } catch (e) {
      print("removeFromKeluargaAtomic ERROR: $e");
      return false;
    }
  }
}
