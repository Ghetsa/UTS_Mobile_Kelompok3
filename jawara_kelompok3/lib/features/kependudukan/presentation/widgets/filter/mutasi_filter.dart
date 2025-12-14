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
          DropdownButtonFormField<String>(
            value: jenis,
            items: const [
              DropdownMenuItem(value: "Semua", child: Text("Semua")),
              DropdownMenuItem(value: "Pindah Masuk", child: Text("Pindah Masuk")),
              DropdownMenuItem(value: "Pindah Keluar", child: Text("Pindah Keluar")),
              DropdownMenuItem(value: "Pindah Dalam", child: Text("Pindah Dalam (antar RT/RW)")),
              DropdownMenuItem(value: "Sementara", child: Text("Tinggal Sementara")),
            ],
            onChanged: (v) => setState(() => jenis = v ?? "Semua"),
            decoration: const InputDecoration(labelText: "Jenis Mutasi"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
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
