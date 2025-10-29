import 'package:flutter/material.dart';
import '../../Layout/sidebar.dart';
import '../../theme/app_theme.dart';

class TambahKegiatanPage extends StatefulWidget {
  const TambahKegiatanPage({super.key});

  @override
  State<TambahKegiatanPage> createState() => _TambahKegiatanPageState();
}

class _TambahKegiatanPageState extends State<TambahKegiatanPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  DateTime? _selectedDate;
  String? _kategori;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Kegiatan Baru"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const AppSidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          color: theme.colorScheme.background,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(
                  "Form Jadwal Kegiatan",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),

                // Nama Kegiatan
                TextField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: "Nama Kegiatan",
                    hintText: "Masukkan nama kegiatan",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Tanggal
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: "Tanggal Kegiatan",
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
                        icon: Icon(Icons.calendar_today, color: theme.iconTheme.color),
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
                  items: ["Rapat", "Gotong Royong", "Peringatan Hari Besar", "Sosialisasi"]
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
                  controller: _lokasiController,
                  decoration: const InputDecoration(
                    labelText: "Lokasi Kegiatan",
                    hintText: "Masukkan lokasi kegiatan",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Upload Dokumentasi
                Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.secondary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Upload dokumentasi kegiatan (.png/.jpg)",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Tombol
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {},
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
                        _lokasiController.clear();
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
