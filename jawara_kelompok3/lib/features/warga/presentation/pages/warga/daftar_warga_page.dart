import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/layout/sidebar.dart';
import '../../../../../core/widgets/filter_warga.dart';
import 'detail_warga_page.dart';
import 'edit_warga_page.dart';

class DaftarWargaPage extends StatefulWidget {
  const DaftarWargaPage({super.key});

  @override
  State<DaftarWargaPage> createState() => _DaftarWargaPageState();
}

class _DaftarWargaPageState extends State<DaftarWargaPage> {
  final List<Map<String, dynamic>> warga = [
    {
      "nama": "Ghetsa Ramadhani",
      "nik": "137111011030005",
      "keluarga": "Keluarga Ghetsa Ramadhani",
      "jenisKelamin": "Perempuan",
      "statusDomisili": "Aktif",
      "statusHidup": "Hidup",
    },
    {
      "nama": "Muhammad Gunawan",
      "nik": "357100715000912",
      "keluarga": "Keluarga Gunawan",
      "jenisKelamin": "Laki-laki",
      "statusDomisili": "Aktif",
      "statusHidup": "Wafat",
    },
    {
      "nama": "Muhammad Syahrul",
      "nik": "357100715000912",
      "keluarga": "Keluarga Gunawan",
      "jenisKelamin": "Laki-laki",
      "statusDomisili": "Aktif",
      "statusHidup": "Hidup",
    },
    {
      "nama": "Oltha Rosyeda",
      "nik": "357100715000546",
      "keluarga": "Keluarga Alhaq",
      "jenisKelamin": "Perempuan",
      "statusDomisili": "Aktif",
      "statusHidup": "Hidup",
    },
    {
      "nama": "Lutfhi Triang",
      "nik": "357100715000235",
      "keluarga": "Keluarga Luthfi",
      "jenisKelamin": "Laki-laki",
      "statusDomisili": "Aktif",
      "statusHidup": "Hidup",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Warga")),
      drawer: const AppSidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tombol atas (Filter & Cetak)
            LayoutBuilder(
              builder: (context, constraints) {
                final filterButton = ElevatedButton.icon(
                  onPressed: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (_) => const FilterWargaDialog(),
                    );
                    if (result != null) {
                      debugPrint("Filter dipilih: $result");
                    }
                  },
                  icon: const Icon(Icons.filter_alt, color: Colors.white),
                  label: const Text("Filter"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.yellowMediumDark,
                    foregroundColor: Colors.white,
                  ),
                );

                final cetakButton = ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                  label: const Text(
                    "Cetak",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppTheme.redDark,
                  ),
                );

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tombol Filter di kiri
                    filterButton,

                    // Tombol Cetak di kanan
                    cetakButton,
                  ],
                );
              },
            ),

            const SizedBox(height: 16),

            /// 🔹 Daftar Warga
            Expanded(
              child: ListView.builder(
                itemCount: warga.length,
                itemBuilder: (context, index) {
                  final item = warga[index];
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: AppTheme.grayLight,
                        width: 1.5,
                      ),
                    ),
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['nama'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(item['nik'],
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey[700])),
                                Text(item['keluarga'],
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey[700])),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _buildStatusChip(item['statusDomisili']),
                                    const SizedBox(width: 6),
                                    _buildStatusChip(item['statusHidup']),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert,
                                color: AppTheme.primaryBlue),
                            onSelected: (value) {
                              if (value == 'detail') {
                                showDialog(
                                  context: context,
                                  builder: (_) =>
                                      DetailWargaDialog(warga: item),
                                );
                              } else if (value == 'edit') {
                                showDialog(
                                  context: context,
                                  builder: (_) => EditWargaDialog(warga: item),
                                );
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'detail',
                                child: Row(
                                  children: [
                                    Icon(Icons.visibility, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text("Detail"),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: Colors.orange),
                                    SizedBox(width: 8),
                                    Text("Edit"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Tombol Aksi
  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  /// 🔹 Chip Status
  Widget _buildStatusChip(String status) {
    final bool isActive =
        status.toLowerCase() == "aktif" || status.toLowerCase() == "hidup";
    final Color bgColor =
        isActive ? AppTheme.greenExtraLight : AppTheme.redExtraLight;
    final Color textColor =
        isActive ? AppTheme.greenSuperDark : AppTheme.redDark;
    final Color borderColor = isActive ? AppTheme.greenDark : AppTheme.redDark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// =======================================================
/// 🔹 Dialog Filter (berdasarkan contoh FilterFormDialog)
/// =======================================================
class FilterWargaDialog extends StatefulWidget {
  const FilterWargaDialog({super.key});

  @override
  State<FilterWargaDialog> createState() => _FilterWargaDialogState();
}

class _FilterWargaDialogState extends State<FilterWargaDialog> {
  final TextEditingController _namaController = TextEditingController();
  String? selectedStatus;
  String? selectedGender;
  DateTime? startDate;
  DateTime? endDate;

  final List<String> statusList = ["Semua", "Aktif", "Tidak Aktif"];
  final List<String> genderList = ["Semua", "Laki-laki", "Perempuan"];

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  void _resetFilter() {
    setState(() {
      _namaController.clear();
      selectedStatus = null;
      selectedGender = null;
      startDate = null;
      endDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Filter Data Warga",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Nama Warga"),
            const SizedBox(height: 6),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                hintText: "Cari nama...",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 12),
            const Text("Jenis Kelamin"),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: selectedGender,
              items: genderList.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: "-- Pilih Jenis Kelamin --",
              ),
            ),
            const SizedBox(height: 12),
            const Text("Status Domisili"),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              items: statusList.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedStatus = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: "-- Pilih Status Domisili --",
              ),
            ),
            const SizedBox(height: 12),
            const Text("Dari Tanggal"),
            const SizedBox(height: 6),
            InkWell(
              onTap: () => _selectDate(context, true),
              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                child: Text(
                  startDate != null
                      ? "${startDate!.day}/${startDate!.month}/${startDate!.year}"
                      : "--/--/----",
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text("Sampai Tanggal"),
            const SizedBox(height: 6),
            InkWell(
              onTap: () => _selectDate(context, false),
              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                child: Text(
                  endDate != null
                      ? "${endDate!.day}/${endDate!.month}/${endDate!.year}"
                      : "--/--/----",
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _resetFilter,
          child: const Text("Reset"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Terapkan"),
        ),
      ],
    );
  }
}
