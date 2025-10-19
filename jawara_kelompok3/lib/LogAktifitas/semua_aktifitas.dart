import 'package:flutter/material.dart';
// Menggunakan path sidebar Anda
import '../../Layout/sidebar.dart'; 
// Menggunakan path theme Anda
import '../../Theme/app_theme.dart'; 

class SemuaAktifitasPage extends StatefulWidget {
  const SemuaAktifitasPage({super.key});

  @override
  State<SemuaAktifitasPage> createState() => _SemuaAktifitasPageState();
}

class _SemuaAktifitasPageState extends State<SemuaAktifitasPage> {
  // Data mentah
  static const List<Map<String, String>> _allActivityData = [
    {
      'no': '1',
      'deskripsi': 'Menugaskan tagihan: Mingguan periode Oktober 2025 sebesar Rp. 12.',
      'aktor': 'Admin Jawara',
      'tanggal': '18 Oktober 2025'
    },
    {
      'no': '2',
      'deskripsi': 'Menghapus transfer channel: Bank Mega',
      'aktor': 'Admin Jawara',
      'tanggal': '18 Oktober 2025'
    },
    {
      'no': '3',
      'deskripsi': 'Menambahkan rumah baru dengan alamat: Jl. Merbabu',
      'aktor': 'User Rumah Baru',
      'tanggal': '18 Oktober 2025'
    },
    {
      'no': '4',
      'deskripsi': 'Mengubah iuran: Agustusan',
      'aktor': 'Admin Jawara',
      'tanggal': '17 Oktober 2025'
    },
    {
      'no': '5',
      'deskripsi': 'Membuat broadcast baru: DJ BAWKS',
      'aktor': 'User Broadcast',
      'tanggal': '17 Oktober 2025'
    },
    {
      'no': '6',
      'deskripsi': 'Menambahkan pengeluaran: Arka sebesar Rp. 6',
      'aktor': 'Admin Keuangan',
      'tanggal': '17 Oktober 2025'
    },
    {
      'no': '7',
      'deskripsi': 'Menambahkan akun: dewqedwdw sebagai neighborhood_head',
      'aktor': 'Admin Jawara',
      'tanggal': '17 Oktober 2025'
    },
    {
      'no': '8',
      'deskripsi': 'Memperbarui data warga, varizkiy nahdiba rinma',
      'aktor': 'User Warga',
      'tanggal': '17 Oktober 2025'
    },
    {
      'no': '9',
      'deskripsi': 'Menyetujui registrasi dari: Keluarga Rendha Putra Rahmadya',
      'aktor': 'Admin Jawara',
      'tanggal': '16 Oktober 2025'
    },
    {
      'no': '10',
      'deskripsi': 'Menugaskan tagihan: Mingguan periode Oktober 2025 sebesar Rp. 12',
      'aktor': 'Admin Keuangan',
      'tanggal': '16 Oktober 2025'
    },
  ];

  // State untuk Search dan Filter (dipertahankan agar kode tetap fungsional)
  List<Map<String, String>> _filteredActivityData = _allActivityData;
  String _searchQuery = ''; 
  String? _selectedAktorFilter; 
  late final List<String> _aktorOptions;

  // Breakpoint untuk menentukan tampilan mobile/desktop
  static const double mobileBreakpoint = 600.0; 

  @override
  void initState() {
    super.initState();
    _aktorOptions = _allActivityData.map((data) => data['aktor']!).toSet().toList();
    _filterData();
  }

  // Logika Filter & Search
  void _filterData({String? search, String? aktor}) {
    final currentSearch = search ?? _searchQuery;
    final currentAktor = aktor ?? _selectedAktorFilter;

    setState(() {
      _searchQuery = currentSearch;
      _selectedAktorFilter = currentAktor;

      List<Map<String, String>> tempData = _allActivityData;
      if (currentAktor != null && currentAktor.isNotEmpty) {
        tempData = tempData.where((data) => data['aktor'] == currentAktor).toList();
      }
      if (currentSearch.isNotEmpty) {
        final lowerCaseQuery = currentSearch.toLowerCase();
        tempData = tempData.where((data) {
          return data.values.any((value) => 
            value.toLowerCase().contains(lowerCaseQuery)
          );
        }).toList();
      }
      _filteredActivityData = tempData;
    });
  }

