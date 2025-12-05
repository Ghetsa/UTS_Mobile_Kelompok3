import 'package:flutter/material.dart';
import '../../../data/models/mutasi_model.dart';
import '../../../data/services/mutasi_service.dart';

class EditMutasiDialog extends StatefulWidget {
  final MutasiModel data;

  const EditMutasiDialog({super.key, required this.data});

  @override
  State<EditMutasiDialog> createState() => _EditMutasiDialogState();
}

class _EditMutasiDialogState extends State<EditMutasiDialog> {
  final MutasiService _service = MutasiService();

  late TextEditingController _keteranganC;
  late String _jenisMutasi;
  late DateTime _tanggal;

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _keteranganC = TextEditingController(text: widget.data.keterangan);

    // Default jika kosong
    _jenisMutasi = widget.data.jenisMutasi.isEmpty
        ? "Pindah Keluar"
        : widget.data.jenisMutasi;

    _tanggal = widget.data.tanggal ?? DateTime.now();
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
    setState(() => _loading = true);

    final Map<String, dynamic> payload = {
      "jenis_mutasi": _jenisMutasi,
      "keterangan": _keteranganC.text.trim(),
      "tanggal": _tanggal,
      "updated_at": DateTime.now(),
    };

    final ok = await _service.updateMutasi(widget.data.uid, payload);

    setState(() => _loading = false);

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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Mutasi Warga"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// JENIS MUTASI
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
                  child: Text("Pindah Dalam (antar RT/RW)"),
                ),
                DropdownMenuItem(
                    value: "Sementara", child: Text("Tinggal Sementara")),
              ],
              onChanged: (v) => setState(() => _jenisMutasi = v!),
            ),

            const SizedBox(height: 14),

            /// TANGGAL MUTASI
            InputDecorator(
              decoration: const InputDecoration(
                labelText: "Tanggal Mutasi",
                border: OutlineInputBorder(),
              ),
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
              decoration: const InputDecoration(
                labelText: "Keterangan Tambahan",
                border: OutlineInputBorder(),
              ),
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
          onPressed: _loading ? null : _save,
          child: _loading
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
