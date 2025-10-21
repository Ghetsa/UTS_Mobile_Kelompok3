import 'package:flutter/material.dart';

class FilterWargaDialog extends StatefulWidget {
  const FilterWargaDialog({super.key});

  @override
  State<FilterWargaDialog> createState() => _FilterWargaDialogState();
}

class _FilterWargaDialogState extends State<FilterWargaDialog> {
  final TextEditingController _namaController = TextEditingController();
  String? selectedStatus;
  String? selectedGender;
  DateTime? startDate;
  DateTime? endDate;

  final List<String> statusList = ["Semua", "Aktif", "Tidak Aktif"];
  final List<String> genderList = ["Semua", "Laki-laki", "Perempuan"];

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
      selectedStatus = null;
      selectedGender = null;
      startDate = null;
      endDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Filter Data Warga",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Nama Warga"),
            const SizedBox(height: 6),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                hintText: "Cari nama...",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 12),
            const Text("Jenis Kelamin"),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: selectedGender,
              items: genderList.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: "-- Pilih Jenis Kelamin --",
              ),
            ),
            const SizedBox(height: 12),
            const Text("Status Domisili"),
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
                hintText: "-- Pilih Status Domisili --",
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
            Navigator.pop(context);
          },
          child: const Text("Terapkan"),
        ),
      ],
    );
  }
}
