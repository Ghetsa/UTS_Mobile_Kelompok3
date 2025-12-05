import 'package:flutter/material.dart';

class FilterRumahDialog extends StatefulWidget {
  final Function(Map<String, dynamic>)? onApply;

  const FilterRumahDialog({super.key, this.onApply});

  @override
  State<FilterRumahDialog> createState() => _FilterRumahDialogState();
}

class _FilterRumahDialogState extends State<FilterRumahDialog> {
  // Dipakai untuk keyword alamat/nomor rumah
  final TextEditingController _penghuniController = TextEditingController();

  String? selectedStatus;
  String? selectedKepemilikan;

  /// ⚠️ Sesuaikan dengan komentar di RumahModel:
  /// statusRumah: "Dihuni", "Kosong", "Renovasi"
  final List<String> statusList = ["Semua", "Dihuni", "Kosong", "Renovasi"];

  /// kepemilikan: "Pemilik", "Penyewa", "Kosong"
  final List<String> kepemilikanList = [
    "Semua",
    "Pemilik",
    "Penyewa",
    "Kosong",
  ];

  void _resetFilter() {
    setState(() {
      _penghuniController.clear();
      selectedStatus = null;
      selectedKepemilikan = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Filter Data Rumah",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: SingleChildScrollView(
        child: Column(
          children: [
            // ⬇️ Dipakai sebagai keyword alamat / nomor rumah
            TextField(
              controller: _penghuniController,
              decoration: const InputDecoration(
                labelText: 'Alamat / Nomor Rumah',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status Rumah',
                border: OutlineInputBorder(),
              ),
              items: statusList
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text(s),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => selectedStatus = v),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: selectedKepemilikan,
              decoration: const InputDecoration(
                labelText: 'Kepemilikan',
                border: OutlineInputBorder(),
              ),
              items: kepemilikanList
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text(s),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => selectedKepemilikan = v),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _resetFilter,
          child: const Text('Reset'),
        ),
        ElevatedButton(
          onPressed: () {
            final result = {
              // pakai key "penghuni" seperti sebelumnya,
              // tapi di DaftarRumahPage dipakai sebagai keyword alamat/nomor
              "penghuni": _penghuniController.text.trim(),
              "status": selectedStatus,
              "kepemilikan": selectedKepemilikan,
            };

            if (widget.onApply != null) widget.onApply!(result);
            Navigator.pop(context, result);
          },
          child: const Text('Terapkan'),
        )
      ],
    );
  }
}
