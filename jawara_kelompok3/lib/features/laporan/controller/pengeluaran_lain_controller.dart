import 'package:flutter/foundation.dart';
import '../data/models/pengeluaran_lain_model.dart';
import '../data/services/pengeluaran_lain_service.dart';

class PengeluaranLainController extends ChangeNotifier {
  final PengeluaranLainService _service = PengeluaranLainService();

  /// Ambil semua data pengeluaran lain
  Future<List<PengeluaranLainModel>> fetchAll() => _service.getAll();

  /// Ambil satu pengeluaran berdasarkan docId di Firestore
  Future<PengeluaranLainModel?> fetchByDocId(String docId) =>
      _service.getByDocId(docId);

  /// Alias kalau masih ada kode lama yang pakai fetchById
  Future<PengeluaranLainModel?> fetchById(String docId) => fetchByDocId(docId);

  /// Tambah pengeluaran (PengeluaranLainModel sudah mengatur docId di dalamnya)
  Future<bool> add(PengeluaranLainModel pengeluaran) async {
    final result = await _service.add(pengeluaran);
    notifyListeners();
    return result;
  }

  /// Update pengeluaran berdasarkan docId
  Future<bool> update(String docId, Map<String, dynamic> data) async {
    final result = await _service.update(docId, data);
    notifyListeners();
    return result;
  }

  /// Hapus pengeluaran berdasarkan docId
  Future<bool> delete(String docId) async {
    final result = await _service.delete(docId);
    notifyListeners();
    return result;
  }
}
