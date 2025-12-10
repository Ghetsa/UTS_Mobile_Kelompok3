import 'package:flutter/material.dart';

class AspirasiFilterDialog extends StatefulWidget {
  final String initialSearch;
  final String? initialStatus;
  final void Function(Map<String, dynamic> filterData) onApply;
  final VoidCallback onReset;

  const AspirasiFilterDialog({
    super.key,
    required this.initialSearch,
    this.initialStatus,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<AspirasiFilterDialog> createState() => _AspirasiFilterDialogState();
}

class _AspirasiFilterDialogState extends State<AspirasiFilterDialog> {
  late TextEditingController searchController;
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: widget.initialSearch);
    selectedStatus = widget.initialStatus;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Filter Aspirasi",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: "Cari Aspirasi",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Status
            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: const InputDecoration(
                labelText: "Status",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "proses", child: Text("Pending")),
                DropdownMenuItem(value: "selesai", child: Text("Diterima")),
                DropdownMenuItem(value: "ditolak", child: Text("Ditolak")),
              ],
              onChanged: (v) => setState(() => selectedStatus = v),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: widget.onReset,
          child: const Text("Reset"),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onApply({
              'search': searchController.text.trim(),
              'status': selectedStatus,
            });
            Navigator.pop(context);
          },
          child: const Text("Terapkan"),
        ),
      ],
    );
  }
}
