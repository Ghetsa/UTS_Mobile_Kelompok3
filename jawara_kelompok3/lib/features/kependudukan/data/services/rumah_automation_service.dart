import 'package:cloud_firestore/cloud_firestore.dart';

import 'rumah_service.dart';
import 'keluarga_service.dart';

class RumahAutomationService {
  final RumahService _rumahService;
  final KeluargaService _keluargaService;

  RumahAutomationService({
    RumahService? rumahService,
    KeluargaService? keluargaService,
  })  : _rumahService = rumahService ?? RumahService(),
        _keluargaService = keluargaService ?? KeluargaService();

  /// Status keluarga yang dianggap "menempati rumah"
  /// Kamu bisa ubah aturan ini kalau mau.
  static const Set<String> occupyingStatuses = {
    "aktif",
    "sementara",
  };

  // ============================================================
  // ✅ Ketika rumah ditempati
  // - status_rumah => "Dihuni"
  // - kepemilikan => kalau kosong/kosong -> "Pemilik" (sesuai request kamu)
  // ============================================================
  Future<void> markRumahDihuni(String rumahDocId) async {
    final rumah = await _rumahService.getByDocId(rumahDocId);
    if (rumah == null) return;

    final kep = rumah.kepemilikan.trim().toLowerCase();
    final Map<String, dynamic> update = {
      "status_rumah": "Dihuni",
    };

    if (kep.isEmpty || kep == "kosong") {
      update["kepemilikan"] = "Pemilik";
    }

    await _rumahService.updateRumah(rumahDocId, update);
  }

  // ============================================================
  // ✅ Ketika rumah dikosongkan
  // - status_rumah => "Kosong"
  // - kepemilikan => "Kosong"
  // ============================================================
  Future<void> forceRumahKosong(String rumahDocId) async {
    await _rumahService.updateRumah(rumahDocId, {
      "status_rumah": "Kosong",
      "kepemilikan": "Kosong",
    });
  }

  // ============================================================
  // ✅ Kosongkan rumah hanya jika tidak ada keluarga "menempati"
  // (misal setelah keluarga pindah keluar / pindah rumah)
  // ============================================================
  Future<void> markRumahKosongIfNoOccupant(String rumahDocId) async {
    final count =
        await _keluargaService.countOccupyingFamiliesByRumah(rumahDocId);

    if (count <= 0) {
      await forceRumahKosong(rumahDocId);
    }
  }

  // ============================================================
  // ✅ Sync otomatis setelah perubahan keluarga
  //
  // oldRumahId: rumah sebelum update (boleh kosong)
  // newRumahId: rumah sesudah update (boleh kosong)
  // newStatusKeluarga: status keluarga sesudah update
  //
  // Rules:
  // - Kalau keluarga pindah rumah: rumah lama dicek -> kosong jika tidak ada penghuni
  // - Kalau status keluarga menjadi "pindah" (atau non-occupying): rumahnya dicek -> kosong jika tidak ada penghuni
  // - Kalau status keluarga menjadi occupying (aktif/sementara): rumah baru => Dihuni
  // ============================================================
  Future<void> syncAfterKeluargaChanged({
    required String? oldRumahId,
    required String? newRumahId,
    required String newStatusKeluarga,
  }) async {
    final String status = newStatusKeluarga.toLowerCase().trim();

    final bool newOccupies = occupyingStatuses.contains(status);

    // 1) Kalau rumah berubah (pindah rumah)
    if (oldRumahId != null &&
        oldRumahId.isNotEmpty &&
        newRumahId != null &&
        newRumahId.isNotEmpty &&
        oldRumahId != newRumahId) {
      // rumah lama mungkin jadi kosong
      await markRumahKosongIfNoOccupant(oldRumahId);

      // rumah baru ditempati kalau statusnya occupying
      if (newOccupies) {
        await markRumahDihuni(newRumahId);
      }
      return;
    }

    // 2) Kalau rumah tidak berubah (status berubah saja)
    if (newRumahId != null && newRumahId.isNotEmpty) {
      if (newOccupies) {
        await markRumahDihuni(newRumahId);
      } else {
        await markRumahKosongIfNoOccupant(newRumahId);
      }
    }
  }
}
