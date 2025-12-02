// lib/features/warga/controller/keluarga_controller.dart
import '../data/models/keluarga_model.dart';
import '../data/services/keluarga_service.dart';

class KeluargaController {
  final KeluargaService _service = KeluargaService();

  // =============================================================
  // 🔵 READ
  // =============================================================

  /// Ambil semua data keluarga (urut kepala_keluarga)
  Future<List<KeluargaModel>> fetchAll() => _service.getDataKeluarga();

  /// Ambil 1 keluarga berdasarkan docId (uid)
  Future<KeluargaModel?> fetchByDocId(String docId) =>
      _service.getByDocId(docId);

  /// Alias kalau kamu mau pakai nama lain
  Future<KeluargaModel?> fetchDetail(String docId) =>
      _service.getDetail(docId);

  // =============================================================
  // 🟢 CREATE
  // =============================================================

  /// Tambah keluarga langsung dari Map (kalau kamu sudah punya map sendiri)
  Future<bool> addFromMap(Map<String, dynamic> data) =>
      _service.addKeluarga(data);

  /// Tambah keluarga dari Model
  ///
  /// `created_at` akan diisi serverTimestamp oleh service,
  /// jadi di sini kita buang field `created_at` dari toMap()
  Future<bool> addFromModel(KeluargaModel model) {
    final map = model.toMap();
    map.remove('created_at');
    return _service.addKeluarga(map);
  }

  // =============================================================
  // 🟡 UPDATE
  // =============================================================

  /// Update keluarga pakai docId + Map data
  Future<bool> update(String docId, Map<String, dynamic> data) =>
      _service.updateKeluarga(docId, data);

  /// Update keluarga langsung dari model (pakai uid sebagai docId)
  Future<bool> updateFromModel(KeluargaModel model) {
    final map = model.toMap();

    // created_at jangan diutak–atik waktu update
    map.remove('created_at');
    return _service.updateKeluarga(model.uid, map);
  }

  // =============================================================
  // 🔴 DELETE
  // =============================================================

  /// Hapus satu keluarga berdasarkan docId (uid)
  Future<bool> delete(String docId) => _service.deleteKeluarga(docId);
}
