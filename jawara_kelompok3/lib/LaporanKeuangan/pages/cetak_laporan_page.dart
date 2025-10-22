import 'package:flutter/material.dart';
import '../../layout/sidebar.dart';
import '../../theme/app_theme.dart';

class CetakLaporanPage extends StatefulWidget {
  const CetakLaporanPage({super.key});

  @override
  State<CetakLaporanPage> createState() => _CetakLaporanPageState();
}

class _CetakLaporanPageState extends State<CetakLaporanPage> {
  DateTime? startDate;
  DateTime? endDate;
  String selectedJenis = "Semua";

  final List<String> jenisLaporan = ["Semua", "Pemasukan", "Pengeluaran"];

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

  void _resetForm() {
    setState(() {
      startDate = null;
      endDate = null;
      selectedJenis = "Semua";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cetak Laporan Keuangan")),
      drawer: const AppSidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Cetak Laporan Keuangan",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // === Tanggal Mulai & Akhir ===
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Tanggal Mulai", style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => _selectDate(context, true),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                suffixIcon: const Icon(Icons.calendar_today),
                              ),
                              child: Text(
                                startDate != null
                                    ? "${startDate!.day}/${startDate!.month}/${startDate!.year}"
                                    : "Pilih Tanggal",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Tanggal Akhir", style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => _selectDate(context, false),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                suffixIcon: const Icon(Icons.calendar_today),
                              ),
                              child: Text(
                                endDate != null
                                    ? "${endDate!.day}/${endDate!.month}/${endDate!.year}"
                                    : "Pilih Tanggal",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // === Jenis Laporan ===
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Jenis Laporan", style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedJenis,
                      items: jenisLaporan.map((jenis) {
                        return DropdownMenuItem(
                          value: jenis,
                          child: Text(jenis),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedJenis = value!;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // === Tombol ===
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: implement download pdf
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Download PDF...")),
                        );
                      },
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text("Download PDF"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.redDark,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.blueSuperDark,
                        side: const BorderSide(color: AppTheme.blueSuperDark),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                      onPressed: _resetForm,
                      child: const Text("Reset"),
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
}
