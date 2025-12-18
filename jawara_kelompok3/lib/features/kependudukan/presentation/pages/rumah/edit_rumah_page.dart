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
  final _nomorC = TextEditingController();
  final _rtC = TextEditingController();
  final _rwC = TextEditingController();

  String? _statusRumah;
  String? _kepemilikan;

  final RumahService _service = RumahService();
  bool _loading = false;

  static const List<String> _statusRumahItems = [
    "Dihuni",
    "Kosong",
    "Renovasi"
  ];
  static const List<String> _kepemilikanItems = [
    "Pemilik",
    "Penyewa",
    "Kosong"
  ];

  String _safeText(dynamic v) => (v == null) ? '' : v.toString().trim();

  String? _safeDropdown(String? value, List<String> allowed) {
    if (value == null) return null;
    final v = value.trim();
    if (v.isEmpty) return null;

    // exact match
    if (allowed.contains(v)) return v;

    // case-insensitive match (mis: "dihuni" -> "Dihuni")
    final idx = allowed.indexWhere((e) => e.toLowerCase() == v.toLowerCase());
    if (idx != -1) return allowed[idx];

    // tidak ada di items -> null supaya dropdown tidak error
    return null;
  }

  @override
  void initState() {
    super.initState();

    // ✅ controller aman walau data null
    _alamatC.text = _safeText(widget.rumah.alamat);
    _nomorC.text = _safeText(widget.rumah.nomor);
    _rtC.text = _safeText(widget.rumah.rt);
    _rwC.text = _safeText(widget.rumah.rw);

    // ✅ dropdown aman walau null / tidak ada di list
    _statusRumah = _safeDropdown(widget.rumah.statusRumah, _statusRumahItems);
    _kepemilikan = _safeDropdown(widget.rumah.kepemilikan, _kepemilikanItems);
  }

  @override
  void dispose() {
    _alamatC.dispose();
    _nomorC.dispose();
    _rtC.dispose();
    _rwC.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_alamatC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Alamat wajib diisi")),
      );
      return;
    }

    if (_nomorC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nomor rumah wajib diisi")),
      );
      return;
    }

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
      "alamat": _alamatC.text.trim(),
      "nomor": _nomorC.text.trim(),
      "status_rumah": _statusRumah,
      "kepemilikan": _kepemilikan,
      "rt": _rtC.text.trim(),
      "rw": _rwC.text.trim(),
      // updated_at di-set di service (serverTimestamp)
    };

    final ok = await _service.updateRumah(widget.rumah.docId, data);

    if (!mounted) return;
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
            TextField(
              controller: _nomorC,
              decoration: const InputDecoration(labelText: 'Nomor Rumah'),
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
              items: _statusRumahItems
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: (v) => setState(() => _statusRumah = v),
              decoration: const InputDecoration(labelText: 'Status Rumah'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _kepemilikan,
              items: _kepemilikanItems
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: (v) => setState(() => _kepemilikan = v),
              decoration: const InputDecoration(labelText: 'Kepemilikan'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
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
