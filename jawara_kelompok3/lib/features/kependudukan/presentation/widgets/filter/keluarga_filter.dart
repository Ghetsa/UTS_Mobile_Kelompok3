import 'package:flutter/material.dart';

class FilterKeluargaDialog extends StatefulWidget {
  final Function(Map<String, dynamic> filterData) onApply;

  const FilterKeluargaDialog({
    super.key,
    required this.onApply,
  });

  @override
  State<FilterKeluargaDialog> createState() => _FilterKeluargaDialogState();
}

class _FilterKeluargaDialogState extends State<FilterKeluargaDialog> {
  TextEditingController namaKepalaController = TextEditingController();
  TextEditingController idRumahController = TextEditingController();

  String? selectedStatusKeluarga;

  final List<String> statusList = [
    "Semua",
    "aktif",
    "pindah",
    "sementara",
  ];

  void _reset() {
    setState(() {
      namaKepalaController.clear();
      idRumahController.clear();
      selectedStatusKeluarga = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Filter Data Keluarga",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter: Status Keluarga
            DropdownButtonFormField<String>(
              value: selectedStatusKeluarga,
              decoration: const InputDecoration(
                labelText: "Status Keluarga",
                border: OutlineInputBorder(),
              ),
              items: statusList
                  .map(
                    (s) => DropdownMenuItem(
                      value: s == "Semua" ? "semua" : s,
                      child: Text(
                        s == "Semua"
                            ? "Semua"
                            : s[0].toUpperCase() + s.substring(1),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => selectedStatusKeluarga = v),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _reset,
          child: const Text("Reset"),
        ),
        ElevatedButton(
          onPressed: () {
            final filterData = {
              "nama_kepala": namaKepalaController.text.trim(),
              "status_keluarga": selectedStatusKeluarga,
              "id_rumah": idRumahController.text.trim(),
            };

            widget.onApply(filterData);
            Navigator.pop(context);
          },
          child: const Text("Terapkan"),
        ),
      ],
    );
  }
}
