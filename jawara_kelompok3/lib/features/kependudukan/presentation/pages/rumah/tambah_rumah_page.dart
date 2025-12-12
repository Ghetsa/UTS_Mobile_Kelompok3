import 'package:flutter/material.dart';
import '../../../../../core/layout/header.dart';
import '../../../../../core/theme/app_theme.dart';

import '../../../data/models/rumah_model.dart';
import '../../../data/services/rumah_service.dart';

class TambahRumahPage extends StatefulWidget {
  const TambahRumahPage({super.key});

  @override
  State<TambahRumahPage> createState() => _TambahRumahPageState();
}

class _TambahRumahPageState extends State<TambahRumahPage> {
  final _alamatC = TextEditingController();
  final _nomorC = TextEditingController();
  final _rtC = TextEditingController();
  final _rwC = TextEditingController();

  String? _statusRumah = "Dihuni";
  String? _kepemilikan = "Pemilik";

  final RumahService _service = RumahService();
  bool _loading = false;

  Future<void> _save() async {
    if (_alamatC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Alamat wajib diisi")),
      );
      return;
    }

    if (_nomorC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nomor rumah wajib diisi")),
      );
      return;
    }

    setState(() => _loading = true);

    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final rumah = RumahModel(
      docId: "",
      id: id,
      alamat: _alamatC.text.trim(),
      nomor: _nomorC.text.trim(),
      statusRumah: _statusRumah ?? "Dihuni",
      kepemilikan: _kepemilikan ?? "Pemilik",
      rt: _rtC.text.trim().isEmpty ? "1" : _rtC.text.trim(),
      rw: _rwC.text.trim().isEmpty ? "1" : _rwC.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final ok = await _service.addRumah(rumah);

    setState(() => _loading = false);

    if (!mounted) return;

    if (ok) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menambah rumah")),
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
            const MainHeader(
              title: "Tambah Rumah",
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
                      const Text(
                        "Informasi Rumah",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextField(
                        controller: _alamatC,
                        decoration: _inputDecoration("Alamat rumah"),
                      ),
                      const SizedBox(height: 16),

                      TextField(
                        controller: _nomorC,
                        decoration: _inputDecoration(
                          "Nomor Rumah (contoh: 01, 1A, 12B)",
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _rtC,
                              decoration: _inputDecoration("RT"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _rwC,
                              decoration: _inputDecoration("RW"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: _statusRumah,
                        decoration: _inputDecoration("Status Rumah")
                            .copyWith(labelText: "Status Rumah"),
                        items: const [
                          DropdownMenuItem(
                              value: "Dihuni", child: Text("Dihuni")),
                          DropdownMenuItem(
                              value: "Kosong", child: Text("Kosong")),
                          DropdownMenuItem(
                              value: "Renovasi", child: Text("Renovasi")),
                        ],
                        onChanged: (v) => setState(() => _statusRumah = v),
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: _kepemilikan,
                        decoration: _inputDecoration("Kepemilikan")
                            .copyWith(labelText: "Kepemilikan"),
                        items: const [
                          DropdownMenuItem(
                              value: "Pemilik", child: Text("Pemilik")),
                          DropdownMenuItem(
                              value: "Penyewa", child: Text("Penyewa")),
                          DropdownMenuItem(
                              value: "Kosong", child: Text("Kosong")),
                        ],
                        onChanged: (v) => setState(() => _kepemilikan = v),
                      ),

                      const SizedBox(height: 28),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFC107),
                                foregroundColor: Colors.black,
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Kembali"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFC107),
                                foregroundColor: Colors.black,
                              ),
                              onPressed: _loading ? null : _save,
                              child: _loading
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: Colors.black),
                                    )
                                  : const Text("Simpan"),
                            ),
                          ),
                        ],
                      )
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
