import '../data/models/rumah_model.dart';
import '../data/services/rumah_service.dart';

class RumahController {
  final RumahService _service = RumahService();

  Future<List<RumahModel>> fetchAll() => _service.getAllRumah();

  Future<RumahModel?> fetchById(String id) => _service.getById(id);

  Future<bool> add(RumahModel rumah) => _service.addRumah(rumah);

  Future<bool> update(String id, Map<String, dynamic> data) =>
      _service.updateRumah(id, data);

  Future<bool> delete(String id) => _service.deleteRumah(id);
}
