import '../data/models/pemasukan_model.dart';
import '../data/services/pemasukan_service.dart';

class PemasukanController {
  final PemasukanService _service = PemasukanService();

  // GET all data
  Future<List<PemasukanModel>> fetchAll() => _service.getAll();

  // GET by ID
  Future<PemasukanModel?> fetchById(String id) => _service.getById(id);

  // CREATE
  Future<bool> add(Map<String, dynamic> data) => _service.add(data);

  // UPDATE
  Future<bool> update(String id, Map<String, dynamic> data) => _service.update(id, data);

  // DELETE
  Future<bool> delete(String id) => _service.delete(id);
}
