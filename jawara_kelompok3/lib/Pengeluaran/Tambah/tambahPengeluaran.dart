import 'package:flutter/material.dart';
import '../../main.dart';
import '../../Layout/sidebar.dart';
import '../../theme/app_theme.dart';

class TambahPengeluaranPage extends StatefulWidget {
  const TambahPengeluaranPage({super.key});

  @override
  State<TambahPengeluaranPage> createState() => _TambahPengeluaranPageState();
}

class _TambahPengeluaranPageState extends State<TambahPengeluaranPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();
  DateTime? _selectedDate;
  String? _kategori;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Pengeluaran"),
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
                  "Buat Data Pengeluaran Baru",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),

                // Nama Pengeluaran
                TextField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: "Nama Pengeluaran",
                    hintText: "Masukkan nama pengeluaran",
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
                    labelText: "Kategori Pengeluaran",
                    border: OutlineInputBorder(),
                  ),
                  items: ["Operasional", "Perawatan", "Konsumsi", "Transportasi"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _kategori = value;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Nominal
                TextField(
                  controller: _nominalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Nominal Pengeluaran",
                    hintText: "Masukkan nominal pengeluaran",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Upload Bukti
                Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.secondary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Upload bukti pengeluaran (.png/.jpg)",
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