  // --- WIDGET MODAL FILTER ---
  void _showFilterModal(BuildContext context) {
    String? tempSelectedAktor = _selectedAktorFilter;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              title: const Text('Filter Aktifitas'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Filter berdasarkan Aktor:'),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: tempSelectedAktor,
                      hint: const Text('Semua Aktor'),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      ),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('Semua Aktor')),
                        ..._aktorOptions.map((aktor) {
                          return DropdownMenuItem(
                            value: aktor,
                            child: Text(aktor),
                          );
                        }).toList(),
                      ],
                      onChanged: (String? newValue) {
                        setStateModal(() {
                          tempSelectedAktor = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _filterData(aktor: tempSelectedAktor);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Terapkan Filter'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary; 

    return Scaffold(
      drawer: const AppSidebar(), 
      appBar: AppBar(
        title: const Text("Semua Aktifitas",
            style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      
      // *** START: STRUKTUR UTAMA UNTUK CENTERING & RESPONSIVITAS ***
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          // LayoutBuilder: Mendeteksi lebar layar saat ini
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < mobileBreakpoint; 

            return Center(
              // Center: Membuat Card Aktifitas berada di tengah layar
              child: ConstrainedBox(
                // ConstrainedBox: Memastikan Card melebar secara responsif, 
                // namun tidak melebihi 1200px pada layar ultra-wide
                constraints: const BoxConstraints(
                  maxWidth: 1200, 
                ),
                child: Card(
                  elevation: 5,
                  color: theme.colorScheme.surface,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // BAGIAN SEARCH BAR
                        _buildSearchBar(context, isMobile),
                        const SizedBox(height: 15),

                        // BAGIAN FILTER DAN SORTING
                        _buildFilterAndSortBar(context),
                        const SizedBox(height: 20),

                        // Widget Konten Utama: Ditentukan oleh isMobile
                        _filteredActivityData.isEmpty
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(40.0),
                                  child: Text(
                                    "Tidak ditemukan aktifitas yang sesuai dengan kriteria filter/pencarian.",
                                    style: TextStyle(fontSize: 16, color: Colors.grey),
                                  ),
                                ),
                              )
                            : isMobile
                                // Tampilan Mobile (List Card)
                                ? _buildMobileActivityList(context) 
                                // Tampilan Desktop (Data Table)
                                : _buildActivityTable(context),     

                        const SizedBox(height: 20),

                        // Bagian Paginasi
                        if (_searchQuery.isEmpty && _selectedAktorFilter == null && _filteredActivityData.length > 10)
                           _buildPagination(context),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      // *** END: STRUKTUR UTAMA UNTUK CENTERING & RESPONSIVITAS ***
    );
  }

  // Widget: Search Bar
  Widget _buildSearchBar(BuildContext context, bool isMobile) {
    return TextFormField(
      initialValue: _searchQuery,
      onChanged: (query) => _filterData(search: query),
      decoration: InputDecoration(
        labelText: 'Cari Aktifitas',
        hintText: 'Misal: Admin Jawara, Bank Mega...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _filterData(search: ''); 
                  FocusScope.of(context).unfocus(); 
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.lightBlue),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.primaryGreen, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: isMobile ? 12 : 16),
      ),
      keyboardType: TextInputType.text,
    );
  }
  
  // Widget Header Tabel (Filter Button)
  Widget _buildFilterAndSortBar(BuildContext context) {
    final isFilterActive = _selectedAktorFilter != null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isFilterActive)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Chip(
              label: Text(_selectedAktorFilter!),
              onDeleted: () {
                _filterData(aktor: null); 
              },
              deleteIcon: const Icon(Icons.close, size: 18, color: AppTheme.primaryGreen),
              labelStyle: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.w500),
            ),
          ),
        // Tombol Filter/Sorting
        ElevatedButton.icon(
          onPressed: () => _showFilterModal(context),
          icon: const Icon(Icons.filter_alt),
          label: const Text("Filter"),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }


  // Widget untuk membangun Data Table (Tampilan Layar Lebar)
  Widget _buildActivityTable(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 40, 
        headingRowColor: MaterialStateProperty.resolveWith((states) => AppTheme.lightBlue.withOpacity(0.5)),
        dataRowHeight: 60, 
        columns: const [
          DataColumn(
              label: Text('NO',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('DESKRIPSI',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('AKTOR',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('TANGGAL',
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: _filteredActivityData.map((data) {
          return DataRow(
            cells: [
              DataCell(Text(data['no'] ?? '')),
              DataCell(
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 250, maxWidth: 450), 
                  child: Text(data['deskripsi'] ?? '', maxLines: 3, overflow: TextOverflow.ellipsis),
                ),
              ),
              DataCell(Text(data['aktor'] ?? '')),
              DataCell(Text(data['tanggal'] ?? '')),
            ],
          );
        }).toList(),
      ),
    );
  }

  // Widget untuk membangun Daftar Card (Tampilan Layar Sempit/Mobile)
  Widget _buildMobileActivityList(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(), 
      shrinkWrap: true,
      itemCount: _filteredActivityData.length,
      itemBuilder: (context, index) {
        final data = _filteredActivityData[index];
        return Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '#${data['no']}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        data['aktor'] ?? 'N/A',
                        style: const TextStyle(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 15),

                Text(
                  data['deskripsi'] ?? '',
                  style: const TextStyle(fontSize: 14),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(
                      data['tanggal'] ?? 'N/A',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget untuk membangun Paginasi
  Widget _buildPagination(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.grey),
        ),
        const SizedBox(width: 8),

        _buildPageNumber(context, '1', isActive: true),
        const SizedBox(width: 8),

        _buildPageNumber(context, '2'),
        const SizedBox(width: 8),
        
        const Text('...', style: TextStyle(color: Colors.grey)),
        const SizedBox(width: 8),
        
        _buildPageNumber(context, '13'),
        const SizedBox(width: 8),

        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ),
      ],
    );
  }

  // Helper Widget untuk nomor halaman
  Widget _buildPageNumber(BuildContext context, String number,
      {bool isActive = false}) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primaryBlue : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? AppTheme.primaryBlue : Colors.grey.shade300,
        ),
      ),
      child: TextButton(
        onPressed: () {
          // Simulasi pindah halaman
        },
        child: Text(
          number,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
