import 'package:flutter/material.dart';
import '../../../../../core/layout/header.dart';
import '../../../../../core/theme/app_theme.dart';

// Controller
import '../../../controller/keluarga_controller.dart';

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

  final KeluargaController _keluargaController = KeluargaController();

  final TextEditingController _noKkC = TextEditingController();
  final TextEditingController _jumlahAnggotaC = TextEditingController();

  String _statusKeluarga = "aktif"; // aktif / pindah / sementara

  final RumahService _rumahService = RumahService();
  final KeluargaService _keluargaService = KeluargaService();

  List<RumahModel> _listRumah = [];
  String? _selectedRumahDocId;
  bool _loadingRumah = true;

  final WargaService _wargaService = WargaService();
  List<WargaModel> _listWarga = [];
  String? _selectedKepalaWargaId;
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
    if (!mounted) return;
    setState(() {
      _listRumah = result;
      _loadingRumah = false;
    });
  }

  Future<void> _loadWarga() async {
    final result = await _wargaService.getAllWarga();
    if (!mounted) return;
    setState(() {
      _listWarga = result;
      _loadingWarga = false;
    });
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

    try {
      final kepala = _listWarga.firstWhere(
        (w) => w.docId == _selectedKepalaWargaId,
        orElse: () => _listWarga.first,
      );

      final payload = {
        "kepala_keluarga": kepala.nama,
        "id_kepala_warga": _selectedKepalaWargaId,
        "no_kk": _noKkC.text.trim(),
        "id_rumah": _selectedRumahDocId,
        "jumlah_anggota": _jumlahAnggotaC.text.trim(),
        "status_keluarga": _statusKeluarga,
      };

      // ✅ simpan keluarga + ambil docId keluarga baru
      final keluargaId =
          await _keluargaController.addWithRumahAutomationReturnId(payload);

      if (keluargaId == null) {
        if (!mounted) return;
        setState(() => _loadingSubmit = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal menyimpan data keluarga."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // ✅ update rumah: kepemilikan + status rumah
      // await _updateRumahSaatDitempati(_selectedRumahDocId!);

      // ✅ tanya apakah kepala keluarga langsung jadi anggota
      final addAsAnggota = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Tambahkan Kepala Keluarga sebagai anggota?"),
          content: Text(
              "Jadikan '${kepala.nama}' sebagai anggota keluarga ini sekarang?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Nanti"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Ya"),
            ),
          ],
        ),
      );

      if (addAsAnggota == true) {
        await _wargaService.updateWarga(kepala.docId, {
          "id_keluarga": keluargaId,
          "id_rumah": _selectedRumahDocId,
          "no_kk": _noKkC.text.trim(),
        });

        final count = await _wargaService.countWargaByKeluarga(keluargaId);
        await _keluargaService.updateKeluarga(keluargaId, {
          "jumlah_anggota": count.toString(),
        });
      }

      if (!mounted) return;
      setState(() => _loadingSubmit = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Keluarga berhasil ditambahkan"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingSubmit = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// ✅ Update rumah saat sudah ditempati keluarga:
  /// - kepemilikan: kalau kosong/kosong → Pemilik
  /// - status_rumah: selalu jadi Dihuni
  Future<void> _updateRumahSaatDitempati(String rumahDocId) async {
    try {
      final rumahList = await _rumahService.getAllRumah();
      final rumah = rumahList.firstWhere(
        (r) => r.docId == rumahDocId,
        orElse: () => throw Exception("Rumah tidak ditemukan"),
      );

      final Map<String, dynamic> update = {
        // ✅ status rumah jadi dihuni
        "status_rumah": "Dihuni",
      };

      // ✅ kepemilikan kalau masih kosong
      final kep = rumah.kepemilikan.trim().toLowerCase();
      if (kep.isEmpty || kep == "kosong") {
        update["kepemilikan"] = "Pemilik";
      }

      await _rumahService.updateRumah(rumah.docId, update);
    } catch (e) {
      // tidak perlu gagalkan proses keluarga, tapi log biar ketahuan
      // ignore: avoid_print
      print("ERROR update rumah saat ditempati: $e");
    }
  }

  @override
  void dispose() {
    _noKkC.dispose();
    _jumlahAnggotaC.dispose();
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
            const MainHeader(
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
                        const Text(
                          "Pilih Kepala Keluarga (Warga)",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        _loadingWarga
                            ? const LinearProgressIndicator()
                            : DropdownButtonFormField<String>(
                                value: _selectedKepalaWargaId,
                                isExpanded: true,
                                decoration:
                                    _inputDecoration("Pilih Kepala Keluarga"),
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
                              fontSize: 15, fontWeight: FontWeight.w600),
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
                          onChanged: (v) =>
                              setState(() => _statusKeluarga = v ?? "aktif"),
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
                                decoration: _inputDecoration("Pilih rumah"),
                                items: _listRumah.map((r) {
                                  return DropdownMenuItem(
                                    value: r.docId,
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
