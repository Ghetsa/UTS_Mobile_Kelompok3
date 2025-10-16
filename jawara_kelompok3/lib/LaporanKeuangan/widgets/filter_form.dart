import 'package:flutter/material.dart';

class FilterFormDialog extends StatefulWidget {
  final String title;

  const FilterFormDialog({super.key, required this.title});

  @override
  State<FilterFormDialog> createState() => _FilterFormDialogState();
}

class _FilterFormDialogState extends State<FilterFormDialog> {
  final TextEditingController _namaController = TextEditingController();
  String? selectedKategori;
  DateTime? startDate;
  DateTime? endDate;

  final List<String> kategoriList = [
    "Semua",
    "Pendapatan Lainnya",
    "Operasional",
    "Pemeliharaan Fasilitas"
  ];

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  void _resetFilter() {
    setState(() {
      _namaController.clear();
      selectedKategori = null;
      startDate = null;
      endDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama
            const Text("Nama"),
            const SizedBox(height: 6),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                hintText: "Cari nama...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 12),

            // Kategori
            const Text("Kategori"),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: selectedKategori,
              items: kategoriList.map((kategori) {
                return DropdownMenuItem(
                  value: kategori,
                  child: Text(kategori),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedKategori = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                hintText: "-- Pilih Kategori --",
              ),
            ),
            const SizedBox(height: 12),

            // Dari Tanggal
            const Text("Dari Tanggal"),
            const SizedBox(height: 6),
            InkWell(
              onTap: () => _selectDate(context, true),
              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                child: Text(
                  startDate != null
                      ? "${startDate!.day}/${startDate!.month}/${startDate!.year}"
                      : "--/--/----",
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Sampai Tanggal
            const Text("Sampai Tanggal"),
            const SizedBox(height: 6),
            InkWell(
              onTap: () => _selectDate(context, false),
              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                child: Text(
                  endDate != null
                      ? "${endDate!.day}/${endDate!.month}/${endDate!.year}"
                      : "--/--/----",
                ),
              ),
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
            // TODO: apply filter
            Navigator.pop(context);
          },
          child: const Text("Terapkan"),
        ),
      ],
    );
  }
}
