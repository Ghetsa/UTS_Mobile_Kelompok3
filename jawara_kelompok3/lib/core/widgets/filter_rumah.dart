import 'package:flutter/material.dart';

class FilterRumahDialog extends StatefulWidget {
  const FilterRumahDialog({super.key});

  @override
  State<FilterRumahDialog> createState() => _FilterRumahDialogState();
}

class _FilterRumahDialogState extends State<FilterRumahDialog> {
  final TextEditingController _penghuniController = TextEditingController();
  String? selectedStatus;
  String? selectedKepemilikan;

  final List<String> statusList = ["Semua", "Ditempati", "Tersedia"];
  final List<String> kepemilikanList = ["Semua", "Pemilik", "Penyewa", "Kosong"];

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
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Nama Penghuni"),
            const SizedBox(height: 6),
            TextField(
              controller: _penghuniController,
              decoration: InputDecoration(
                hintText: "Cari nama penghuni...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text("Status Rumah"),
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
                hintText: "-- Pilih Status Rumah --",
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
              "penghuni": _penghuniController.text,
              "status": selectedStatus,
              "kepemilikan": selectedKepemilikan,
            });
          },
          child: const Text("Terapkan"),
        ),
      ],
    );
  }
}
