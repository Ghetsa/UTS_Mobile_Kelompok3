import 'package:flutter/material.dart';
import '../../../../../core/layout/header.dart';

// Service & Model
import '../../../data/services/keluarga_service.dart';
import '../../../data/services/rumah_service.dart';
import '../../../data/models/rumah_model.dart';

class TambahKeluargaPage extends StatefulWidget {
  const TambahKeluargaPage({super.key});

  @override
  State<TambahKeluargaPage> createState() => _TambahKeluargaPageState();
}

class _TambahKeluargaPageState extends State<TambahKeluargaPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _kepalaC = TextEditingController();
  final TextEditingController _noKkC = TextEditingController();
  final TextEditingController _jumlahAnggotaC = TextEditingController();

  // Rumah dropdown
  final RumahService _rumahService = RumahService();
  final KeluargaService _keluargaService = KeluargaService();

  List<RumahModel> _listRumah = [];
  String? _selectedRumahDocId;

  bool _loadingSubmit = false;
  bool _loadingRumah = true;

  @override
  void initState() {
    super.initState();
    _loadRumah();
  }

  Future<void> _loadRumah() async {
    final result = await _rumahService.getAllRumah();
    setState(() {
      _listRumah = result;
      _loadingRumah = false;
    });
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedRumahDocId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih rumah")),
      );
      return;
    }

    setState(() => _loadingSubmit = true);

    final payload = {
      "kepala_keluarga": _kepalaC.text.trim(),
      "no_kk": _noKkC.text.trim(),
      "id_rumah": _selectedRumahDocId,
      "jumlah_anggota": _jumlahAnggotaC.text.trim(),
    };

    final ok = await _keluargaService.addKeluarga(payload);

    setState(() => _loadingSubmit = false);

    if (!mounted) return;

    if (ok) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menyimpan data"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Informasi Keluarga",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _kepalaC,
                          decoration: _inputDecoration("Nama Kepala Keluarga"),
                          validator: (v) =>
                              v == null || v.isEmpty ? "Wajib diisi" : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _noKkC,
                          decoration: _inputDecoration("Nomor KK"),
                          validator: (v) =>
                              v == null || v.isEmpty ? "Wajib diisi" : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _jumlahAnggotaC,
                          decoration: _inputDecoration("Jumlah Anggota"),
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              v == null || v.isEmpty ? "Wajib diisi" : null,
                        ),
                        const SizedBox(height: 16),

                        const Text(
                          "Pilih Rumah",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),

                        _loadingRumah
                            ? const LinearProgressIndicator()
                            : DropdownButtonFormField<String>(
                                value: _selectedRumahDocId,
                                isExpanded: true,
                                decoration: _inputDecoration("Pilih rumah"),
                                items: _listRumah.map((r) {
                                  return DropdownMenuItem(
                                    value: r.id,
                                    child: Text("${r.nomor} • ${r.alamat}"),
                                  );
                                }).toList(),
                                onChanged: (v) =>
                                    setState(() => _selectedRumahDocId = v),
                                validator: (v) =>
                                    v == null ? "Pilih rumah" : null,
                              ),

                        const SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _loadingSubmit ? null : _simpan,
                            child: _loadingSubmit
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text("Simpan"),
                          ),
                        )
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
}
