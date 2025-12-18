import 'package:flutter/material.dart';
import '../../../../../core/layout/header.dart';
import '../../../../../core/theme/app_theme.dart';

import '../../../controller/warga_controller.dart';
import '../../../data/models/warga_model.dart';

// 🔹 Import Rumah
import '../../../data/models/rumah_model.dart';
import '../../../data/services/rumah_service.dart';

class TambahWargaPage extends StatefulWidget {
  const TambahWargaPage({
    super.key,
    this.presetRumahDocId,
    this.presetKeluargaDocId,
    this.presetNoKk,
    this.modeBayi = false,
  });

  final String? presetRumahDocId;
  final String? presetKeluargaDocId;
  final String? presetNoKk;
  final bool modeBayi;

  @override
  State<TambahWargaPage> createState() => _TambahWargaPageState();
}

class _TambahWargaPageState extends State<TambahWargaPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController namaC = TextEditingController();
  final TextEditingController nikC = TextEditingController();
  final TextEditingController noKkC = TextEditingController();
  final TextEditingController noHpC = TextEditingController();
  final TextEditingController agamaC = TextEditingController();
  final TextEditingController pendidikanC = TextEditingController();
  final TextEditingController pekerjaanC = TextEditingController();
  final List<String> pekerjaanList = const [
    "Belum bekerja",
    "Pelajar / Mahasiswa",
    "PNS",
    "TNI / POLRI",
    "Karyawan Swasta",
    "Wiraswasta",
    "Petani",
    "Buruh",
    "Ibu Rumah Tangga",
    "Lainnya",
  ];

  String jenisKelamin = "P";
  String statusWarga = "Aktif";
  DateTime? tanggalLahir;

  final wargaController = WargaController();

  // 🔹 Data Rumah untuk dropdown
  final RumahService _rumahService = RumahService();
  List<RumahModel> _listRumah = [];
  String? _selectedRumahDocId;
  bool _loadingRumah = true;

  @override
  void initState() {
    super.initState();
    _loadRumah();

    // preset dari luar (misal dari keluarga)
    if (widget.presetRumahDocId != null) {
      _selectedRumahDocId = widget.presetRumahDocId;
    }
    if (widget.presetNoKk != null && widget.presetNoKk!.isNotEmpty) {
      noKkC.text = widget.presetNoKk!;
    }

    // mode bayi
    if (widget.modeBayi) {
      pendidikanC.text = "Belum sekolah";
      pekerjaanC.text = "Belum bekerja";
      noHpC.text = "";
      nikC.text = ""; // kalau belum ada NIK, user bisa isi nanti
    }
  }

  Future<void> _loadRumah() async {
    final result = await _rumahService.getAllRumah();
    if (!mounted) return;
    setState(() {
      _listRumah = result;
      _loadingRumah = false;
    });
  }

  Future<void> onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedRumahDocId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih rumah terlebih dahulu")),
      );
      return;
    }

    final now = DateTime.now();

    final warga = WargaModel(
      docId: "",
      uid: now.millisecondsSinceEpoch.toString(),
      nama: namaC.text.trim(),
      nik: nikC.text.trim(),
      noKk: noKkC.text.trim(),
      noHp: noHpC.text.trim(),
      agama: agamaC.text.trim(),
      jenisKelamin: jenisKelamin,
      pekerjaan: pekerjaanC.text.trim(),
      pendidikan: pendidikanC.text.trim(),
      idRumah: _selectedRumahDocId!,
      idKeluarga: widget.presetKeluargaDocId ?? "",
      statusWarga: statusWarga,
      tanggalLahir: tanggalLahir ?? now,
      createdAt: now,
      updatedAt: now,
    );

    final success = await wargaController.addWarga(warga);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Warga berhasil ditambahkan")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menambahkan warga"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickTanggalLahir() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: tanggalLahir ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => tanggalLahir = picked);
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
  void dispose() {
    namaC.dispose();
    nikC.dispose();
    noKkC.dispose();
    noHpC.dispose();
    agamaC.dispose();
    pendidikanC.dispose();
    pekerjaanC.dispose();
    super.dispose();
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
              title: widget.modeBayi ? "Tambah Bayi" : "Tambah Warga",
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
                          "Informasi Warga",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: namaC,
                          decoration: _inputDecoration("Nama"),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? "Nama wajib diisi"
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: nikC,
                          decoration: _inputDecoration("NIK"),
                          validator: (v) {
                            // kalau mode bayi, NIK boleh kosong
                            if (widget.modeBayi) return null;
                            return v == null || v.trim().isEmpty
                                ? "NIK wajib diisi"
                                : null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: noKkC,
                          decoration: _inputDecoration("No KK"),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: noHpC,
                          decoration: _inputDecoration("No HP"),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: agamaC.text.isEmpty ? null : agamaC.text,
                          decoration: _inputDecoration("Agama")
                              .copyWith(labelText: "Agama"),
                          items: const [
                            DropdownMenuItem(
                                value: "Islam", child: Text("Islam")),
                            DropdownMenuItem(
                                value: "Kristen", child: Text("Kristen")),
                            DropdownMenuItem(
                                value: "Katolik", child: Text("Katolik")),
                            DropdownMenuItem(
                                value: "Hindu", child: Text("Hindu")),
                            DropdownMenuItem(
                                value: "Buddha", child: Text("Buddha")),
                            DropdownMenuItem(
                                value: "Konghucu", child: Text("Konghucu")),
                            DropdownMenuItem(
                              value: "Kepercayaan YME",
                              child: Text("Kepercayaan YME"),
                            ),
                          ],
                          onChanged: (v) {
                            if (v != null) setState(() => agamaC.text = v);
                          },
                          validator: (v) => v == null || v.isEmpty
                              ? "Agama wajib dipilih"
                              : null,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: pendidikanC.text.isEmpty
                              ? null
                              : pendidikanC.text,
                          decoration: _inputDecoration("Pendidikan")
                              .copyWith(labelText: "Pendidikan"),
                          items: const [
                            DropdownMenuItem(
                                value: "Belum sekolah",
                                child: Text("Belum sekolah")),
                            DropdownMenuItem(value: "SD", child: Text("SD")),
                            DropdownMenuItem(value: "SMP", child: Text("SMP")),
                            DropdownMenuItem(
                                value: "SMA", child: Text("SMA / SMK")),
                            DropdownMenuItem(value: "D3", child: Text("D3")),
                            DropdownMenuItem(value: "D4", child: Text("D4")),
                            DropdownMenuItem(value: "S1", child: Text("S1")),
                            DropdownMenuItem(value: "S2", child: Text("S2")),
                            DropdownMenuItem(value: "S3", child: Text("S3")),
                          ],
                          onChanged: (v) {
                            if (v != null) setState(() => pendidikanC.text = v);
                          },
                          validator: (v) => v == null || v.isEmpty
                              ? "Pendidikan wajib dipilih"
                              : null,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value:
                              pekerjaanC.text.isEmpty ? null : pekerjaanC.text,
                          decoration: _inputDecoration("Pekerjaan")
                              .copyWith(labelText: "Pekerjaan"),
                          items: pekerjaanList
                              .map((p) =>
                                  DropdownMenuItem(value: p, child: Text(p)))
                              .toList(),
                          onChanged: (v) {
                            setState(() => pekerjaanC.text = v ?? '');
                          },
                          validator: (v) => (v == null || v.isEmpty)
                              ? "Pekerjaan wajib dipilih"
                              : null,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Pilih Rumah",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        _loadingRumah
                            ? const LinearProgressIndicator()
                            : DropdownButtonFormField<String>(
                                value: _selectedRumahDocId,
                                isExpanded: true,
                                decoration: _inputDecoration("Pilih Rumah"),
                                items: _listRumah.map((r) {
                                  return DropdownMenuItem(
                                    value: r.docId,
                                    child: Text("No. ${r.nomor} • ${r.alamat}"),
                                  );
                                }).toList(),
                                onChanged: widget.presetRumahDocId != null
                                    ? null
                                    : (v) =>
                                        setState(() => _selectedRumahDocId = v),
                                validator: (v) =>
                                    v == null ? "Rumah wajib dipilih" : null,
                              ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: jenisKelamin,
                          decoration: _inputDecoration("Jenis Kelamin")
                              .copyWith(labelText: "Jenis Kelamin"),
                          items: const [
                            DropdownMenuItem(
                                value: "L", child: Text("Laki-laki")),
                            DropdownMenuItem(
                                value: "P", child: Text("Perempuan")),
                          ],
                          onChanged: (v) {
                            if (v != null) setState(() => jenisKelamin = v);
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: statusWarga,
                          decoration: _inputDecoration("Status Warga")
                              .copyWith(labelText: "Status Warga"),
                          items: const [
                            DropdownMenuItem(
                                value: "Aktif", child: Text("Aktif")),
                            DropdownMenuItem(
                                value: "Nonaktif", child: Text("Nonaktif")),
                          ],
                          onChanged: (v) {
                            if (v != null) setState(() => statusWarga = v);
                          },
                        ),
                        const SizedBox(height: 16),
                        InputDecorator(
                          decoration: _inputDecoration("Tanggal Lahir")
                              .copyWith(labelText: "Tanggal Lahir"),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  tanggalLahir == null
                                      ? "--/--/----"
                                      : "${tanggalLahir!.day.toString().padLeft(2, '0')}-"
                                          "${tanggalLahir!.month.toString().padLeft(2, '0')}-"
                                          "${tanggalLahir!.year}",
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: _pickTanggalLahir,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Kembali"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.blueMediumLight,
                                  foregroundColor: Colors.black,
                                ),
                                onPressed: onSubmit,
                                child: const Text("Simpan"),
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
