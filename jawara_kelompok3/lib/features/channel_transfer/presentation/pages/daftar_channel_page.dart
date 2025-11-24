import 'package:flutter/material.dart';
import '../../../../core/layout/header.dart';
import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';
import 'detail_channel_page.dart';
import 'edit_channel_page.dart';

class DaftarChannelPage extends StatefulWidget {
  const DaftarChannelPage({super.key});

  @override
  State<DaftarChannelPage> createState() => _DaftarChannelPageState();
}

class _DaftarChannelPageState extends State<DaftarChannelPage> {
  // data dummy
  List<Map<String, String>> channelData = [
    {
      'no': '1',
      'nama': '234234',
      'tipe': 'ewallet',
      'a/n': '23234',
      'thumbnail': 'assets/images/gambar1.jpg',
      'qr': 'assets/images/gambar1.jpg',
    },
    {
      'no': '2',
      'nama': 'Transfer via BCA',
      'tipe': 'bank',
      'a/n': 'RT Jawara Karangploso',
      'thumbnail': 'assets/images/gambar1.jpg',
      'qr': 'assets/images/gambar1.jpg',
    },
    {
      'no': '3',
      'nama': 'Gopay Ketua RT',
      'tipe': 'ewallet',
      'a/n': 'Budi Santoso',
      'thumbnail': 'assets/images/gambar1.jpg',
      'qr': 'assets/images/gambar1.jpg',
    },
    {
      'no': '4',
      'nama': 'QRIS Resmi RT 08',
      'tipe': 'qris',
      'a/n': 'RW 08 Karangploso',
      'thumbnail': 'assets/images/gambar1.jpg',
      'qr': 'assets/images/gambar1.jpg',
    },
  ];

  // VARIABEL FILTER
  String? _selectedTipe;

  // PAGINATION
  int _currentPage = 0;
  final int _rowsPerPage = 10;

  // OBILE BREAKPOINT
  static const double mobileBreakpoint = 600.0;

  // FUNGSI FILTER DATA CHANNEL
  void _filterData(String? tipe) {
    setState(() {
      _selectedTipe = tipe;
      _currentPage = 0;
    });
  }

