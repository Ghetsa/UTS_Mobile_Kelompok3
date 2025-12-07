import 'package:flutter/material.dart';

class FilterPenggunaDialog extends StatefulWidget {
  final Function(Map<String, dynamic> filterData) onApply;

  const FilterPenggunaDialog({super.key, required this.onApply});

  @override
  State<FilterPenggunaDialog> createState() => _FilterPenggunaDialogState();
}

class _FilterPenggunaDialogState extends State<FilterPenggunaDialog> {
  TextEditingController namaController = TextEditingController();
  String? selectedRole;
  String? selectedStatus;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Filter Pengguna",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: "Nama Pengguna",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Role
            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration: const InputDecoration(
                labelText: "Role Pengguna",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "admin", child: Text("Admin")),
                DropdownMenuItem(value: "staff", child: Text("Staff")),
                DropdownMenuItem(value: "user", child: Text("User")),
              ],
              onChanged: (v) => setState(() => selectedRole = v),
            ),
            const SizedBox(height: 16),

            // Status
            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: const InputDecoration(
                labelText: "Status Akun",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "aktif", child: Text("Aktif")),
                DropdownMenuItem(value: "nonaktif", child: Text("Nonaktif")),
              ],
              onChanged: (v) => setState(() => selectedStatus = v),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () {
            final filterData = {
              "nama": namaController.text.trim(),
              "role": selectedRole,
              "status": selectedStatus,
            };
            widget.onApply(filterData);
            Navigator.pop(context);
          },
          child: const Text("Terapkan"),
        ),
      ],
    );
  }
}
