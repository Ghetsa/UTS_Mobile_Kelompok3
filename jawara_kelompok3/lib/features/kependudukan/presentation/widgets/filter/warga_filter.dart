import 'package:flutter/material.dart';

class FilterWargaDialog extends StatefulWidget {
  final Function(Map<String, dynamic> filterData) onApply;

  const FilterWargaDialog({
    super.key,
    required this.onApply,
  });

  @override
  State<FilterWargaDialog> createState() => _FilterWargaDialogState();
}

class _FilterWargaDialogState extends State<FilterWargaDialog> {
  TextEditingController namaController = TextEditingController();

  String? selectedJenisKelamin;
  String? selectedAgama;
  String? selectedPendidikan;
  String? selectedStatus;
  String? selectedRumah;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Filter Data Warga",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter: Nama Warga
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: "Nama Warga",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Filter: Jenis Kelamin
            DropdownButtonFormField<String>(
              value: selectedJenisKelamin,
              decoration: const InputDecoration(
                labelText: "Jenis Kelamin",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "l", child: Text("Laki-laki")),
                DropdownMenuItem(value: "p", child: Text("Perempuan")),
              ],
              onChanged: (v) => setState(() => selectedJenisKelamin = v),
            ),
            const SizedBox(height: 16),

            // Filter: Agama
            DropdownButtonFormField<String>(
              value: selectedAgama,
              decoration: const InputDecoration(
                labelText: "Agama",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "Islam", child: Text("Islam")),
                DropdownMenuItem(value: "Kristen", child: Text("Kristen")),
                DropdownMenuItem(value: "Katolik", child: Text("Katolik")),
                DropdownMenuItem(value: "Hindu", child: Text("Hindu")),
                DropdownMenuItem(value: "Buddha", child: Text("Buddha")),
                DropdownMenuItem(value: "Konghucu", child: Text("Konghucu")),
              ],
              onChanged: (v) => setState(() => selectedAgama = v),
            ),
            const SizedBox(height: 16),

            // Filter: Pendidikan
            DropdownButtonFormField<String>(
              value: selectedPendidikan,
              decoration: const InputDecoration(
                labelText: "Pendidikan",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "SD", child: Text("SD")),
                DropdownMenuItem(value: "SMP", child: Text("SMP")),
                DropdownMenuItem(value: "SMA", child: Text("SMA / SMK")),
                DropdownMenuItem(value: "D3", child: Text("D3")),
                DropdownMenuItem(value: "D4", child: Text("D4")),
                DropdownMenuItem(value: "S1", child: Text("S1")),
                DropdownMenuItem(value: "S2", child: Text("S2")),
                DropdownMenuItem(value: "S3", child: Text("S3")),
              ],
              onChanged: (v) => setState(() => selectedPendidikan = v),
            ),
            const SizedBox(height: 16),

            // Filter: Status Warga
            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: const InputDecoration(
                labelText: "Status Warga",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "aktif", child: Text("Aktif")),
                DropdownMenuItem(value: "pindah", child: Text("Pindah")),
                DropdownMenuItem(value: "meninggal", child: Text("Meninggal")),
              ],
              onChanged: (v) => setState(() => selectedStatus = v),
            ),
            const SizedBox(height: 16),
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
              "jenis_kelamin": selectedJenisKelamin,
              "agama": selectedAgama,
              "pendidikan": selectedPendidikan,
              "status_warga": selectedStatus,
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
