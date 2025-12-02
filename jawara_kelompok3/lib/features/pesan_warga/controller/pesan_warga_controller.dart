import '../data/models/pesan_warga_model.dart';
import '../data/services/pesan_warga_service.dart';

/// Controller untuk mengelola data Pesan Warga / Aspirasi
/// - handle load dari Firestore
/// - filter (search + status)
/// - pagination (currentPage, rowsPerPage)
/// - delete / update lokal
class PesanWargaController {
  final PesanWargaService _service;

  /// Banyak data per halaman (untuk pagination)
  final int rowsPerPage;

  /// Semua data hasil load dari Firestore
  List<PesanWargaModel> allData = [];

  /// Data setelah difilter (ditampilkan di UI)
  List<PesanWargaModel> filteredData = [];

  /// Query pencarian
  String searchQuery = '';

  /// Filter status (Pending / Diterima / Ditolak / null / "Semua")
  String? statusFilter;

  /// Halaman aktif (0-based index)
  int currentPage = 0;

  /// Flag loading (bisa dipakai di UI untuk tampilan loading)
  bool isLoading = false;

  /// Pesan error jika load gagal
  String? errorMessage;

  PesanWargaController({
    PesanWargaService? service,
    this.rowsPerPage = 10,
  }) : _service = service ?? PesanWargaService();

  // ============================================================
  // 🔵 LOAD DATA DARI FIRESTORE
  // ============================================================
  Future<void> loadData() async {
    try {
      isLoading = true;
      errorMessage = null;

      final result = await _service.getSemuaPesan();
      allData = result;

      // setelah load → langsung apply filter awal
      _applyFilterInternal();
    } catch (e) {
      errorMessage = 'Gagal memuat data aspirasi: $e';
    } finally {
      isLoading = false;
    }
  }

  // ============================================================
  // 🔍 SET FILTER & SEARCH
  // ============================================================
  void applyFilter({
    String? search,
    String? status,
  }) {
    searchQuery = search ?? searchQuery;
    statusFilter = status ?? statusFilter;

    _applyFilterInternal();
  }

  void resetFilter() {
    searchQuery = '';
    statusFilter = null;
    _applyFilterInternal();
  }

  void _applyFilterInternal() {
    filteredData = allData.where((p) {
      final matchesSearch = searchQuery.isEmpty
          ? true
          : p.isiPesan.toLowerCase().contains(searchQuery.toLowerCase()) ||
              p.idPesan.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesStatus = statusFilter == null ||
              statusFilter == 'Semua' ||
              statusFilter!.isEmpty
          ? true
          : p.status == statusFilter;

      return matchesSearch && matchesStatus;
    }).toList();

    currentPage = 0;
  }

  // ============================================================
  // 📄 PAGINATION
  // ============================================================
  List<PesanWargaModel> get paginatedData {
    if (filteredData.isEmpty) return [];

    final start = currentPage * rowsPerPage;
    var end = start + rowsPerPage;

    if (start >= filteredData.length) {
      // kalau page lebih besar dari jumlah data, paksa balik ke page terakhir
      currentPage = totalPages - 1;
      final newStart = currentPage * rowsPerPage;
      end = filteredData.length;
      return filteredData.sublist(newStart, end);
    }

    if (end > filteredData.length) {
      end = filteredData.length;
    }

    return filteredData.sublist(start, end);
  }

  int get totalPages {
    if (filteredData.isEmpty) return 1;
    final t = (filteredData.length / rowsPerPage).ceil();
    return t < 1 ? 1 : t;
  }

  void setPage(int page) {
    if (page < 0) {
      currentPage = 0;
    } else if (page >= totalPages) {
      currentPage = totalPages - 1;
    } else {
      currentPage = page;
    }
  }

  // ============================================================
  // 🗑 DELETE (LOKAL + FIRESTORE)
  // ============================================================
  Future<bool> deleteAspirasi(PesanWargaModel model) async {
    final success = await _service.deletePesan(model.docId);
    if (success) {
      allData.removeWhere((e) => e.docId == model.docId);
      _applyFilterInternal();
    }
    return success;
  }

  // ============================================================
  // 🟡 UPDATE LOKAL (setelah edit)
  //    (kalau kamu tidak mau reload dari Firestore)
  // ============================================================
  void updateLocal(PesanWargaModel updated) {
    final index = allData.indexWhere((e) => e.docId == updated.docId);
    if (index != -1) {
      allData[index] = updated;
      _applyFilterInternal();
    }
  }
}
