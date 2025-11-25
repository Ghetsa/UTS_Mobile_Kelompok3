import 'package:flutter/material.dart';
import '../../../../../core/layout/header.dart';
import '../../../data/services/keluarga_service.dart';

class TambahKeluargaPage extends StatefulWidget {
  const TambahKeluargaPage({super.key});

  @override
  State<TambahKeluargaPage> createState() => _TambahKeluargaPageState();
}

class _TambahKeluargaPageState extends State<TambahKeluargaPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();

  bool _loading = false;

  final KeluargaService _service = KeluargaService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F2F9),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainHeader(
              title: "Tambah Keluarga",
              searchHint: "",
            ),

            const SizedBox(height: 16),

            /// --------------------------------------------------------
            /// 🔥 FORM WRAPPER (Card Putih dengan Shadow)
            /// --------------------------------------------------------
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),

                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Informasi Keluarga",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// NAMA KELUARGA
                        const Text(
                          "Nama Keluarga",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _namaController,
                          decoration: _inputDecoration("Masukkan nama keluarga..."),
                          validator: (v) =>
                              v == null || v.isEmpty ? "Nama keluarga wajib diisi" : null,
                        ),

                        const SizedBox(height: 20),

                        /// ALAMAT
                        const Text(
                          "Alamat",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _alamatController,
                          maxLines: 2,
                          decoration: _inputDecoration("Masukkan alamat..."),
                          validator: (v) =>
                              v == null || v.isEmpty ? "Alamat wajib diisi" : null,
                        ),

                        const SizedBox(height: 32),

                        /// --------------------------------------------------------
                        /// 🔥 BUTTON SIMPAN
                        /// --------------------------------------------------------
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _simpan,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0C88C2),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 3,
                            ),
                            child: _loading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 3),
                                  )
                                : const Text(
                                    "Simpan",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Input Decoration Template
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF4F8FB),
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  /// Action: Simpan Data Keluarga
  void _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final payload = {
      "nama_keluarga": _namaController.text.trim(),
      "alamat": _alamatController.text.trim(),
    };

    final result = await _service.addKeluarga(payload);

    setState(() => _loading = false);

    if (!mounted) return;

    if (result == true) {
      Navigator.pop(context); // kembali ke daftar keluarga
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menyimpan data!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
