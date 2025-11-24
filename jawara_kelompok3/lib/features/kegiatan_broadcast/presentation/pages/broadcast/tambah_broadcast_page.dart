import 'package:flutter/material.dart';
import '../../../../../core/layout/header.dart';
import '../../../../../core/layout/sidebar.dart';
import '../../../../../core/theme/app_theme.dart';

class TambahBroadcastPage extends StatefulWidget {
  const TambahBroadcastPage({super.key});

  @override
  State<TambahBroadcastPage> createState() => _TambahBroadcastPageState();
}

class _TambahBroadcastPageState extends State<TambahBroadcastPage> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      drawer: const AppSidebar(),
      appBar: AppBar(
        title: const Text("Broadcast - Tambah"),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
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
                  "Buat Broadcast Baru",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(height: 16),

                // Judul
                TextField(
                  controller: _judulController,
                  decoration: const InputDecoration(
                    labelText: "Judul Broadcast",
                    hintText: "Masukkan judul pesan",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Isi Pesan
                TextField(
                  controller: _isiController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: "Isi Pesan",
                    hintText: "Tulis pesan yang ingin disampaikan",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Tanggal Kirim
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: "Tanggal Kirim",
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? "--/--/----"
                              : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                        ),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.calendar_today, color: Colors.blue),
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
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
                const SizedBox(height: 24),

                // Tombol Aksi
                Row(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.send),
                      label: const Text("Kirim Sekarang"),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryBlue,
                        side: const BorderSide(color: AppTheme.primaryBlue),
                      ),
                      onPressed: () {
                        _judulController.clear();
                        _isiController.clear();
                        setState(() {
                          _selectedDate = null;
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Reset"),
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
