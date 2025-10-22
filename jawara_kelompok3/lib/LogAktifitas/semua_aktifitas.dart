import 'package:flutter/material.dart';
import '../../Layout/sidebar.dart';
import '../../Theme/app_theme.dart';

class SemuaAktifitasPage extends StatefulWidget {
  const SemuaAktifitasPage({super.key});

  @override
  State<SemuaAktifitasPage> createState() => _SemuaAktifitasPageState();
}

class _SemuaAktifitasPageState extends State<SemuaAktifitasPage> {
  // Dummy data
  static const List<Map<String, String>> _allActivityData = [
    {
      'no': '1',
      'deskripsi': 'Menambahkan pengeluaran : Kerja Bakti sebesar Rp. 50.000',
      'aktor': 'Admin Jawara',
      'tanggal': '19 Oktober 2025'
    },
    {
      'no': '2',
      'deskripsi': 'Menambahkan pengeluaran : Kerja Bakti sebesar Rp. 100.000',
      'aktor': 'Admin Jawara',
      'tanggal': '19 Oktober 2025'
    },
    {
      'no': '3',
      'deskripsi': 'Menolak registrasi dari : asdfghjkjl',
      'aktor': 'Admin Jawara',
      'tanggal': '19 Oktober 2025'
    },
    {
      'no': '4',
      'deskripsi': 'Menambahkan akun : mimin sebagai community_head',
      'aktor': 'Admin Jawara',
      'tanggal': '19 Oktober 2025'
    },
    {
      'no': '5',
      'deskripsi':
          'Menugaskan tagihan : Agustusan periode Januari 2025 sebesar Rp. 15',
      'aktor': 'Admin Jawara',
      'tanggal': '19 Oktober 2025'
    },
    {
      'no': '6',
      'deskripsi': 'Menyetujui registrasi dari : Keluarga Tes',
      'aktor': 'Admin Jawara',
      'tanggal': '19 Oktober 2025'
    },
    {
      'no': '7',
      'deskripsi':
          'Menugaskan tagihan : Mingguan periode Oktober 2025 sebesar Rp. 12',
      'aktor': 'Admin Jawara',
      'tanggal': '19 Oktober 2025'
    },
    {
      'no': '8',
      'deskripsi': 'Mendownload laporan keuangan',
      'aktor': 'Admin Jawara',
      'tanggal': '19 Oktober 2025'
    },
    {
      'no': '9',
      'deskripsi': 'Menambahkan iuran baru: Harian',
      'aktor': 'Admin Jawara',
      'tanggal': '19 Oktober 2025'
    },
    {
      'no': '10',
      'deskripsi': 'Menambahkan iuran baru: Kerja Bakti',
      'aktor': 'Admin Jawara',
      'tanggal': '19 Oktober 2025'
    },
    {
      'no': '11',
      'deskripsi': 'Menambahkan tagihan baru: Piket Mingguan',
      'aktor': 'Admin Jawara',
      'tanggal': '20 Oktober 2025'
    },
    {
      'no': '12',
      'deskripsi': 'Menghapus tagihan lama: Kas Warga',
      'aktor': 'Admin Jawara',
      'tanggal': '20 Oktober 2025'
    },
  ];

  // Data hasil filter
  List<Map<String, String>> _filteredActivityData = _allActivityData;

  // Variabel filter
  String _searchDeskripsi = '';
  String _searchAktor = '';
  DateTime? _startDate;
  DateTime? _endDate;

  static const double mobileBreakpoint = 600.0;

