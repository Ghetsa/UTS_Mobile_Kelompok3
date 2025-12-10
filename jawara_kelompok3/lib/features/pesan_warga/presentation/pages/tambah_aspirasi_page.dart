import 'package:flutter/material.dart';
import '../../../../core/layout/header.dart';
import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/pesan_warga_model.dart';
import '../../data/services/pesan_warga_service.dart';

class TambahAspirasiPage extends StatefulWidget {
  const TambahAspirasiPage({super.key});

  @override
  State<TambahAspirasiPage> createState() => _TambahAspirasiPageState();
}

class _TambahAspirasiPageState extends State<TambahAspirasiPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();
  final TextEditingController _kategoriController = TextEditingController();

  final PesanWargaService _service = PesanWargaService();

  @override
  void dispose() {
    _namaController.dispose();
    _isiController.dispose();
    _kategoriController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    // generate ID unik
    final generatedId = "ASP-${DateTime.now().millisecondsSinceEpoch}";

    final newAspirasi = PesanWargaModel(
      docId: '', // Firestore akan generate docId otomatis
      idPesan: generatedId, // gunakan ID yang baru dibuat
      nama: _namaController.text,
      isiPesan: _isiController.text,
      kategori: _kategoriController.text,
      status: 'Pending',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final success = await _service.tambahPesanDariModel(newAspirasi);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Aspirasi berhasil ditambahkan!"),
          backgroundColor: Color(0xFF48B0E0),
        ),
      );
      _handleReset();
      Navigator.pop(context); // kembali ke daftar aspirasi
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menambahkan aspirasi!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleReset() {
    setState(() {});
    _formKey.currentState!.reset();
    _namaController.clear();
    _isiController.clear();
    _kategoriController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Form berhasil di-reset!"),
        backgroundColor: Color(0xFF48B0E0),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildTextFormField(String label, String hint,
      {required TextEditingController controller, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white, width: 2)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: (value) {
            if (value == null || value.isEmpty)
              return 'Field $label wajib diisi.';
            return null;
          },
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F2F9),
      drawer: const AppSidebar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainHeader(
              title: "Tambah Aspirasi",
              showSearchBar: false,
              showFilterButton: false,
              onSearch: (_) {},
              onFilter: () {},
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Buat Aspirasi Baru",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Color(0xFF48B0E0)),
                            ),
                          ),
                          const SizedBox(height: 30),
                          _buildTextFormField(
                              "Nama Warga", "Masukkan nama warga",
                              controller: _namaController),
                          _buildTextFormField("Isi Pesan", "Tulis aspirasi...",
                              controller: _isiController, maxLines: 4),
                          _buildTextFormField(
                              "Kategori", "Contoh: Infrastruktur",
                              controller: _kategoriController),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _handleSubmit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF48B0E0),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  ),
                                  child: const Text("Simpan",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _handleReset,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  ),
                                  child: const Text("Reset",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
}
