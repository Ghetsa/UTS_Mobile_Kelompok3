import '../data/services/pengeluaran_lain_service.dart';
import '../data/models/pengeluaran_lain_model.dart';

class PengeluaranLainController {
  final PengeluaranLainService service = PengeluaranLainService();

  Stream<List<PengeluaranLainModel>> get streamPengeluaran {
    return service.streamPengeluaran();
  }

  Future<void> addPengeluaran(Map<String, dynamic> data) async {
    await service.addPengeluaran(data);
  }

  Future<void> updatePengeluaran(String id, Map<String, dynamic> data) async {
    await service.updatePengeluaran(id, data);
  }

  Future<void> deletePengeluaran(String id) async {
    await service.deletePengeluaran(id);
  }
}
