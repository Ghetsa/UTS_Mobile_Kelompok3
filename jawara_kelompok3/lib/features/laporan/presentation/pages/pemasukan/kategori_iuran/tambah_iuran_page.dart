import 'package:flutter/material.dart';
import '../../../../../../main.dart';
import '../../../../../../core/layout/header.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../widgets/card/pemasukan_lain_card.dart';
import '../../../../data/models/kategori_iuran_model.dart';

import '../../../../data/services/kategori_iuran_service.dart';

class TambahKategoriPage extends StatefulWidget {
  const TambahKategoriPage({super.key});

  @override
  State<TambahKategoriPage> createState() => _TambahKategoriPageState();
}

class _TambahKategoriPageState extends State<TambahKategoriPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nominalController = TextEditingController();
  bool _loadingSubmit = false;
  final KategoriIuranService _service = KategoriIuranService();

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF4F8FB),
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loadingSubmit = true);

    final nominal = int.tryParse(nominalController.text.trim());

    if (nominal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nominal harus berupa angka"), backgroundColor: Colors.red),
      );
      setState(() => _loadingSubmit = false);
      return;
    }

    final payload = {
      "nama": namaController.text.trim(),
      "jenis": "Iuran",
      "nominal": nominal.toString(),
    };

    final ok = await _service.add(payload);

    setState(() => _loadingSubmit = false);

    if (!mounted) return;

    if (ok) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menyimpan data"), backgroundColor: Colors.red),
      );
    }
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
              title: "Tambah Kategori Iuran",
              showSearchBar: false,
              showFilterButton: false,
            ),
            const SizedBox(height: 8),

            const SizedBox(height: 8),

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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Informasi Kategori Iuran",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: namaController,
                          decoration: _inputDecoration("Nama Iuran"),
                          validator: (v) =>
                              v == null || v.isEmpty ? "Wajib diisi" : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: nominalController,
                          decoration: _inputDecoration("Nominal"),
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              v == null || v.isEmpty ? "Wajib diisi" : null,
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _loadingSubmit ? null : _simpan,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:  const Color(0xFF0C88C2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _loadingSubmit
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Simpan",
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                      context, '/pemasukan/pages/kategori');
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                label: const Text(
                  "Kembali",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C88C2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



