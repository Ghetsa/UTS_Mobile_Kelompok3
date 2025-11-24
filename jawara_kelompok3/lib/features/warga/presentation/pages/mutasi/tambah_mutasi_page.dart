import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/layout/sidebar.dart';

class MutasiTambahPage extends StatefulWidget {
  const MutasiTambahPage({super.key});

  @override
  State<MutasiTambahPage> createState() => _MutasiTambahPageState();
}

class _MutasiTambahPageState extends State<MutasiTambahPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  DateTime? _selectedDate;
  String? _jenisMutasi;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data mutasi berhasil disimpan."),
          backgroundColor: Colors.green,
        ),
      );
      _formKey.currentState!.reset();
      setState(() {
        _selectedDate = null;
        _jenisMutasi = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      drawer: const AppSidebar(),
      appBar: AppBar(
        title: const Text("Tambah Mutasi Keluarga"),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text(
                    "Form Tambah Mutasi Keluarga",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: "Nama Kepala Keluarga",
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _jenisMutasi,
                    decoration: const InputDecoration(
                      labelText: "Jenis Mutasi",
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: "Masuk", child: Text("Masuk")),
                      DropdownMenuItem(value: "Keluar", child: Text("Keluar")),
                    ],
                    onChanged: (val) => setState(() => _jenisMutasi = val),
                    validator: (val) =>
                        val == null ? "Pilih jenis mutasi" : null,
                  ),
                  const SizedBox(height: 16),
                  InputDecorator(
                    decoration: const InputDecoration(
                      labelText: "Tanggal Mutasi",
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedDate == null
                                ? "--/--/----"
                                : "${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}",
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() => _selectedDate = picked);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _alamatController,
                    decoration: const InputDecoration(
                      labelText: "Alamat Asal / Tujuan",
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _keteranganController,
                    decoration: const InputDecoration(
                      labelText: "Keterangan Tambahan (opsional)",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _submit,
                        child: const Text("Simpan"),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryBlue,
                          side: const BorderSide(color: AppTheme.primaryBlue),
                        ),
                        onPressed: () {
                          _formKey.currentState?.reset();
                          setState(() {
                            _selectedDate = null;
                            _jenisMutasi = null;
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
