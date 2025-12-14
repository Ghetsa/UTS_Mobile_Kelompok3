import 'package:flutter/material.dart';
import '../../../../../core/layout/header.dart';
import '../../../../../core/theme/app_theme.dart';

// THEME / SIDEBAR SUDAH TIDAK DIPAKAI DI SINI
// import '../../../../../core/theme/app_theme.dart';
// import '../../../../../core/layout/sidebar.dart';

// MODEL & SERVICE
import '../../../data/models/mutasi_model.dart';
import '../../../data/services/mutasi_service.dart';
import '../../../data/models/warga_model.dart';
import '../../../data/services/warga_service.dart';

class MutasiTambahPage extends StatefulWidget {
  const MutasiTambahPage({super.key});

  @override
  State<MutasiTambahPage> createState() => _MutasiTambahPageState();
}

class _MutasiTambahPageState extends State<MutasiTambahPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();

  DateTime? _selectedDate = DateTime.now();
  String? _jenisMutasi = "Pindah Keluar";

  final MutasiService _mutasiService = MutasiService();
  final WargaService _wargaService = WargaService();

  List<WargaModel> _listWarga = [];
  String? _selectedWargaId;

  bool _loadingWarga = true;
  bool _loadingSubmit = false;

  @override
  void initState() {
    super.initState();
    _loadWarga();
  }

  Future<void> _loadWarga() async {
    final data = await _wargaService.getAllWarga();
    setState(() {
      _listWarga = data;
      _loadingWarga = false;
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedWargaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Silakan pilih warga terlebih dahulu."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _loadingSubmit = true);

    final ket = _keteranganController.text.trim();
    final alamat = _alamatController.text.trim();
    String keteranganFinal;

    if (ket.isEmpty && alamat.isEmpty) {
      keteranganFinal = "";
    } else if (ket.isEmpty && alamat.isNotEmpty) {
      keteranganFinal = "Alamat: $alamat";
    } else if (ket.isNotEmpty && alamat.isEmpty) {
      keteranganFinal = ket;
    } else {
      keteranganFinal = "$ket | Alamat: $alamat";
    }

    final mutasi = MutasiModel(
      uid: "",
      idWarga: _selectedWargaId!,
      jenisMutasi: _jenisMutasi ?? "",
      keterangan: keteranganFinal,
      tanggal: _selectedDate ?? DateTime.now(),
      createdAt: null,
      updatedAt: null,
    );

    final ok = await _mutasiService.addMutasi(mutasi);

    setState(() => _loadingSubmit = false);

    if (!mounted) return;

    if (ok) {
      final jenis = (_jenisMutasi ?? "").toLowerCase().trim();
      if (jenis == "Pindah Keluar") {
        await _wargaService.updateWarga(_selectedWargaId!, {
          "status_warga": "Nonaktif",
        });
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data mutasi berhasil disimpan."),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menyimpan data mutasi."),
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
  void dispose() {
    _alamatController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE9F2F9),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MainHeader(
              title: "Tambah Mutasi Warga",
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
                        Text(
                          "Informasi Mutasi Warga",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // WARGA
                        const Text(
                          "Warga",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _loadingWarga
                            ? const LinearProgressIndicator()
                            : DropdownButtonFormField<String>(
                                value: _selectedWargaId,
                                isExpanded: true,
                                decoration: _inputDecoration("Pilih warga"),
                                items: _listWarga.map((w) {
                                  return DropdownMenuItem(
                                    value: w.docId,
                                    child: Text("${w.nama}"),
                                  );
                                }).toList(),
                                onChanged: (val) =>
                                    setState(() => _selectedWargaId = val),
                                validator: (val) =>
                                    val == null ? "Warga wajib dipilih" : null,
                              ),

                        const SizedBox(height: 16),

                        // JENIS MUTASI
                        DropdownButtonFormField<String>(
                          value: _jenisMutasi,
                          decoration:
                              _inputDecoration("Pilih jenis mutasi").copyWith(
                            labelText: "Jenis Mutasi",
                            hintText: null,
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: "Pindah Masuk",
                                child: Text("Pindah Masuk")),
                            DropdownMenuItem(
                                value: "Pindah Keluar",
                                child: Text("Pindah Keluar")),
                            DropdownMenuItem(
                                value: "Pindah Dalam",
                                child: Text("Pindah Dalam (antar RT/RW)")),
                            DropdownMenuItem(
                                value: "Sementara",
                                child: Text("Tinggal Sementara")),
                          ],
                          onChanged: (val) =>
                              setState(() => _jenisMutasi = val),
                          validator: (val) =>
                              val == null ? "Pilih jenis mutasi" : null,
                        ),

                        const SizedBox(height: 16),

                        // TANGGAL MUTASI
                        InputDecorator(
                          decoration: _inputDecoration("Tanggal Mutasi")
                              .copyWith(labelText: "Tanggal Mutasi"),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _selectedDate == null
                                      ? "--/--/----"
                                      : "${_selectedDate!.day.toString().padLeft(2, '0')}-"
                                          "${_selectedDate!.month.toString().padLeft(2, '0')}-"
                                          "${_selectedDate!.year}",
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: _pickDate,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ALAMAT ASAL/TUJUAN
                        TextFormField(
                          controller: _alamatController,
                          maxLines: 2,
                          decoration: _inputDecoration(
                            "Alamat Asal / Tujuan (opsional)",
                          ),
                        ),

                        const SizedBox(height: 16),

                        // KETERANGAN
                        TextFormField(
                          controller: _keteranganController,
                          maxLines: 3,
                          decoration: _inputDecoration(
                            "Keterangan Tambahan (opsional)",
                          ),
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
                                  backgroundColor: AppTheme.blueMediumLight,
                                  foregroundColor: Colors.black,
                                ),
                                onPressed: _loadingSubmit ? null : _submit,
                                child: _loadingSubmit
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.black),
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
