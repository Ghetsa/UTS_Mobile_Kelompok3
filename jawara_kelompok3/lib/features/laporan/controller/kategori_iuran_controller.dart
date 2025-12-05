import '../data/models/kategori_iuran_model.dart';
import '../data/services/kategori_iuran_service.dart';

class KategoriIuranController {
  final KategoriIuranService _service = KategoriIuranService();

  // =============================================================
  // 🔵 READ
  // =============================================================
  Future<List<KategoriIuranModel>> fetchAll() => _service.getAll();

  Future<KategoriIuranModel?> fetchById(String id) => _service.getById(id);

  // =============================================================
  // 🟢 CREATE
  // =============================================================
  /// Tambah dari Map (langsung diteruskan ke service)
  Future<bool> addFromMap(Map<String, dynamic> data) {
    // Menambahkan validasi dan memastikan data valid sebelum diproses
    if (data['nama'] == null || data['nominal'] == null) {
      return Future.value(false);
    }
    return _service.add(data);
  }

  Future<bool> addFromModel(KategoriIuranModel model) {
    final map = model.toMap();
    map.remove('created_at');
    return _service.add(map);
  }

  // =============================================================
  // 🟡 UPDATE
  // =============================================================
  /// Update pakai id + map
  Future<bool> update(String id, Map<String, dynamic> data) {
    if (data['nama'] == null || data['nominal'] == null) {
      return Future.value(false);
    }
    return _service.update(id, data);
  }

  Future<bool> updateFromModel(KategoriIuranModel model) async {
    final map = model.toMap();
    map.remove('created_at');
    return await _service.update(model.id, map);
  }

  // =============================================================
  // 🔴 DELETE
  // =============================================================
  Future<bool> delete(String id) => _service.delete(id);
}
