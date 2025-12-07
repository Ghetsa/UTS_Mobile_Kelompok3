import 'package:flutter/material.dart';
import '../../../../../core/layout/header.dart';
import '../../../../../core/theme/app_theme.dart';

// Service & Model
import '../../../data/services/keluarga_service.dart';
import '../../../data/services/rumah_service.dart';
import '../../../data/models/rumah_model.dart';

// 🔹 WARGA
import '../../../data/services/warga_service.dart';
import '../../../data/models/warga_model.dart';

class TambahKeluargaPage extends StatefulWidget {
  const TambahKeluargaPage({super.key});

  @override
  State<TambahKeluargaPage> createState() => _TambahKeluargaPageState();
}

class _TambahKeluargaPageState extends State<TambahKeluargaPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _noKkC = TextEditingController();
  final TextEditingController _jumlahAnggotaC = TextEditingController();

  // STATUS KELUARGA
  String _statusKeluarga = "aktif"; // aktif / pindah / sementara

  // ==========================
  // RUMAH dropdown
  // ==========================
  final RumahService _rumahService = RumahService();
  final KeluargaService _keluargaService = KeluargaService();

  List<RumahModel> _listRumah = [];
  String? _selectedRumahDocId; // simpan docId rumah
  bool _loadingRumah = true;

  // ==========================
  // WARGA (Kepala Keluarga) dropdown
  // ==========================
  final WargaService _wargaService = WargaService();
  List<WargaModel> _listWarga = [];
  String? _selectedKepalaWargaId; // docId warga yg jadi kepala
  bool _loadingWarga = true;

  bool _loadingSubmit = false;

  @override
  void initState() {
    super.initState();
    _loadRumah();
    _loadWarga();
  }

  Future<void> _loadRumah() async {
    final result = await _rumahService.getAllRumah();
    setState(() {
      _listRumah = result;
      _loadingRumah = false;
    });
  }

  Future<void> _loadWarga() async {
    final result = await _wargaService.getAllWarga();
    setState(() {
      _listWarga = result;
      _loadingWarga = false;
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

    if (_selectedKepalaWargaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih Kepala Keluarga (warga)")),
      );
      return;
    }

    setState(() => _loadingSubmit = true);

    // cari nama kepala dari list warga
    final kepala = _listWarga.firstWhere(
      (w) => w.docId == _selectedKepalaWargaId,
      orElse: () => _listWarga.first,
    );

    final payload = {
      "kepala_keluarga": kepala.nama,              // nama untuk tampilan
      "id_kepala_warga": _selectedKepalaWargaId,   // docId warga
      "no_kk": _noKkC.text.trim(),
      "id_rumah": _selectedRumahDocId,             // docId rumah
      "jumlah_anggota": _jumlahAnggotaC.text.trim(),
      "status_keluarga": _statusKeluarga,          // aktif / pindah / sementara
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

                        // ================= KEPALA KELUARGA (WARGA) =================
                        const Text(
                          "Pilih Kepala Keluarga (Warga)",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _loadingWarga
                            ? const LinearProgressIndicator()
                            : DropdownButtonFormField<String>(
                                value: _selectedKepalaWargaId,
                                isExpanded: true,
                                decoration: _inputDecoration(
                                  "Pilih Kepala Keluarga (berdasarkan warga)",
                                ),
                                items: _listWarga.map((w) {
                                  return DropdownMenuItem(
                                    value: w.docId,
                                    child: Text("${w.nama} • NIK: ${w.nik}"),
                                  );
                                }).toList(),
                                onChanged: (v) =>
                                    setState(() => _selectedKepalaWargaId = v),
                                validator: (v) => v == null
                                    ? "Kepala Keluarga wajib dipilih"
                                    : null,
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
                          "Status Keluarga",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: _statusKeluarga,
                          decoration: _inputDecoration("Pilih status keluarga"),
                          items: const [
                            DropdownMenuItem(
                                value: "aktif", child: Text("Aktif")),
                            DropdownMenuItem(
                                value: "pindah", child: Text("Pindah")),
                            DropdownMenuItem(
                                value: "sementara", child: Text("Sementara")),
                          ],
                          onChanged: (v) {
                            if (v == null) return;
                            setState(() => _statusKeluarga = v);
                          },
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
                                    value: r.docId, // simpan docId rumah
                                    child: Text("No. ${r.nomor} • ${r.alamat}"),
                                  );
                                }).toList(),
                                onChanged: (v) =>
                                    setState(() => _selectedRumahDocId = v),
                                validator: (v) =>
                                    v == null ? "Pilih rumah" : null,
                              ),

                        const SizedBox(height: 30),
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
                                onPressed: _loadingSubmit ? null : _simpan,
                                child: _loadingSubmit
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text("Simpan"),
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
          ],
        ),
      ),
    );
  }
}
