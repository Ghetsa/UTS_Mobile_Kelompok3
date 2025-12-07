import '../data/models/semua_pengeluaran_model.dart';
import '../data/services/semua_pengeluaran_service.dart';

class PengeluaranController {
  final PengeluaranService _service = PengeluaranService();

  // GET all data
  Future<List<PengeluaranModel>> fetchAll() => _service.getAll();

  // GET by ID
  Future<PengeluaranModel?> fetchById(String id) => _service.getById(id);

  // CREATE
  Future<bool> add(Map<String, dynamic> data) => _service.add(data);

  // UPDATE
  Future<bool> update(String id, Map<String, dynamic> data) => _service.update(id, data);

  // DELETE
  Future<bool> delete(String id) => _service.delete(id);
}
