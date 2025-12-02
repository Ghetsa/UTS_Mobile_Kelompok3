import '../data/models/mutasi_model.dart';
import '../data/services/mutasi_service.dart';

/// Controller untuk mengelola data Mutasi Keluarga.
///
/// Tanggung jawab:
/// - Ambil semua mutasi dari Firestore (via MutasiService)
/// - Menyimpan state: allData, filteredData, searchQuery
/// - Menyediakan method untuk search & delete
class MutasiController {
  final MutasiService _service;

  /// Semua data hasil load dari Firestore
  List<MutasiModel> allData = [];

  /// Data setelah difilter (ini yang biasa dipakai di UI)
  List<MutasiModel> filteredData = [];

  /// Query pencarian (sekarang: by idWarga / nama yg di-mapping ke idWarga)
  String searchQuery = '';

  /// Flag loading, bisa kamu pakai untuk indikator loading di UI
  bool isLoading = false;

  /// Pesan error terakhir jika ada
  String? errorMessage;

  MutasiController({MutasiService? service})
      : _service = service ?? MutasiService();

  // ============================================================
  // 🔵 LOAD DATA DARI FIRESTORE
  // ============================================================
  Future<void> loadData() async {
    try {
      isLoading = true;
      errorMessage = null;

      final result = await _service.getAllMutasi();
      allData = result;

      _applyFilterInternal();
    } catch (e) {
      errorMessage = 'Gagal memuat data mutasi: $e';
      filteredData = [];
    } finally {
      isLoading = false;
    }
  }

  // ============================================================
  // 🔍 SEARCH / FILTER
  //    (sementara cuma pakai search by idWarga, bisa dikembangin)
  // ============================================================
  void setSearch(String value) {
    searchQuery = value.trim();
    _applyFilterInternal();
  }

  void resetSearch() {
    searchQuery = '';
    _applyFilterInternal();
  }

  void _applyFilterInternal() {
    filteredData = allData.where((m) {
      if (searchQuery.isEmpty) return true;

      // kalau nanti kamu punya namaWarga, bisa diganti ke m.namaWarga
      return m.idWarga.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  // ============================================================
  // 🔴 HAPUS MUTASI (FIRESTORE + LOCAL)
  // ============================================================
  Future<bool> deleteMutasi(MutasiModel model) async {
    try {
      final success = await _service.deleteMutasi(model.uid);
      if (success) {
        allData.removeWhere((e) => e.uid == model.uid);
        _applyFilterInternal();
      }
      return success;
    } catch (e) {
      errorMessage = 'Gagal menghapus mutasi: $e';
      return false;
    }
  }

  // ============================================================
  // 🟡 UPDATE MUTASI (opsional, kalau mau update lokal tanpa reload)
  //    Sekarang lebih simpel: setelah update, kamu bisa panggil loadData()
  // ============================================================
}
