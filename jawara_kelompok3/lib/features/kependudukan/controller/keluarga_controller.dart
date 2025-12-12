import '../data/models/keluarga_model.dart';
import '../data/services/keluarga_service.dart';
import '../data/services/rumah_automation_service.dart';

class KeluargaController {
  final KeluargaService _service = KeluargaService();
  final RumahAutomationService _rumahAuto = RumahAutomationService();

  // =============================================================
  // 🔵 READ
  // =============================================================
  Future<List<KeluargaModel>> fetchAll() => _service.getDataKeluarga();

  Future<KeluargaModel?> fetchByDocId(String docId) =>
      _service.getByDocId(docId);

  Future<KeluargaModel?> fetchDetail(String docId) => _service.getDetail(docId);

  // =============================================================
  // 🟢 CREATE
  // =============================================================
  Future<bool> addFromMap(Map<String, dynamic> data) =>
      _service.addKeluarga(data);

  Future<bool> addFromModel(KeluargaModel model) {
    final map = model.toMap();
    map.remove('created_at');
    return _service.addKeluarga(map);
  }

  /// ✅ ADD + otomatis update rumah (Dihuni/Pemilik) kalau menempati
  Future<String?> addWithRumahAutomationReturnId(
      Map<String, dynamic> data) async {
    final keluargaId = await _service.addKeluargaReturnId(data);
    if (keluargaId == null) return null;

    final rumahId = (data["id_rumah"] ?? "").toString();
    final status = (data["status_keluarga"] ?? "aktif").toString();

    await _rumahAuto.syncAfterKeluargaChanged(
      oldRumahId: null,
      newRumahId: rumahId,
      newStatusKeluarga: status,
    );

    return keluargaId;
  }

  // =============================================================
  // 🟡 UPDATE
  // =============================================================
  Future<bool> update(String docId, Map<String, dynamic> data) =>
      _service.updateKeluarga(docId, data);

  Future<bool> updateFromModel(KeluargaModel model) {
    final map = model.toMap();
    map.remove('created_at');
    return _service.updateKeluarga(model.uid, map);
  }

  /// ✅ UPDATE keluarga + otomatis sync rumah lama & rumah baru
  ///
  /// Ini yang kamu panggil dari EditKeluargaPage
  /// Kasus yang ke-handle:
  /// - keluarga pindah rumah (id_rumah berubah)
  /// - keluarga pindah keluar (status_keluarga jadi "pindah")
  /// - keluarga jadi sementara/aktif lagi
  Future<bool> updateWithRumahAutomation(
      String docId, Map<String, dynamic> data) async {
    // 1) ambil data lama dulu (buat tahu rumah lama)
    final before = await _service.getByDocId(docId);
    final oldRumahId = before?.idRumah ?? "";

    // 2) eksekusi update keluarga
    final ok = await _service.updateKeluarga(docId, data);
    if (!ok) return false;

    // 3) tentukan rumah baru & status baru
    final newRumahId =
        (data.containsKey("id_rumah") ? data["id_rumah"] : before?.idRumah) ??
            "";
    final newStatus = (data.containsKey("status_keluarga")
            ? data["status_keluarga"]
            : before?.statusKeluarga) ??
        "aktif";

    // 4) sync otomatis rumah
    await _rumahAuto.syncAfterKeluargaChanged(
      oldRumahId: oldRumahId,
      newRumahId: newRumahId.toString(),
      newStatusKeluarga: newStatus.toString(),
    );

    return true;
  }

  // =============================================================
  // 🔴 DELETE
  // =============================================================
  Future<bool> delete(String docId) => _service.deleteKeluarga(docId);
}
