import 'package:flutter/material.dart';

class FilterKeluargaDialog extends StatefulWidget {
  final Function(Map<String, dynamic> filterData) onApply;

  const FilterKeluargaDialog({
    super.key,
    required this.onApply,
  });

  @override
  State<FilterKeluargaDialog> createState() => _FilterKeluargaDialogState();
}

class _FilterKeluargaDialogState extends State<FilterKeluargaDialog> {
  String? selectedStatusKeluarga;
  String? selectedDomisili;
  String? selectedKategori;
  TextEditingController namaKepalaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Filter Data Keluarga",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter: Nama Kepala Keluarga
            TextField(
              controller: namaKepalaController,
              decoration: const InputDecoration(
                labelText: "Nama Kepala Keluarga",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Filter: Status Keluarga
            DropdownButtonFormField<String>(
              value: selectedStatusKeluarga,
              decoration: const InputDecoration(
                labelText: "Status Keluarga",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "aktif", child: Text("Aktif")),
                DropdownMenuItem(value: "pindah", child: Text("Pindah")),
                DropdownMenuItem(value: "meninggal", child: Text("Meninggal")),
              ],
              onChanged: (v) => setState(() => selectedStatusKeluarga = v),
            ),
            const SizedBox(height: 16),

            // Filter: Domisili
            DropdownButtonFormField<String>(
              value: selectedDomisili,
              decoration: const InputDecoration(
                labelText: "Domisili",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "dalam_wilayah", child: Text("Dalam Wilayah")),
                DropdownMenuItem(value: "luar_wilayah", child: Text("Luar Wilayah")),
              ],
              onChanged: (v) => setState(() => selectedDomisili = v),
            ),
            const SizedBox(height: 16),

            // Filter: Kategori Keluarga
            DropdownButtonFormField<String>(
              value: selectedKategori,
              decoration: const InputDecoration(
                labelText: "Kategori Keluarga",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "mampu", child: Text("Mampu")),
                DropdownMenuItem(value: "tidak_mampu", child: Text("Tidak Mampu")),
                DropdownMenuItem(value: "rentan", child: Text("Rentan")),
              ],
              onChanged: (v) => setState(() => selectedKategori = v),
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
              "nama_kepala": namaKepalaController.text.trim(),
              "status": selectedStatusKeluarga,
              "domisili": selectedDomisili,
              "kategori": selectedKategori,
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