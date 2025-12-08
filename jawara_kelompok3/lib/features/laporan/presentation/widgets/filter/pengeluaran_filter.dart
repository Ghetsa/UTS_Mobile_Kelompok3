import 'package:flutter/material.dart';

class PengeluaranFilterDialog extends StatefulWidget {
  const PengeluaranFilterDialog({super.key});

  @override
  State<PengeluaranFilterDialog> createState() => _PengeluaranFilterDialogState();
}

class _PengeluaranFilterDialogState extends State<PengeluaranFilterDialog> {
  String? selectedJenis;
  DateTime? selectedDate;

  final List<String> jenisList = [
    "Semua",
    "Operasional",
    "Perawatan",
    "Konsumsi",
    "Transportasi",
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
        "Filter Pengeluaran",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Jenis Pengeluaran Dropdown
          DropdownButtonFormField<String>(
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
              hintText: "-- Pilih Jenis Pengeluaran --",
            ),
          ),
          const SizedBox(height: 16),

          // Tanggal Pengeluaran Picker
          TextFormField(
            readOnly: true,
            controller: TextEditingController(
                text: selectedDate == null
                    ? '-- Pilih Tanggal --'
                    : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
            decoration: InputDecoration(
              labelText: "Tanggal Pengeluaran",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                setState(() {
                  selectedDate = pickedDate;
                });
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _resetFilter,
          child: const Text("Reset"),
        ),
        ElevatedButton(
          onPressed: () {
            // Apply filter logic here, passing the filter values back
            Navigator.pop(context, {'jenis': selectedJenis, 'date': selectedDate});
          },
          child: const Text("Terapkan"),
        ),
      ],
    );
  }
}
