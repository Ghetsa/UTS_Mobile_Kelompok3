import 'package:flutter/material.dart';
import '../../../../../core/layout/header.dart';
import '../../../../../core/theme/app_theme.dart';

import '../../data/models/kegiatan_model.dart';
import '../../data/services/kegiatan_service.dart';
import '../../presentation/widgets/kegiatan_card.dart';
import '../../presentation/widgets/kegiatan_filter.dart';

class TambahKegiatanPage extends StatefulWidget {
  const TambahKegiatanPage({super.key});

  @override
  State<TambahKegiatanPage> createState() => _TambahKegiatanPageState();
}

class _TambahKegiatanPageState extends State<TambahKegiatanPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaC = TextEditingController();
  final TextEditingController _lokasiC = TextEditingController();
  final TextEditingController _pjC = TextEditingController();
  final TextEditingController _ketC = TextEditingController();

  String? _kategori = "Komunitas & Sosial";
  String _status = "rencana";

  DateTime? _tglMulai = DateTime.now();
  DateTime? _tglSelesai;

  bool _loadingSubmit = false;

  final KegiatanService _service = KegiatanService();

  final List<String> kategoriList = const [
    "Komunitas & Sosial",
    "Keamanan",
    "Keagamaan",
    "Pendidikan",
    "Olahraga",
  ];

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

  Future<void> _pickTanggalMulai() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _tglMulai ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() => _tglMulai = picked);
    }
  }

  Future<void> _pickTanggalSelesai() async {
    final base = _tglMulai ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _tglSelesai ?? base,
      firstDate: base,
      lastDate: DateTime(base.year + 5),
    );
    if (picked != null) {
      setState(() => _tglSelesai = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loadingSubmit = true);

    final now = DateTime.now();

    final keg = KegiatanModel(
      uid: "",
      nama: _namaC.text.trim(),
      kategori: _kategori ?? "",
      lokasi: _lokasiC.text.trim(),
      penanggungJawab: _pjC.text.trim(),
      status: _status,
      keterangan: _ketC.text.trim(),
      tanggalMulai: _tglMulai ?? now,
      tanggalSelesai: _tglSelesai,
      createdAt: now,
      updatedAt: now,
    );

    final ok = await _service.addKegiatan(keg);

    setState(() => _loadingSubmit = false);

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kegiatan berhasil disimpan."),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menyimpan kegiatan."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDate(DateTime? d) {
    if (d == null) return '--/--/----';
    return "${d.day.toString().padLeft(2, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.year}";
  }

  @override
  void dispose() {
    _namaC.dispose();
    _lokasiC.dispose();
    _pjC.dispose();
    _ketC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F2F9),
      body: SafeArea(
        child: Column(
          children: [
            const MainHeader(
              title: "Tambah Kegiatan",
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
                          "Informasi Kegiatan",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _namaC,
                          decoration: _inputDecoration("Nama Kegiatan"),
                          validator: (v) => v == null || v.isEmpty
                              ? "Nama wajib diisi"
                              : null,
                        ),
                        const SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          value: _kategori,
                          decoration: _inputDecoration("Kategori")
                              .copyWith(labelText: "Kategori"),
                          items: kategoriList
                              .map((k) =>
                                  DropdownMenuItem(value: k, child: Text(k)))
                              .toList(),
                          onChanged: (v) => setState(() => _kategori = v),
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _lokasiC,
                          decoration: _inputDecoration("Lokasi"),
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _pjC,
                          decoration:
                              _inputDecoration("Penanggung Jawab"),
                        ),
                        const SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          value: _status,
                          decoration: _inputDecoration("Status")
                              .copyWith(labelText: "Status"),
                          items: const [
                            DropdownMenuItem(
                                value: "rencana", child: Text("Rencana")),
                            DropdownMenuItem(
                                value: "berjalan", child: Text("Berjalan")),
                            DropdownMenuItem(
                                value: "selesai", child: Text("Selesai")),
                            DropdownMenuItem(
                                value: "batal", child: Text("Batal")),
                          ],
                          onChanged: (v) =>
                              setState(() => _status = v ?? "rencana"),
                        ),
                        const SizedBox(height: 16),

                        // Tanggal mulai
                        InputDecorator(
                          decoration: _inputDecoration("Tanggal Mulai")
                              .copyWith(labelText: "Tanggal Mulai"),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(_formatDate(_tglMulai)),
                              ),
                              IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: _pickTanggalMulai,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Tanggal selesai
                        InputDecorator(
                          decoration: _inputDecoration("Tanggal Selesai")
                              .copyWith(
                                  labelText: "Tanggal Selesai (opsional)"),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(_formatDate(_tglSelesai)),
                              ),
                              IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: _pickTanggalSelesai,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _ketC,
                          maxLines: 3,
                          decoration: _inputDecoration("Keterangan (opsional)"),
                        ),
                        const SizedBox(height: 28),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Kembali"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppTheme.blueMediumLight,
                                  foregroundColor: Colors.black,
                                ),
                                onPressed: _loadingSubmit ? null : _submit,
                                child: _loadingSubmit
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.black,
                                        ),
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
            ),
          ],
        ),
      ),
    );
  }
}
