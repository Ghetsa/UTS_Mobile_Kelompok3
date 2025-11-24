import 'package:flutter/material.dart';

class FilterKeluargaDialog extends StatefulWidget {
  const FilterKeluargaDialog({super.key});

  @override
  State<FilterKeluargaDialog> createState() => _FilterKeluargaDialogState();
}

class _FilterKeluargaDialogState extends State<FilterKeluargaDialog> {
  final TextEditingController _namaKeluargaController = TextEditingController();
  String? selectedStatus;
  String? selectedKepemilikan;
  DateTime? startDate;
  DateTime? endDate;

  final List<String> statusList = ["Semua", "Aktif", "Nonaktif"];
  final List<String> kepemilikanList = ["Semua", "Pemilik", "Penyewa"];

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
      _namaKeluargaController.clear();
      selectedStatus = null;
      selectedKepemilikan = null;
      startDate = null;
      endDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Filter Data Keluarga",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Nama Keluarga"),
            const SizedBox(height: 6),
            TextField(
              controller: _namaKeluargaController,
              decoration: InputDecoration(
                hintText: "Cari nama keluarga...",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 12),
            const Text("Status Kepemilikan"),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: selectedKepemilikan,
              items: kepemilikanList.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedKepemilikan = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: "-- Pilih Status Kepemilikan --",
              ),
            ),
            const SizedBox(height: 12),
            const Text("Status Keluarga"),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              items: statusList.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedStatus = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: "-- Pilih Status Keluarga --",
              ),
            ),
            const SizedBox(height: 12),
            const Text("Dari Tanggal"),
            const SizedBox(height: 6),
            InkWell(
              onTap: () => _selectDate(context, true),
              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
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
            const Text("Sampai Tanggal"),
            const SizedBox(height: 6),
            InkWell(
              onTap: () => _selectDate(context, false),
              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
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
          child: const Text("Reset"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              "nama": _namaKeluargaController.text,
              "status": selectedStatus,
              "kepemilikan": selectedKepemilikan,
              "startDate": startDate,
              "endDate": endDate,
            });
          },
          child: const Text("Terapkan"),
        ),
      ],
    );
  }
}
