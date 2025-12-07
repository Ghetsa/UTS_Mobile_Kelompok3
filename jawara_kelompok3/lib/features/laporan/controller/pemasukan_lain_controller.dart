import '../data/models/pemasukan_lain_model.dart';
import '../data/services/pemasukan_lain_service.dart';

class PemasukanLainController {
  final PemasukanLainService _service = PemasukanLainService();

  Future<List<PemasukanLainModel>> fetchAll() => _service.getAll();
  Future<PemasukanLainModel?> fetchById(String id) => _service.getById(id);
  Future<bool> add(Map<String, dynamic> data) => _service.add(data);
  Future<bool> update(String id, Map<String, dynamic> data) =>
      _service.update(id, data);
  Future<bool> delete(String id) => _service.delete(id);
}
