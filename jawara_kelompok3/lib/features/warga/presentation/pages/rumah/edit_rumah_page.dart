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
  final _rtC = TextEditingController();
  final _rwC = TextEditingController();

  String? _statusRumah;
  String? _kepemilikan;

  final RumahService _service = RumahService();
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _alamatC.text = widget.rumah.alamat;
    _rtC.text = widget.rumah.rt;
    _rwC.text = widget.rumah.rw;

    _statusRumah = widget.rumah.statusRumah;
    _kepemilikan = widget.rumah.kepemilikan;
  }

  Future<void> _save() async {
    if (_statusRumah == null || _kepemilikan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Status rumah dan kepemilikan wajib dipilih"),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    final data = {
      "alamat": _alamatC.text,
      "status_rumah": _statusRumah,
      "kepemilikan": _kepemilikan,
      "rt": _rtC.text,
      "rw": _rwC.text,
      // updated_at di-set di service (serverTimestamp)
    };

    final ok = await _service.updateRumah(widget.rumah.docId, data);

    setState(() => _loading = false);

    if (ok) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal mengupdate rumah")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Rumah"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _alamatC,
              decoration: const InputDecoration(labelText: 'Alamat'),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _rtC,
                    decoration: const InputDecoration(labelText: 'RT'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _rwC,
                    decoration: const InputDecoration(labelText: 'RW'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: _statusRumah,
              items: const [
                DropdownMenuItem(value: "Dihuni", child: Text("Dihuni")),
                DropdownMenuItem(value: "Kosong", child: Text("Kosong")),
                DropdownMenuItem(value: "Renovasi", child: Text("Renovasi")),
              ],
              onChanged: (v) => setState(() => _statusRumah = v),
              decoration: const InputDecoration(labelText: 'Status Rumah'),
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
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _save,
          child: _loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Simpan'),
        ),
      ],
    );
  }
}
