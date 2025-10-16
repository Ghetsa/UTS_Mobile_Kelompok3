import 'package:flutter/material.dart';
import '../../Layout/sidebar.dart';
import '../mutasi_model.dart';

class TambahMutasiPage extends StatelessWidget {
  const TambahMutasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mutasi Keluarga"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const AppSidebar(),
      body: const TambahMutasiContent(),
    );
  }
}

class TambahMutasiContent extends StatefulWidget {
  const TambahMutasiContent({super.key});

  @override
  State<TambahMutasiContent> createState() => _TambahMutasiContentState();
}

class _TambahMutasiContentState extends State<TambahMutasiContent> {
  final TextEditingController _alasanController = TextEditingController();
  String? _jenisMutasi;
  String? _keluarga;
  DateTime? _tanggalMutasi;

  @override
  void dispose() {
    _alasanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 3,
        color: theme.colorScheme.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Text(
                "Buat Mutasi Keluarga",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // Jenis Mutasi
              DropdownButtonFormField<String>(
                value: _jenisMutasi,
                decoration: const InputDecoration(
                  labelText: "Jenis Mutasi",
                  hintText: "-- Pilih Jenis Mutasi --",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                      value: "Masuk", child: Text("Masuk Perumahan")),
                  DropdownMenuItem(
                      value: "Keluar", child: Text("Keluar Perumahan")),
                ],
                onChanged: (val) => setState(() => _jenisMutasi = val),
              ),
              const SizedBox(height: 16),

              // Keluarga
              DropdownButtonFormField<String>(
                value: _keluarga,
                decoration: const InputDecoration(
                  labelText: "Keluarga",
                  hintText: "-- Pilih Keluarga --",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                      value: "Keluarga Ghetsa", child: Text("Keluarga Ghetsa")),
                  DropdownMenuItem(
                      value: "Keluarga Syahrul",
                      child: Text("Keluarga Syahrul")),
                  DropdownMenuItem(
                      value: "Keluarga Oltha", child: Text("Keluarga Oltha")),
                  DropdownMenuItem(
                      value: "Keluarga Luthfi", child: Text("Keluarga Luthfi")),
                ],
                onChanged: (val) => setState(() => _keluarga = val),
              ),
              const SizedBox(height: 16),

              // Alasan Mutasi
              TextField(
                controller: _alasanController,
                decoration: const InputDecoration(
                  labelText: "Alasan Mutasi",
                  hintText: "Masukkan alasan disini...",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Tanggal Mutasi
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: "Tanggal Mutasi",
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _tanggalMutasi == null
                            ? "--/--/----"
                            : "${_tanggalMutasi!.day}/${_tanggalMutasi!.month}/${_tanggalMutasi!.year}",
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today_outlined),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            _tanggalMutasi = picked;
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      // Validasi sederhana
                      if (_jenisMutasi != null &&
                          _keluarga != null &&
                          _alasanController.text.isNotEmpty &&
                          _tanggalMutasi != null) {
                        MutasiStorage.daftar.add(
                          Mutasi(
                            jenis: _jenisMutasi!,
                            keluarga: _keluarga!,
                            alasan: _alasanController.text,
                            tanggal: _tanggalMutasi!,
                          ),
                        );
                        Navigator.pushReplacementNamed(
                            context, '/mutasi/daftar');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Lengkapi semua data!')),
                        );
                      }
                    },
                    child: const Text("Simpan"),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      side: const BorderSide(color: Colors.grey),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      setState(() {
                        _jenisMutasi = null;
                        _keluarga = null;
                        _tanggalMutasi = null;
                      });
                      _alasanController.clear();
                    },
                    child: const Text("Reset"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
