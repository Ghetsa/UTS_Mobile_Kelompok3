import 'package:flutter/material.dart';

class FilterPemasukanDialog extends StatefulWidget {
  const FilterPemasukanDialog({super.key, required this.onApply});

  final Function(Map<String, dynamic>) onApply;

  @override
  State<FilterPemasukanDialog> createState() => _FilterPemasukanDialogState();
}

class _FilterPemasukanDialogState extends State<FilterPemasukanDialog> {
  String? selectedJenis;
  DateTime? selectedDate;

  final List<String> jenisList = [
    "Semua",
    "Jenis Pemasukan 1",
    "Jenis Pemasukan 2",
  ];

  void _resetFilter() {
    setState(() {
      selectedJenis = null;
      selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Filter Pemasukan Lain",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Jenis Pemasukan
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Jenis Pemasukan"),
              value: selectedJenis,
              items: jenisList.map((jenis) {
                return DropdownMenuItem(
                  value: jenis,
                  child: Text(jenis),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedJenis = value;
                });
              },
            ),
            const SizedBox(height: 12),

            // Tanggal
            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Pilih Tanggal",
                suffixIcon: Icon(Icons.calendar_today),
              ),
              controller: TextEditingController(
                text: selectedDate != null
                    ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                    : "--/--/----",
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  helpText: "Pilih Tanggal",
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _resetFilter,
          child: const Text("Reset Filter"),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onApply({
              "jenis": selectedJenis,
              "tanggal": selectedDate,
            });
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
          child: const Text("Terapkan"),
        ),
      ],
    );
  }
}
