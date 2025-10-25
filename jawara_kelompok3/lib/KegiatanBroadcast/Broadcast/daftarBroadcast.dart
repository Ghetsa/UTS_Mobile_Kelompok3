import 'package:flutter/material.dart';
import '../../Layout/sidebar.dart';
import '../../Theme/app_theme.dart';
import 'editBroadcast.dart';
import 'detailBroadcast.dart';

class DaftarBroadcastPage extends StatefulWidget {
  const DaftarBroadcastPage({super.key});

  @override
  State<DaftarBroadcastPage> createState() => _DaftarBroadcastPageState();
}

class _DaftarBroadcastPageState extends State<DaftarBroadcastPage> {
  late List<Map<String, String>> broadcastList;

  @override
  void initState() {
    super.initState();
    broadcastList = [
      {
        "no": "1",
        "judul": "Rapat RW 01",
        "tanggal": "20 Oktober 2025",
        "isi": "Rapat rutin bulanan RW akan diadakan pada hari Minggu.",
        "status": "Terkirim"
      },
      {
        "no": "2",
        "judul": "Kerja Bakti Mingguan",
        "tanggal": "28 Oktober 2025",
        "isi": "Kerja bakti membersihkan taman RT 02, dimulai pukul 07.00.",
        "status": "Dijadwalkan"
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppSidebar(),
      appBar: AppBar(
        title: const Text("Broadcast - Daftar"),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.yellowDark,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: () {},
                icon: const Icon(Icons.filter_alt),
                label: const Text("Filter"),
              ),
            ),
            const SizedBox(height: 16),

            // === List Broadcast ===
            Expanded(
              child: ListView.builder(
                itemCount: broadcastList.length,
                itemBuilder: (context, index) {
                  final item = broadcastList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            children: [
                              const Icon(Icons.campaign,
                                  color: AppTheme.primaryBlue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item["judul"]!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert,
                                    color: AppTheme.primaryBlue),
                                onSelected: (value) async {
                                  if (value == 'detail') {
                                    showDialog(
                                      context: context,
                                      barrierColor:
                                          Colors.black.withOpacity(0.5),
                                      builder: (_) =>
                                          DetailBroadcastDialog(broadcast: item),
                                    );
                                  } else if (value == 'edit') {
                                    final updated =
                                        await showDialog<Map<String, String>>(
                                      context: context,
                                      barrierColor:
                                          Colors.black.withOpacity(0.5),
                                      builder: (_) =>
                                          EditBroadcastDialog(broadcast: item),
                                    );
                                    if (updated != null) {
                                      setState(() {
                                        final i = broadcastList.indexOf(item);
                                        broadcastList[i] = updated;
                                      });
                                    }
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
                                        Text("Lihat Detail"),
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

                          const SizedBox(height: 12),
                          _buildInfoRow("Tanggal", item["tanggal"]!),
                          _buildInfoRow("Isi Pesan", item["isi"]!),
                          _buildInfoRow("Status", item["status"]!),
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

Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(text: value),
        ],
      ),
    ),
  );
}
