import '../data/models/warga_model.dart';
import '../data/services/warga_service.dart';

class WargaController {
  final WargaService _service = WargaService();

  Future<bool> addWarga(WargaModel warga) async {
    return await _service.addWarga(warga);
  }

  Future<bool> updateWarga(String docId, Map<String, dynamic> data) async {
    return await _service.updateWarga(docId, data);
  }

  Future<List<WargaModel>> getAllWarga() async {
    return await _service.getAllWarga();
  }
}
