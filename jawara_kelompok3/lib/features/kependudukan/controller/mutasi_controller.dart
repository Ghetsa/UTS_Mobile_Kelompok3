import '../data/models/mutasi_model.dart';
import '../data/services/mutasi_service.dart';

/// Controller Mutasi (per Warga)
class MutasiController {
  final MutasiService _service;

  /// Semua data dari Firestore
  List<MutasiModel> allData = [];

  /// Data yang sudah difilter (dipakai di UI)
  List<MutasiModel> filteredData = [];

  /// Query pencarian (search)
  String searchQuery = '';

  /// Filter jenis mutasi ("Semua", "Pindah Masuk", "Pindah Keluar", dll)
  String jenisFilter = 'Semua';

  /// Flag loading
  bool isLoading = false;

  /// Error terakhir
  String? errorMessage;

  MutasiController({MutasiService? service})
      : _service = service ?? MutasiService();

  // ============================================================
  // 🔵 LOAD DATA
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
  // ============================================================
  void setSearch(String value) {
    searchQuery = value.trim();
    _applyFilterInternal();
  }

  void resetSearch() {
    searchQuery = '';
    _applyFilterInternal();
  }

  /// set filter jenis mutasi dari dialog
  void setFilterJenis(String value) {
    jenisFilter = value; // "Semua" / "Pindah Masuk" / "Pindah Keluar" / ...
    _applyFilterInternal();
  }

  void _applyFilterInternal() {
    final q = searchQuery.toLowerCase();
    final jenis = jenisFilter.toLowerCase();

    filteredData = allData.where((m) {
      // 🎯 1) Filter berdasarkan jenis mutasi lebih dulu
      if (jenis != 'semua') {
        if (m.jenisMutasi.toLowerCase() != jenis) {
          return false;
        }
      }

      // 🔍 2) Filter search (idWarga / jenis / keterangan / uid)
      if (q.isEmpty) return true;

      return m.idWarga.toLowerCase().contains(q) ||
          m.jenisMutasi.toLowerCase().contains(q) ||
          m.keterangan.toLowerCase().contains(q) ||
          m.uid.toLowerCase().contains(q);
    }).toList();
  }

  // ============================================================
  // 🔴 HAPUS MUTASI
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
  // 🟡 UPDATE MUTASI (optional, untuk dialog edit)
  // ============================================================
  Future<bool> updateMutasi(String docId, Map<String, dynamic> data) async {
    try {
      final ok = await _service.updateMutasi(docId, data);
      if (ok) {
        await loadData();
      }
      return ok;
    } catch (e) {
      errorMessage = 'Gagal mengupdate mutasi: $e';
      return false;
    }
  }
}
