import 'package:flutter/material.dart';

class FilterKategoriIuranDialog extends StatefulWidget {
  const FilterKategoriIuranDialog({super.key});

  @override
  State<FilterKategoriIuranDialog> createState() =>
      _FilterKategoriIuranDialogState();
}

class _FilterKategoriIuranDialogState extends State<FilterKategoriIuranDialog> {
  String? selectedJenis;

  final List<String> jenisList = [
    "Semua",
    "Iuran Bulanan",
    "Iuran Khusus",
  ];

  void _resetFilter() {
    setState(() {
      selectedJenis = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Filter Kategori Iuran",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: DropdownButtonFormField<String>(
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
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          hintText: "-- Pilih Jenis Iuran --",
        ),
      ),
      actions: [
        TextButton(
          onPressed: _resetFilter,
          child: const Text("Reset"),
        ),
        ElevatedButton(
          onPressed: () {
            // TODO: Apply filter logikanya disini (misal passing balik ke page)
            Navigator.pop(context, selectedJenis);
          },
          child: const Text("Terapkan"),
        ),
      ],
    );
  }
}