  // FUNGSI MENAMPILKAN BOTTOM SHEET MENU AKSI CHANNEL
  void _showActionMenu(BuildContext context, Map<String, String> channel) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.info, color: AppTheme.blueMedium),
              title: const Text('Lihat Detail'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailChannelPage(channel: channel),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: AppTheme.yellowMedium),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditChannelPage(channel: channel),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppTheme.redMedium),
              title: const Text('Hapus'),
              onTap: () {
                Navigator.pop(context); // tutup bottom sheet terlebih dahulu
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Konfirmasi Hapus'),
                    content: const Text(
                        'Apakah Anda yakin ingin menghapus channel ini?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context), // batal
                        child: const Text('Batal'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.redMedium, // tombol merah
                        ),
                        onPressed: () {
                          setState(
                              () => channelData.remove(channel)); // hapus data
                          Navigator.pop(context); // tutup dialog
                        },
                        child: const Text(
                          'Hapus',
                          style: TextStyle(color: AppTheme.putihFull),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // FUNGSI MEMUNCULKAN MODAL FILTER
  void _showFilterModal(BuildContext context) {
    String? modalSelectedTipe = _selectedTipe ?? 'Semua';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              backgroundColor: AppTheme.backgroundBlueWhite,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: const Text('Filter Channel',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Tipe Channel",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Column(
                    children: ['Semua', 'ewallet', 'bank', 'qris']
                        .map((tipe) => RadioListTile<String>(
                              value: tipe,
                              groupValue: modalSelectedTipe,
                              title: Text(
                                tipe.toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                              activeColor: AppTheme.primaryGreen,
                              onChanged: (val) {
                                setModalState(() => modalSelectedTipe = val);
                              },
                            ))
                        .toList(),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    setState(() => _selectedTipe = 'Semua');
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.redMediumDark,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  child: const Text('Reset Filter',
                      style: TextStyle(color: AppTheme.putihFull)),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() => _selectedTipe = modalSelectedTipe);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.greenDark,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  child: const Text('Terapkan',
                      style: TextStyle(color: AppTheme.putihFull)),
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
    final isMobile = MediaQuery.of(context).size.width < mobileBreakpoint;

    // FILTER DATA SESUAI TIPE
    final filteredData = _selectedTipe == null || _selectedTipe == 'Semua'
        ? channelData
        : channelData.where((c) => c['tipe'] == _selectedTipe).toList();

    // PAGINATION
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (startIndex + _rowsPerPage) > filteredData.length
        ? filteredData.length
        : startIndex + _rowsPerPage;
    final paginatedData = filteredData.sublist(startIndex, endIndex);
    final totalPages = (filteredData.length / _rowsPerPage).ceil();

    return Scaffold(
      drawer: const AppSidebar(),
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        elevation: 3,
        title: const Text(
          "Daftar Channel Transfer",
          style:
              TextStyle(color: AppTheme.putihFull, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // TOMBOL FILTER
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ElevatedButton.icon(
                    onPressed: () => _showFilterModal(context),
                    icon: const Icon(Icons.filter_list, size: 18),
                    label: const Text('Filter',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.yellowMediumDark,
                      foregroundColor: AppTheme.putihFull,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                    ),
                  ),
                ),

                // JIKA DATA KOSONG
                paginatedData.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: Text(
                            'Tidak ada channel tersedia.',
                            style: TextStyle(color: AppTheme.abu),
                          ),
                        ),
                      )
                    : isMobile
                        ? _buildMobileList(paginatedData)
                        : _buildDesktopTable(paginatedData),

                const SizedBox(height: 20),

                // PAGINATION
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: _currentPage > 0
                          ? () => setState(() => _currentPage--)
                          : null,
                    ),
                    ...List.generate(totalPages, (i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _currentPage == i
                                ? AppTheme.primaryBlue
                                : AppTheme.putih,
                            minimumSize: const Size(36, 36),
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () => setState(() => _currentPage = i),
                          child: Text(
                            '${i + 1}',
                            style: TextStyle(
                                color: _currentPage == i
                                    ? AppTheme.putihFull
                                    : AppTheme.hitam),
                          ),
                        ),
                      );
                    }),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: _currentPage < totalPages - 1
                          ? () => setState(() => _currentPage++)
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // WIDGET DATA TABLE DESKTOP
  Widget _buildDesktopTable(List<Map<String, String>> paginatedData) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor:
            MaterialStateProperty.all(AppTheme.lightBlue.withOpacity(0.3)),
        headingTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryBlue,
        ),
        dataRowColor: MaterialStateProperty.all(AppTheme.putihFull),
        columns: const [
          DataColumn(label: Text('No')),
          DataColumn(label: Text('Nama')),
          DataColumn(label: Text('Tipe')),
          DataColumn(label: Text('A/N')),
          DataColumn(label: Text('Thumbnail')),
          DataColumn(label: Text('Aksi')),
        ],
        rows: paginatedData.map((item) {
          return DataRow(
            cells: [
              DataCell(Text(item['no']!)),
              DataCell(Text(item['nama']!)),
              DataCell(Text(item['tipe']!)),
              DataCell(Text(item['a/n']!)),
              DataCell(
                // Tampilkan gambar thumbnail lokal
                Image.asset(item['thumbnail']!, width: 50, height: 50),
              ),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => _showActionMenu(context, item),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // WIDGET LIST MOBILE
  Widget _buildMobileList(List<Map<String, String>> paginatedData) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: paginatedData.length,
      itemBuilder: (context, index) {
        final item = paginatedData[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: AppTheme.putihFull,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.putih,
                  blurRadius: 6,
                  offset: const Offset(0, 3)),
            ],
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryBlue,
              child: Text(item['no']!,
                  style: const TextStyle(
                      color: AppTheme.putihFull, fontWeight: FontWeight.bold)),
            ),
            title: Text(
              item['nama']!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tipe: ${item['tipe']}',
                  style: const TextStyle(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.w500,
                      fontSize: 12),
                ),
                Text(
                  'A/N: ${item['a/n']}',
                  style: const TextStyle(
                      color: AppTheme.abu,
                      fontWeight: FontWeight.w500,
                      fontSize: 12),
                ),
                const SizedBox(height: 4),
                // Tampilkan thumbnail di mobile
                Image.asset(item['thumbnail']!, width: 60, height: 60),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showActionMenu(context, item),
            ),
          ),
        );
      },
    );
  }
}
