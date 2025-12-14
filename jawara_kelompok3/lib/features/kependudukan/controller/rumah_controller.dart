import '../data/models/rumah_model.dart';
import '../data/services/rumah_service.dart';

class RumahController {
  final RumahService _service = RumahService();

  /// Ambil semua data rumah
  Future<List<RumahModel>> fetchAll() => _service.getAllRumah();

  /// Ambil satu rumah berdasarkan docId di Firestore
  Future<RumahModel?> fetchByDocId(String docId) =>
      _service.getByDocId(docId);

  /// Alias kalau masih ada kode lama yang pakai fetchById
  Future<RumahModel?> fetchById(String docId) => fetchByDocId(docId);

  /// Tambah rumah (RumahModel sudah mengatur docId di dalamnya)
  Future<bool> add(RumahModel rumah) => _service.addRumah(rumah);

  /// Update rumah berdasarkan docId
  Future<bool> update(String docId, Map<String, dynamic> data) =>
      _service.updateRumah(docId, data);

  /// Hapus rumah berdasarkan docId
  Future<bool> delete(String docId) => _service.deleteRumah(docId);

  /// Ambil nama kepala keluarga dari koleksi `keluarga`
  Future<String?> getNamaKepalaKeluarga(String keluargaId) =>
      _service.getNamaKepalaKeluarga(keluargaId);
}