  // Variabel pagination
  int _currentPage = 0;
  final int _rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _filterData();
  }

  // Fungsi memfilter data
  void _filterData({
    String? deskripsi,
    String? aktor,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    setState(() {
      // Update nilai filter
      _searchDeskripsi = deskripsi ?? _searchDeskripsi;
      _searchAktor = aktor ?? _searchAktor;
      _startDate = startDate ?? _startDate;
      _endDate = endDate ?? _endDate;

      // Filter data
      _filteredActivityData = _allActivityData.where((data) {
        final deskripsiMatch = data['deskripsi']!
            .toLowerCase()
            .contains(_searchDeskripsi.toLowerCase());
        final aktorMatch =
            data['aktor']!.toLowerCase().contains(_searchAktor.toLowerCase());

        // Ubah tanggal
        final tanggalString = data['tanggal']!;
        DateTime? dataTanggal;

        try {
          // Parsing tanggal
          dataTanggal = _parseTanggalIndonesia(tanggalString);
        } catch (e) {
          dataTanggal = null;
        }

        // Cek apakah tanggal masuk dalam rentang filter
        bool dateMatch = true;
        if (_startDate != null && dataTanggal != null) {
          dateMatch = dataTanggal
              .isAfter(_startDate!.subtract(const Duration(days: 1)));
        }
        if (_endDate != null && dataTanggal != null) {
          dateMatch = dateMatch &&
              dataTanggal.isBefore(_endDate!.add(const Duration(days: 1)));
        }

        return deskripsiMatch && aktorMatch && dateMatch;
      }).toList();

      _currentPage = 0;
    });
  }

  // Fungsi mengubah string tanggal menjadi objek DateTime
  DateTime _parseTanggalIndonesia(String tanggal) {
    final bulanMap = {
      'Januari': 1,
      'Februari': 2,
      'Maret': 3,
      'April': 4,
      'Mei': 5,
      'Juni': 6,
      'Juli': 7,
      'Agustus': 8,
      'September': 9,
      'Oktober': 10,
      'November': 11,
      'Desember': 12,
    };

    final parts = tanggal.split(' ');
    final day = int.parse(parts[0]);
    final month = bulanMap[parts[1]]!;
    final year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  // Menghapus semua filter dan menampilkan seluruh data
  void _resetFilter() {
    setState(() {
      _searchDeskripsi = '';
      _searchAktor = '';
      _startDate = null;
      _endDate = null;
      _filteredActivityData = _allActivityData;
      _currentPage = 0;
    });
  }

  // Menampilkan date picker untuk memilih tanggal mulai/akhir
  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2025, 10, 19),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  // Menampilkan modal filter dengan input deskripsi, aktor, dan tanggal
  void _showFilterModal(BuildContext context) {
    final TextEditingController deskripsiCtrl =
        TextEditingController(text: _searchDeskripsi);
    final TextEditingController aktorCtrl =
        TextEditingController(text: _searchAktor);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        DateTime? localStartDate = _startDate;
        DateTime? localEndDate = _endDate;

        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> pickDate(bool isStart) async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(2025, 10, 19),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (picked != null) {
                setModalState(() {
                  if (isStart) {
                    localStartDate = picked;
                  } else {
                    localEndDate = picked;
                  }
                });
              }
            }

            return AlertDialog(
              backgroundColor: AppTheme.backgroundBlueWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Filter Aktivitas',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Deskripsi",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppTheme.hitam,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: deskripsiCtrl,
                      style: TextStyle(color: AppTheme.hitam),
                      decoration: InputDecoration(
                        hintText: "Cari deskripsi...",
                        hintStyle: TextStyle(color: AppTheme.abu),
                        filled: true,
                        fillColor: AppTheme.abu.withOpacity(0.2),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppTheme.abu),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppTheme.primaryBlue, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "Nama Pelaku",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppTheme.hitam,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: aktorCtrl,
                      style: TextStyle(color: AppTheme.hitam),
                      decoration: InputDecoration(
                        hintText: "Contoh: Fafa",
                        hintStyle: TextStyle(color: AppTheme.abu),
                        filled: true,
                        fillColor: AppTheme.abu.withOpacity(0.2),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppTheme.abu),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppTheme.primaryBlue, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "Dari Tanggal",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppTheme.hitam,
                      ),
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: () => pickDate(true),
                      child: _buildDateField(localStartDate),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "Sampai Tanggal",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppTheme.hitam,
                      ),
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: () => pickDate(false),
                      child: _buildDateField(localEndDate),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    _resetFilter();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.redMediumDark,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  child: const Text(
                    'Reset Filter',
                    style: TextStyle(color: AppTheme.putihFull),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _filterData(
                      deskripsi: deskripsiCtrl.text,
                      aktor: aktorCtrl.text,
                      startDate: localStartDate,
                      endDate: localEndDate,
                    );
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.greenDark,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  child: const Text(
                    'Terapkan',
                    style: TextStyle(color: AppTheme.putihFull),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Widget kecil untuk menampilkan field tanggal pada modal filter
  Widget _buildDateField(DateTime? date) {
    final text = date == null
        ? '-- / -- / ----'
        : '${date.day.toString().padLeft(2, '0')} / ${date.month.toString().padLeft(2, '0')} / ${date.year}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.abu.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 16, color: AppTheme.abu),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: AppTheme.hitam)),
        ],
      ),
    );
  }

  // Bangun tampilan utama halaman Semua Aktivitas
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < mobileBreakpoint;

    // Pagination slicing
    final int startIndex = _currentPage * _rowsPerPage;
    final int endIndex =
        (_currentPage + 1) * _rowsPerPage > _filteredActivityData.length
            ? _filteredActivityData.length
            : (_currentPage + 1) * _rowsPerPage;
    final List<Map<String, String>> paginatedData =
        _filteredActivityData.sublist(startIndex, endIndex);

    final int totalPages = (_filteredActivityData.length / _rowsPerPage).ceil();

    return Scaffold(
        drawer: const AppSidebar(),
        backgroundColor: AppTheme.backgroundBlueWhite,
        appBar: AppBar(
          backgroundColor: AppTheme.primaryBlue,
          elevation: 3,
          title: const Text(
            'Semua Aktivitas',
            style: TextStyle(
                color: AppTheme.putihFull,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildFilterAndSortBar(context),
                    const SizedBox(height: 20),
                    _filteredActivityData.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Center(
                              child: Text(
                                "Tidak ditemukan aktivitas yang sesuai.",
                                style: TextStyle(
                                    color: AppTheme.abu, fontSize: 16),
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              isMobile
                                  ? _buildMobileActivityList(
                                      context, paginatedData)
                                  : _buildActivityTable(context, paginatedData),
                              const SizedBox(height: 20),
                              _buildPaginationControls(totalPages),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  // Widget kontrol pagination
  Widget _buildPaginationControls(int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _currentPage > 0
              ? () {
                  setState(() {
                    _currentPage--;
                  });
                }
              : null,
        ),
        ...List.generate(totalPages, (i) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _currentPage == i
                    ? AppTheme.primaryBlue
                    : AppTheme.putihFull,
                minimumSize: const Size(36, 36),
                padding: EdgeInsets.zero,
              ),
              onPressed: () {
                setState(() {
                  _currentPage = i;
                });
              },
              child: Text(
                '${i + 1}',
                style: TextStyle(
                  color:
                      _currentPage == i ? AppTheme.putihFull : AppTheme.hitam,
                ),
              ),
            ),
          );
        }),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _currentPage < totalPages - 1
              ? () {
                  setState(() {
                    _currentPage++;
                  });
                }
              : null,
        ),
      ],
    );
  }

  // Bar atas yang berisi tombol Filter
  Widget _buildFilterAndSortBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: () => _showFilterModal(context),
          icon: const Icon(Icons.filter_alt),
          label: const Text("Filter Aktivitas"),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.yellowDark,
            foregroundColor: AppTheme.putihFull,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
          ),
        ),
      ],
    );
  }

  // Tabel aktivitas untuk tampilan desktop
  Widget _buildActivityTable(
      BuildContext context, List<Map<String, String>> paginatedData) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 40,
        headingRowColor:
            MaterialStateProperty.all(AppTheme.lightBlue.withOpacity(0.3)),
        dataRowColor: MaterialStateProperty.all(AppTheme.backgroundBlueWhite),
        border: TableBorder.all(color: AppTheme.putihFull),
        columns: const [
          DataColumn(label: Text('No')),
          DataColumn(label: Text('Deskripsi')),
          DataColumn(label: Text('Aktor')),
          DataColumn(label: Text('Tanggal')),
        ],
        rows: paginatedData.map((data) {
          return DataRow(cells: [
            DataCell(Text(data['no']!)),
            DataCell(SizedBox(
                width: 400,
                child: Text(data['deskripsi']!,
                    maxLines: 2, overflow: TextOverflow.ellipsis))),
            DataCell(Text(data['aktor']!)),
            DataCell(Text(data['tanggal']!)),
          ]);
        }).toList(),
      ),
    );
  }

  // List aktivitas versi mobile
  Widget _buildMobileActivityList(
      BuildContext context, List<Map<String, String>> paginatedData) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: paginatedData.length,
      itemBuilder: (context, index) {
        final data = paginatedData[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppTheme.putihFull,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.hitam.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3)),
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryBlue,
              child: Text(
                data['no']!,
                style: const TextStyle(
                    color: AppTheme.putihFull, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              data['deskripsi']!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  data['aktor']!,
                  style: const TextStyle(
                      color: AppTheme.yellowMediumDark,
                      fontWeight: FontWeight.w500,
                      fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 14, color: AppTheme.abu),
                    const SizedBox(width: 4),
                    Text(
                      data['tanggal']!,
                      style: const TextStyle(color: AppTheme.abu, fontSize: 12),
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
}
