import 'package:flutter/material.dart';

class FilterMutasiDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onApply;

  const FilterMutasiDialog({super.key, required this.onApply});

  @override
  State<FilterMutasiDialog> createState() => _FilterMutasiDialogState();
}

class _FilterMutasiDialogState extends State<FilterMutasiDialog> {
  String jenis = "Semua";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Filter Mutasi"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField(
            value: jenis,
            items: const [
              DropdownMenuItem(value: "Semua", child: Text("Semua")),
              DropdownMenuItem(value: "Masuk", child: Text("Masuk")),
              DropdownMenuItem(value: "Keluar", child: Text("Keluar")),
            ],
            onChanged: (v) => setState(() => jenis = v!),
            decoration: const InputDecoration(labelText: "Jenis Mutasi"),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
        ElevatedButton(
          onPressed: () {
            widget.onApply({"jenis": jenis});
            Navigator.pop(context);
          },
          child: const Text("Terapkan"),
        ),
      ],
    );
  }
}
