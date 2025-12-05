import '../data/models/tagihan_model.dart';
import '../data/services/tagihan_service.dart';

class TagihanController {
  final TagihanService _service = TagihanService();

  // =============================================================
  // 🔵 READ
  // =============================================================
  Future<List<TagihanModel>> fetchAll() => _service.getAll();

  Future<TagihanModel?> fetchById(String id) => _service.getById(id);

  // =============================================================
  // 🟢 CREATE
  // =============================================================
  Future<bool> add(Map<String, dynamic> data) => _service.add(data);

  // =============================================================
  // 🟡 UPDATE
  // =============================================================
  Future<bool> update(String id, Map<String, dynamic> data) => _service.update(id, data);

  // =============================================================
  // 🔴 DELETE
  // =============================================================
  Future<bool> delete(String id) => _service.delete(id);
}
