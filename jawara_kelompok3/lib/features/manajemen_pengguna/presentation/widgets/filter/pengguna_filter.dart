import 'package:flutter/material.dart';

class FilterPenggunaDialog extends StatefulWidget {
  final Function(Map<String, dynamic> filterData) onApply;

  const FilterPenggunaDialog({super.key, required this.onApply});

  @override
  State<FilterPenggunaDialog> createState() => _FilterPenggunaDialogState();
}

class _FilterPenggunaDialogState extends State<FilterPenggunaDialog> {
  final TextEditingController namaController = TextEditingController();
  String? selectedRole;
  String? selectedStatus;

  // Role dan Status sesuai update terbaru
  final List<String> roleList = ['Warga', 'Admin'];
  final List<String> statusList = ['aktif', 'nonaktif'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Filter Pengguna",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
              items: roleList
                  .map((role) =>
                      DropdownMenuItem(value: role, child: Text(role)))
                  .toList(),
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
              items: statusList
                  .map((status) =>
                      DropdownMenuItem(value: status, child: Text(status)))
                  .toList(),
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
            final filterData = <String, dynamic>{};
            if (namaController.text.trim().isNotEmpty) {
              filterData['nama'] = namaController.text.trim();
            }
            if (selectedRole != null) filterData['role'] = selectedRole;
            if (selectedStatus != null)
              filterData['status_warga'] = selectedStatus;

            widget.onApply(filterData);
            Navigator.pop(context);
          },
          child: const Text("Terapkan"),
        ),
      ],
    );
  }

  @override
  void dispose() {
    namaController.dispose();
    super.dispose();
  }
}
