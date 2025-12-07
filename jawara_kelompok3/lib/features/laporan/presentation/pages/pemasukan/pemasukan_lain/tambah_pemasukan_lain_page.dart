import 'package:flutter/material.dart';

import '../../../../../../core/layout/header.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../data/services/pemasukan_lain_service.dart';

class PemasukanLainTambahPage extends StatefulWidget {
  const PemasukanLainTambahPage({super.key});

  @override
  State<PemasukanLainTambahPage> createState() =>
      _PemasukanLainTambahPageState();
}

class _PemasukanLainTambahPageState extends State<PemasukanLainTambahPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();
  DateTime? _selectedDate;
  String? _kategori;
  bool _loadingSubmit = false;

  final PemasukanLainService _service = PemasukanLainService();

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF4F8FB),
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Future<void> _simpan() async {
    // Validasi form teks
    if (_namaController.text.trim().isEmpty ||
        _nominalController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama dan nominal wajib diisi")),
      );
      return;
    }

    setState(() => _loadingSubmit = true);
    print('[_simpan] Mulai simpan pemasukan lain TANPA foto...');

    try {
      // Data yang akan disimpan ke Firestore
      final data = {
        'nama': _namaController.text.trim(),
        'jenis': _kategori ?? 'Pendapatan Lainnya',
        'tanggal': _selectedDate != null
            ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
            : '--/--/----',
        'nominal': _nominalController.text.trim(),
        // tidak ada bukti_url
      };

      print('[_simpan] Kirim ke Firestore...');
      final bool success = await _service.add(data);
      print('[_simpan] Firestore selesai: success = $success');

      if (!mounted) return;

      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menambahkan data")),
        );
      }
    } catch (e) {
      print('[_simpan] ERROR: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Terjadi kesalahan: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loadingSubmit = false);
      }
      print('[_simpan] Selesai (finally).');
    }
  }

  void _resetForm() {
    _namaController.clear();
    _nominalController.clear();
    setState(() {
      _selectedDate = null;
      _kategori = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      drawer: const AppSidebar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainHeader(
              title: "Pemasukan Lain - Tambah",
              showSearchBar: false,
              showFilterButton: false,
            ),
            const SizedBox(height: 18),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Buat Pemasukan Non Iuran Baru",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),

                      // Nama
                      TextField(
                        controller: _namaController,
                        decoration: _inputDecoration("Nama Pemasukan"),
                      ),
                      const SizedBox(height: 12),

                      // Tanggal (picker)
                      const Text(
                        "Tanggal Pemasukan",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => _selectedDate = picked);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F8FB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _selectedDate == null
                                      ? "--/--/----"
                                      : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const Icon(Icons.calendar_today, size: 18),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Kategori
                      DropdownButtonFormField<String>(
                        value: _kategori,
                        decoration: _inputDecoration("Kategori Pemasukan"),
                        items: ["Pendapatan Lainnya", "Donasi", "Sumbangan"]
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _kategori = v),
                      ),

                      const SizedBox(height: 12),

                      // Nominal
                      TextField(
                        controller: _nominalController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration("Nominal"),
                      ),

                      const SizedBox(height: 20),

                      // Tombol: Simpan + Reset
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 46,
                              child: ElevatedButton(
                                onPressed: _loadingSubmit ? null : _simpan,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _loadingSubmit
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text("Submit"),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 46,
                              child: OutlinedButton(
                                onPressed: _resetForm,
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      color: Colors.grey.shade300),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text("Reset"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
