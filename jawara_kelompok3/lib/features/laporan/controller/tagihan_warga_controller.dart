import '../data/models/tagihan_warga_model.dart';
import '../data/services/tagihan_warga_service.dart';
import '../data/services/pemasukan_lain_service.dart';

class TagihanController {
  final TagihanWargaService _service = TagihanWargaService();
  final PemasukanLainService _pemasukanService = PemasukanLainService();

  // =============================================================
  // 🔵 READ (WARGA)
  // =============================================================
  Future<List<TagihanWargaModel>> fetchByKepalaKeluargaId(String id) async {
    try {
      return await _service.getByKepalaKeluargaId(id);
    } catch (e) {
      // ignore: avoid_print
      print('ERROR fetchByKepalaKeluargaId: $e');
      return [];
    }
  }

  // =============================================================
  // 🟡 UPDATE
  // =============================================================
  Future<bool> updateTagihan(String id, Map<String, dynamic> data) async {
    try {
      final before = await _service.getById(id);
      final beforeStatus = (before?.tagihanStatus ?? '').toString().trim();

      final result = await _service.update(id, data);

      final newStatus = (data['tagihanStatus'] ?? '').toString().trim();
      final statusJadiSudahDibayar = newStatus.toLowerCase() == 'sudah dibayar';
      final sebelumnyaSudahDibayar = beforeStatus.toLowerCase() == 'sudah dibayar';

      if (result && statusJadiSudahDibayar && !sebelumnyaSudahDibayar) {
        final tagihan = await _service.getById(id);
        if (tagihan != null) {
          await _pemasukanService.add({
            'nama': tagihan.keluarga,
            'jenis': 'Tagihan Dibayar',
            'tanggal': DateTime.now().toString(),
            'nominal': tagihan.nominal,
          });
        }
      }

      return result;
    } catch (e) {
      // ignore: avoid_print
      print('Error updating Tagihan: $e');
      return false;
    }
  }

  // =============================================================
  // 🔴 DELETE
  // =============================================================
  Future<bool> deleteTagihan(String id) => _service.delete(id);
}
