import 'package:flutter/material.dart';
import '../../main.dart';

class TagihIuranPage extends StatefulWidget {
  const TagihIuranPage({super.key});

  @override
  State<TagihIuranPage> createState() => _TagihIuranPageState();
}

class _TagihIuranPageState extends State<TagihIuranPage> {
  String? selectedIuran;

  final List<String> iuranList = ["Agustusan", "Mingguan", "Bulanan"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tagih Iuran")),
      drawer: const AppSidebar(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600), // responsive max
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tagih Iuran ke Semua Keluarga Aktif",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Jenis Iuran",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                    ),
                    initialValue: selectedIuran,
                    hint: const Text("-- Pilih Iuran --"),
                    items: iuranList.map((iuran) {
                      return DropdownMenuItem(
                        value: iuran,
                        child: Text(iuran),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedIuran = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // Tombol aksi (pakai Wrap biar responsif)
                  Wrap(
                    spacing: 12,
                    runSpacing: 12, // jarak kalau turun ke bawah
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Tagih iuran: ${selectedIuran ?? 'Belum dipilih'}"),
                            ),
                          );
                        },
                        child: const Text("Tagih Iuran"),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedIuran = null;
                          });
                        },
                        child: const Text("Reset"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
