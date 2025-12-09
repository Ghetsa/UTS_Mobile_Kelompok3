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

  late TextEditingController _keteranganC;
  late String _jenisMutasi;
  late DateTime _tanggal;

  // 🔹 State untuk dropdown Warga
  List<WargaModel> _listWarga = [];
  String? _selectedWargaId;
  bool _loadingWarga = true;

  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _keteranganC = TextEditingController(text: widget.data.keterangan);

    _jenisMutasi = widget.data.jenisMutasi.isEmpty
        ? "Pindah Keluar"
        : widget.data.jenisMutasi;

    _tanggal = widget.data.tanggal ?? DateTime.now();

    // id warga awal dari data mutasi
    _selectedWargaId = widget.data.idWarga.isEmpty ? null : widget.data.idWarga;

    _loadWarga();
  }

  Future<void> _loadWarga() async {
    try {
      final data = await _wargaService.getAllWarga();
      setState(() {
        _listWarga = data;
        _loadingWarga = false;

        // Kalau id lama tidak ada di list warga (misal warga dihapus),
        // set jadi null supaya user dipaksa pilih ulang
        if (_selectedWargaId != null &&
            !_listWarga.any((w) => w.uid == _selectedWargaId)) {
          _selectedWargaId = null;
        }
      });
    } catch (_) {
      setState(() {
        _loadingWarga = false;
      });
    }
  }

  @override
  void dispose() {
    _keteranganC.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _tanggal = picked);
    }
  }

  Future<void> _save() async {
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

    // 🔥 PAKAI 'id' biar sama dengan toMap() & fromFirestore()
    final Map<String, dynamic> payload = {
      "id_warga": _selectedWargaId,
      "jenis_mutasi": _jenisMutasi,
      "keterangan": _keteranganC.text.trim(),
      "tanggal": _tanggal,
    };

    print("DEBUG UPDATE MUTASI | docId=${widget.data.uid} | payload=$payload");

    final ok = await _service.updateMutasi(widget.data.uid, payload);

    setState(() => _saving = false);

    if (!mounted) return;

    if (ok) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal mengupdate data mutasi"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Mutasi Warga"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// 🔹 WARGA (dropdown seperti di Tambah)
            const Text(
              "Warga",
              style: TextStyle(
                fontSize: 14,
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
                        value: w.docId, // ⬅️ gunakan DOCID bukan UID
                        child: Text("${w.nama} • NIK: ${w.nik}"),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedWargaId = val),
                  ),

            const SizedBox(height: 14),

            /// JENIS MUTASI
            DropdownButtonFormField<String>(
              value: _selectedWargaId,
              isExpanded: true,
              decoration: _inputDecoration("Pilih warga"),
              items: _listWarga.map((w) {
                return DropdownMenuItem(
                  value: w.docId, // ⬅️ gunakan DOCID bukan UID
                  child: Text("${w.nama} • NIK: ${w.nik}"),
                );
              }).toList(),
              onChanged: (val) => setState(() => _selectedWargaId = val),
            ),

            const SizedBox(height: 14),

            /// TANGGAL MUTASI
            InputDecorator(
              decoration: _inputDecoration("Tanggal Mutasi"),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "${_tanggal.day.toString().padLeft(2, '0')}-"
                      "${_tanggal.month.toString().padLeft(2, '0')}-"
                      "${_tanggal.year}",
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickDate,
                  )
                ],
              ),
            ),

            const SizedBox(height: 14),

            /// KETERANGAN
            TextField(
              controller: _keteranganC,
              maxLines: 3,
              decoration: _inputDecoration("Keterangan Tambahan"),
            ),
          ],
        ),
      ),

      /// ACTION BUTTONS
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Simpan"),
        ),
      ],
    );
  }
}
