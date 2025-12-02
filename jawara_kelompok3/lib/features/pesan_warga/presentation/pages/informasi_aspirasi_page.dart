import 'package:flutter/material.dart';

import '../../../../core/layout/header.dart';
import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';

// Model & Service Firebase
import '../../data/models/pesan_warga_model.dart';
import '../../data/services/pesan_warga_service.dart';

// widgets
import '../widgets/card/aspirasi_mobile_list.dart';
import '../widgets/card/aspirasi_desktop_table.dart';
import '../widgets/chip/aspirasi_pagination.dart';
import '../widgets/filter/aspirasi_filter_dialog.dart';

import 'detail_pesan_page.dart';
import 'edit_pesan_page.dart';

class SemuaAspirasi extends StatefulWidget {
  const SemuaAspirasi({super.key});

  @override
  State<SemuaAspirasi> createState() => _SemuaAspirasiState();
}

class _SemuaAspirasiState extends State<SemuaAspirasi> {
  final PesanWargaService _service = PesanWargaService();

  // 🔵 Data dari Firebase
  List<PesanWargaModel> _data = [];

  // 🟦 Filter & search states
  String _searchQuery = '';
  String? _selectedStatusFilter;

  // 🔶 Breakpoint mobile / desktop
  static const double mobileBreakpoint = 600.0;

  // 🔻 Pagination
  int _currentPage = 0;
  final int _rowsPerPage = 10;

  List<PesanWargaModel> _filteredData = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // ============================================================
  // 🔥 LOAD DATA DARI FIRESTORE
  // ============================================================
  Future<void> loadData() async {
    _data = await _service.getSemuaPesan();
    _applyFilter();
  }

  // ============================================================
  // 🔍 FILTER DATA
  // ============================================================
  void _applyFilter({
    String? searchQuery,
    String? statusFilter,
  }) {
    _searchQuery = searchQuery ?? _searchQuery;
    _selectedStatusFilter = statusFilter ?? _selectedStatusFilter;

    setState(() {
      _filteredData = _data.where((p) {
        final matchesSearch = _searchQuery.isEmpty
            ? true
            : p.isiPesan.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                p.idPesan.toLowerCase().contains(_searchQuery.toLowerCase());

        final matchesStatus = _selectedStatusFilter == null ||
                _selectedStatusFilter == 'Semua'
            ? true
            : p.status == _selectedStatusFilter;

        return matchesSearch && matchesStatus;
      }).toList();

      _currentPage = 0;
    });
  }

  // ============================================================
  // 🔄 RESET FILTER
  // ============================================================
  void _resetFilter() {
    setState(() {
      _searchQuery = '';
      _selectedStatusFilter = null;
      _filteredData = _data;
      _currentPage = 0;
    });
  }

  // ============================================================
  // 🟪 OPEN FILTER DIALOG
  // ============================================================
  Future<void> _openFilterDialog() async {
    await showDialog(
      context: context,
      builder: (_) => AspirasiFilterDialog(
        initialSearch: _searchQuery,
        initialStatus: _selectedStatusFilter,
        onApply: (search, status) {
          _applyFilter(searchQuery: search, statusFilter: status);
        },
        onReset: _resetFilter,
      ),
    );
  }

  // ============================================================
  // ⚙️ BOTTOM SHEET ACTION MENU
  // ============================================================
  void _showPopupActionMenu(BuildContext context, PesanWargaModel data) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            // DETAIL
            ListTile(
              leading: const Icon(Icons.info, color: AppTheme.blueMedium),
              title: const Text('Lihat Detail'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailAspirasi(model: data),
                  ),
                );
              },
            ),

            // EDIT
            ListTile(
              leading: const Icon(Icons.edit, color: AppTheme.yellowMedium),
              title: const Text('Edit'),
              onTap: () async {
                Navigator.pop(context);
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditAspirasi(model: data),
                  ),
                );

                if (updated == true) {
                  await loadData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Aspirasi berhasil diperbarui!"),
                      backgroundColor: AppTheme.blueMedium,
                    ),
                  );
                }
              },
            ),

            // DELETE
            ListTile(
              leading: const Icon(Icons.delete, color: AppTheme.redMedium),
              title: const Text('Hapus'),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(data);
              },
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // 🗑 KONFIRMASI DELETE
  // ============================================================
  void _confirmDelete(PesanWargaModel model) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: Text(
            'Hapus pesan / aspirasi dengan ID "${model.idPesan}"?'),
        actions: [
          TextButton(
            child:
                const Text("Batal", style: TextStyle(color: AppTheme.hitam)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.redMedium,
            ),
            child: const Text(
              "Hapus",
              style: TextStyle(color: AppTheme.putihFull),
            ),
            onPressed: () async {
              Navigator.pop(context);

              final success = await _service.deletePesan(model.docId);
              if (success) {
                await loadData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Aspirasi berhasil dihapus."),
                    backgroundColor: AppTheme.redMedium,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 🧱 UI BUILD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < mobileBreakpoint;

    // Pagination slicing
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (_currentPage + 1) * _rowsPerPage > _filteredData.length
        ? _filteredData.length
        : (_currentPage + 1) * _rowsPerPage;

    final paginated = _filteredData.sublist(startIndex, endIndex);

    final totalPages =
        (_filteredData.length / _rowsPerPage).ceil().clamp(1, 99);

    return Scaffold(
      drawer: const AppSidebar(),
      backgroundColor: AppTheme.backgroundBlueWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MainHeader(
              title: "Semua Aspirasi",
              searchHint: "Cari isi pesan / ID pesan...",
              showSearchBar: true,
              showFilterButton: true,
              onSearch: (value) => _applyFilter(searchQuery: value.trim()),
              onFilter: _openFilterDialog,
            ),

            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: _filteredData.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Center(
                              child: Text(
                                "Tidak ada aspirasi ditemukan.",
                                style: TextStyle(
                                  color: AppTheme.abu,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              if (isMobile)
                                AspirasiMobileList(
                                  data: paginated,
                                  onMorePressed: (m) =>
                                      _showPopupActionMenu(context, m),
                                )
                              else
                                AspirasiDesktopTable(
                                  data: paginated,
                                  onMorePressed: (m) =>
                                      _showPopupActionMenu(context, m),
                                ),

                              const SizedBox(height: 20),

                              AspirasiPagination(
                                currentPage: _currentPage,
                                totalPages: totalPages,
                                onPageChanged: (p) {
                                  setState(() => _currentPage = p);
                                },
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
