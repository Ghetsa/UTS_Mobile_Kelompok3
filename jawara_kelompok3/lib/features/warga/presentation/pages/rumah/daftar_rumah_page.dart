import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/layout/sidebar.dart';
import 'detail_rumah_page.dart';
import 'edit_rumah_page.dart';

class DaftarRumahPage extends StatefulWidget {
  const DaftarRumahPage({super.key});

  @override
  State<DaftarRumahPage> createState() => _DaftarRumahPageState();
}

class _DaftarRumahPageState extends State<DaftarRumahPage> {
  final List<Map<String, dynamic>> rumah = [
    {
      "no": 1,
      "alamat": "Jl. Merbabu No.12",
      "status": "Ditempati",
      "kepemilikan": "Pemilik",
      "penghuni": "Keluarga Budi Santoso"
    },
    {
      "no": 2,
      "alamat": "Jl. Ikan Arwana 5A",
      "status": "Tersedia",
      "kepemilikan": "Kosong",
      "penghuni": "-"
    },
    {
      "no": 3,
      "alamat": "Griyashanta L203",
      "status": "Ditempati",
      "kepemilikan": "Penyewa",
      "penghuni": "Keluarga Siti Aminah"
    },
    {
      "no": 4,
      "alamat": "Jl. Suhat No. 7",
      "status": "Ditempati",
      "kepemilikan": "Pemilik",
      "penghuni": "Keluarga Wawan"
    },
    {
      "no": 5,
      "alamat": "Jl. Tlogomas Indah 22",
      "status": "Tersedia",
      "kepemilikan": "Kosong",
      "penghuni": "-"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      appBar: AppBar(
        title: const Text("Daftar Rumah"),
        backgroundColor: AppTheme.primaryBlue,
      ),
      drawer: const AppSidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔹 Tombol atas (Filter & Cetak)
            LayoutBuilder(
              builder: (context, constraints) {
                final filterButton = ElevatedButton.icon(
                  onPressed: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (_) => const FilterRumahDialog(),
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
                    filterButton,
                    cetakButton,
                  ],
                );
              },
            ),

            const SizedBox(height: 16),

            /// 🔹 Daftar Rumah
            Expanded(
              child: ListView.builder(
                itemCount: rumah.length,
                itemBuilder: (context, index) {
                  final item = rumah[index];
                  final bool isTersedia = item['status'] == 'Tersedia';

                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: AppTheme.grayMediumLight,
                        width: 1,
                      ),
                    ),
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// HEADER (Nomor + Aksi)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "#${item['no'].toString().padLeft(2, '0')}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.blueMediumLight,
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
                                          DetailRumahDialog(rumah: item),
                                    );
                                  } else if (value == 'edit') {
                                    showDialog(
                                      context: context,
                                      builder: (_) =>
                                          EditRumahDialog(rumah: item),
                                    );
                                  }
                                },
                                itemBuilder: (context) => const [
                                  PopupMenuItem(
                                    value: 'detail',
                                    child: Row(
                                      children: [
                                        Icon(Icons.visibility,
                                            color: Colors.blue),
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
                          const SizedBox(height: 6),
                          Divider(
                            color: Colors.grey.shade300,
                            height: 1,
                          ),
                          const SizedBox(height: 10),

                          /// ALAMAT
                          Text(
                            item['alamat'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),

                          /// PENGHUNI & KEPEMILIKAN
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.people_alt_outlined,
                                  size: 18, color: Colors.grey),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  item['penghuni'],
                                  style: const TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.home_work_outlined,
                                  size: 18, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text(
                                item['kepemilikan'],
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          /// STATUS
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: isTersedia
                                    ? AppTheme.greenExtraLight
                                    : AppTheme.blueExtraLight,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isTersedia
                                      ? AppTheme.greenDark
                                      : AppTheme.primaryBlue,
                                  width: 0.8,
                                ),
                              ),
                              child: Text(
                                item['status'],
                                style: TextStyle(
                                  color: isTersedia
                                      ? AppTheme.greenSuperDark
                                      : AppTheme.blueDark,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
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
}

/// =======================================================
/// 🔹 Dialog Filter Rumah
/// =======================================================
class FilterRumahDialog extends StatefulWidget {
  const FilterRumahDialog({super.key});

  @override
  State<FilterRumahDialog> createState() => _FilterRumahDialogState();
}

class _FilterRumahDialogState extends State<FilterRumahDialog> {
  final TextEditingController _penghuniController = TextEditingController();
  String? selectedStatus;
  String? selectedKepemilikan;

  final List<String> statusList = ["Semua", "Ditempati", "Tersedia"];
  final List<String> kepemilikanList = [
    "Semua",
    "Pemilik",
    "Penyewa",
    "Kosong"
  ];

  void _resetFilter() {
    setState(() {
      _penghuniController.clear();
      selectedStatus = null;
      selectedKepemilikan = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Filter Data Rumah",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Nama Penghuni"),
            const SizedBox(height: 6),
            TextField(
              controller: _penghuniController,
              decoration: InputDecoration(
                hintText: "Cari nama penghuni...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text("Status Rumah"),
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
                hintText: "-- Pilih Status Rumah --",
              ),
            ),
            const SizedBox(height: 12),
            const Text("Status Kepemilikan"),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: selectedKepemilikan,
              items: kepemilikanList.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedKepemilikan = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: "-- Pilih Status Kepemilikan --",
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
            Navigator.pop(context, {
              "penghuni": _penghuniController.text,
              "status": selectedStatus,
              "kepemilikan": selectedKepemilikan,
            });
          },
          child: const Text("Terapkan"),
        ),
      ],
    );
  }
}
