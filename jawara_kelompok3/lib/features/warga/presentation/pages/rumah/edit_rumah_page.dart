import 'package:flutter/material.dart';
import '../../../data/models/rumah_model.dart';
import '../../../data/services/rumah_service.dart';

class EditRumahDialog extends StatefulWidget {
  final RumahModel rumah;
  const EditRumahDialog({super.key, required this.rumah});

  @override
  State<EditRumahDialog> createState() => _EditRumahDialogState();
}

class _EditRumahDialogState extends State<EditRumahDialog> {
  final _alamatC = TextEditingController();
  final _penghuniC = TextEditingController();
  String? _status;
  String? _kepemilikan;
  final RumahService _service = RumahService();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _alamatC.text = widget.rumah.alamat;
    _penghuniC.text = widget.rumah.penghuni;
    _status = widget.rumah.status;
    _kepemilikan = widget.rumah.kepemilikan;
  }

  Future<void> _save() async {
    setState(() => _loading = true);
    final data = {
      "alamat": _alamatC.text,
      "penghuni": _penghuniC.text,
      "status": _status,
      "kepemilikan": _kepemilikan,
    };
    final ok = await _service.updateRumah(widget.rumah.id, data);
    setState(() => _loading = false);
    if (ok) Navigator.pop(context, true);
    else ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal update")));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Rumah"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(controller: _alamatC, decoration: const InputDecoration(labelText: 'Alamat')),
            const SizedBox(height: 8),
            TextField(controller: _penghuniC, decoration: const InputDecoration(labelText: 'Penghuni')),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _status,
              items: const [
                DropdownMenuItem(value: "Ditempati", child: Text("Ditempati")),
                DropdownMenuItem(value: "Tersedia", child: Text("Tersedia")),
              ],
              onChanged: (v) => setState(() => _status = v),
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _kepemilikan,
              items: const [
                DropdownMenuItem(value: "Pemilik", child: Text("Pemilik")),
                DropdownMenuItem(value: "Penyewa", child: Text("Penyewa")),
                DropdownMenuItem(value: "Kosong", child: Text("Kosong")),
              ],
              onChanged: (v) => setState(() => _kepemilikan = v),
              decoration: const InputDecoration(labelText: 'Kepemilikan'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
        ElevatedButton(onPressed: _loading ? null : _save, child: _loading ? const CircularProgressIndicator() : const Text('Simpan')),
      ],
    );
  }
}
