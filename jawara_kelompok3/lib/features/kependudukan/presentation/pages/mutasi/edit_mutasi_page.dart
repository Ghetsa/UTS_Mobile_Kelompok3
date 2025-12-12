import 'package:flutter/material.dart';
import '../../../data/models/mutasi_model.dart';
import '../../../data/services/mutasi_service.dart';
import '../../../data/models/warga_model.dart';
import '../../../data/services/warga_service.dart';

class EditMutasiDialog extends StatefulWidget {
  final MutasiModel data;

  const EditMutasiDialog({super.key, required this.data});

  @override
  State<EditMutasiDialog> createState() => _EditMutasiDialogState();
}

class _EditMutasiDialogState extends State<EditMutasiDialog> {
  final MutasiService _service = MutasiService();
  final WargaService _wargaService = WargaService();

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _alamatC;
  late TextEditingController _keteranganC;

  DateTime? _tanggal;
  String _jenisMutasi = "Pindah Keluar";

  List<WargaModel> _listWarga = [];
  String? _selectedWargaId;
  bool _loadingWarga = true;

  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _tanggal = widget.data.tanggal ?? DateTime.now();
    _jenisMutasi = widget.data.jenisMutasi.isEmpty
        ? "Pindah Keluar"
        : widget.data.jenisMutasi;

    _selectedWargaId = widget.data.idWarga.isEmpty ? null : widget.data.idWarga;

    // pecah keterangan lama -> alamat + ket
    final parsed = _splitKeterangan(widget.data.keterangan);
    _alamatC = TextEditingController(text: parsed['alamat'] ?? '');
    _keteranganC = TextEditingController(text: parsed['ket'] ?? '');

    _loadWarga();
  }

  @override
  void dispose() {
    _alamatC.dispose();
    _keteranganC.dispose();
    super.dispose();
  }

  Map<String, String> _splitKeterangan(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return {'ket': '', 'alamat': ''};

    String ket = text;
    String alamat = '';

    final idx = text.toLowerCase().lastIndexOf('alamat:');
    if (idx != -1) {
      alamat = text.substring(idx + 'alamat:'.length).trim();
      ket = text.substring(0, idx).trim();
      if (ket.endsWith('|')) ket = ket.substring(0, ket.length - 1).trim();
    }

    return {'ket': ket, 'alamat': alamat};
  }

  Future<void> _loadWarga() async {
    try {
      final data = await _wargaService.getAllWarga();
      if (!mounted) return;

      setState(() {
        _listWarga = data;
        _loadingWarga = false;

        // ✅ FIX: cocokkan pakai docId
        if (_selectedWargaId != null &&
            !_listWarga.any((w) => w.docId == _selectedWargaId)) {
          _selectedWargaId = null;
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingWarga = false);
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggal ?? now,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() => _tanggal = picked);
    }
  }

  Future<void> _save() async {
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

    setState(() => _saving = true);

    // gabungkan sama persis seperti Tambah
    final ket = _keteranganC.text.trim();
    final alamat = _alamatC.text.trim();
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

    final payload = <String, dynamic>{
      "id_warga": _selectedWargaId,
      "jenis_mutasi": _jenisMutasi,
      "keterangan": keteranganFinal,
      "tanggal": _tanggal ?? DateTime.now(),
    };

    final ok = await _service.updateMutasi(widget.data.uid, payload);

    if (!mounted) return;
    setState(() => _saving = false);

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal mengupdate data mutasi"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // ✅ otomatis nonaktif kalau pindah keluar
    final jenis = _jenisMutasi.toLowerCase().trim();
    if (jenis == "pindah keluar") {
      await _wargaService.updateWarga(_selectedWargaId!, {
        "status_warga": "Nonaktif",
      });
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ Data mutasi berhasil diperbarui"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Edit Mutasi Warga",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // WARGA
                _loadingWarga
                    ? const LinearProgressIndicator()
                    : DropdownButtonFormField<String>(
                        value: _selectedWargaId,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: "Warga"),
                        items: _listWarga.map((w) {
                          return DropdownMenuItem(
                            value: w.docId,
                            child: Text("${w.nama} • NIK: ${w.nik}"),
                          );
                        }).toList(),
                        onChanged: (v) => setState(() => _selectedWargaId = v),
                        validator: (v) =>
                            v == null ? "Warga wajib dipilih" : null,
                      ),

                const SizedBox(height: 10),

                // JENIS MUTASI
                DropdownButtonFormField<String>(
                  value: _jenisMutasi,
                  decoration: const InputDecoration(labelText: "Jenis Mutasi"),
                  items: const [
                    DropdownMenuItem(
                        value: "Pindah Masuk", child: Text("Pindah Masuk")),
                    DropdownMenuItem(
                        value: "Pindah Keluar", child: Text("Pindah Keluar")),
                    DropdownMenuItem(
                        value: "Pindah Dalam",
                        child: Text("Pindah Dalam (antar RT/RW)")),
                    DropdownMenuItem(
                        value: "Sementara", child: Text("Tinggal Sementara")),
                  ],
                  onChanged: (v) =>
                      setState(() => _jenisMutasi = v ?? "Pindah Keluar"),
                ),

                const SizedBox(height: 10),

                // TANGGAL MUTASI
                InputDecorator(
                  decoration:
                      const InputDecoration(labelText: "Tanggal Mutasi"),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _tanggal == null
                              ? "--/--/----"
                              : "${_tanggal!.day.toString().padLeft(2, '0')}-"
                                  "${_tanggal!.month.toString().padLeft(2, '0')}-"
                                  "${_tanggal!.year}",
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: _pickDate,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ALAMAT
                TextField(
                  controller: _alamatC,
                  decoration: const InputDecoration(
                      labelText: "Alamat Asal / Tujuan (opsional)"),
                  maxLines: 2,
                ),

                const SizedBox(height: 10),

                // KETERANGAN
                TextField(
                  controller: _keteranganC,
                  decoration: const InputDecoration(
                      labelText: "Keterangan Tambahan (opsional)"),
                  maxLines: 3,
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed:
                          _saving ? null : () => Navigator.pop(context, false),
                      child: const Text("Batal"),
                    ),
                    ElevatedButton(
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text("Simpan"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
