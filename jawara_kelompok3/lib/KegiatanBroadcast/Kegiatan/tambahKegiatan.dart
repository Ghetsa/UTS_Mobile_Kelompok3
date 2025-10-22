import 'package:flutter/material.dart';
import '../../Layout/sidebar.dart';
import '../../Theme/app_theme.dart';

class TambahkegiatanPage extends StatefulWidget {
  const TambahkegiatanPage({super.key});

  @override
  State<TambahkegiatanPage> createState() => _TambahKegiatanPageState();
}

class _TambahKegiatanPageState extends State<TambahkegiatanPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();
  DateTime? _selectedDate;
  String? _kategori;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kegiatan - Tambah"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const AppSidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          color: theme.colorScheme.background,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(
                  "Buat Kegiatan Baru",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),

                // Nama pengeluaran
                TextField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: "Nama Kegiatan",
                    hintText: "Contoh : Rapat Koordinasi",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Tanggal
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: "Tanggal Pengeluaran",
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? "--/--/----"
                              : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today,
                            color: theme.iconTheme.color),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _selectedDate = pickedDate;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Kategori
                DropdownButtonFormField<String>(
                  value: _kategori,
                  decoration: const InputDecoration(
                    labelText: "Kategori Kegiatan",
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    "Komunitas & Sosial",
                    "Kebersihan & Keamanan",
                    "Pendidikan",
                    "Keagamaan",
                    "Kesehatan & Olahraga",
                    "Lainnya"
                  ]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _kategori = value;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Lokasi
                TextField(
                  controller: _nominalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Lokasi",
                    hintText: "Contoh : Balai RT 03",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Penanggung Jawab
                TextField(
                  controller: _nominalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Penanggung Jawab",
                    hintText: "Contoh : Pak RT atau Bu RW",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Deskripsi
                TextField(
                  controller: _nominalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Deskripsi",
                    hintText:
                        "Tuliskan detail event seperti agenda, keperluan, dll",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),      
                const SizedBox(height: 16),

                // Tombol
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        // Logika simpan
                      },
                      child: const Text("Submit"),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                        side: BorderSide(color: theme.colorScheme.primary),
                      ),
                      onPressed: () {
                        _namaController.clear();
                        _nominalController.clear();
                        setState(() {
                          _selectedDate = null;
                          _kategori = null;
                        });
                      },
                      child: const Text("Reset"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
