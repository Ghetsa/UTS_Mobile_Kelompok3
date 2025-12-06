import 'package:flutter/material.dart';

class FilterKegiatanDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onApply;

  const FilterKegiatanDialog({super.key, required this.onApply});

  @override
  State<FilterKegiatanDialog> createState() => _FilterKegiatanDialogState();
}

class _FilterKegiatanDialogState extends State<FilterKegiatanDialog> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _pjController = TextEditingController();

  String? _kategori;
  String? _status;

  final List<String> kategoriList = [
    "Komunitas & Sosial",
    "Keamanan",
    "Keagamaan",
    "Pendidikan",
    "Olahraga",
  ];

  final List<String> statusList = [
    "rencana",
    "berjalan",
    "selesai",
    "batal",
  ];

  void _reset() {
    setState(() {
      _namaController.clear();
      _pjController.clear();
      _kategori = null;
      _status = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Filter Kegiatan",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: "Nama Kegiatan",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pjController,
              decoration: const InputDecoration(
                labelText: "Penanggung Jawab",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _kategori,
              decoration: const InputDecoration(
                labelText: "Kategori",
                border: OutlineInputBorder(),
              ),
              items: kategoriList
                  .map((k) =>
                      DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) => setState(() => _kategori = v),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(
                labelText: "Status",
                border: OutlineInputBorder(),
              ),
              items: statusList
                  .map((s) =>
                      DropdownMenuItem(value: s, child: Text(s.toUpperCase())))
                  .toList(),
              onChanged: (v) => setState(() => _status = v),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: _reset, child: const Text("Reset")),
        ElevatedButton(
          onPressed: () {
            widget.onApply({
              "nama": _namaController.text.trim(),
              "penanggung_jawab": _pjController.text.trim(),
              "kategori": _kategori,
              "status": _status,
            });
            Navigator.pop(context);
          },
          child: const Text("Terapkan"),
        )
      ],
    );
  }
}
