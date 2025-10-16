import 'package:flutter/material.dart';

class FilterTagihanDialog extends StatefulWidget {
  const FilterTagihanDialog({super.key});

  @override
  State<FilterTagihanDialog> createState() => _FilterTagihanDialogState();
}

class _FilterTagihanDialogState extends State<FilterTagihanDialog> {
  String? statusPembayaran;
  String? statusKeluarga;
  String? keluarga;
  String? iuran;
  DateTime? periode;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text(
        "Filter Tagihan Warga",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status Pembayaran
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Status Pembayaran"),
              items: const [
                DropdownMenuItem(value: "Lunas", child: Text("Lunas")),
                DropdownMenuItem(value: "Belum Dibayar", child: Text("Belum Dibayar")),
              ],
              value: statusPembayaran,
              onChanged: (val) => setState(() => statusPembayaran = val),
            ),
            const SizedBox(height: 12),

            // Status Keluarga
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Status Keluarga"),
              items: const [
                DropdownMenuItem(value: "Aktif", child: Text("Aktif")),
                DropdownMenuItem(value: "Tidak Aktif", child: Text("Tidak Aktif")),
              ],
              value: statusKeluarga,
              onChanged: (val) => setState(() => statusKeluarga = val),
            ),
            const SizedBox(height: 12),

            // Keluarga
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Keluarga"),
              items: const [
                DropdownMenuItem(value: "Keluarga Habibie Ed Dien", child: Text("Keluarga Habibie Ed Dien")),
                DropdownMenuItem(value: "Keluarga Mara Nunez", child: Text("Keluarga Mara Nunez")),
              ],
              value: keluarga,
              onChanged: (val) => setState(() => keluarga = val),
            ),
            const SizedBox(height: 12),

            // Iuran
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Iuran"),
              items: const [
                DropdownMenuItem(value: "Mingguan", child: Text("Mingguan")),
                DropdownMenuItem(value: "Agustusan", child: Text("Agustusan")),
              ],
              value: iuran,
              onChanged: (val) => setState(() => iuran = val),
            ),
            const SizedBox(height: 12),

            // Periode
            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Periode (Bulan & Tahun)",
                suffixIcon: Icon(Icons.calendar_today),
              ),
              controller: TextEditingController(
                text: periode != null
                    ? "${periode!.month}/${periode!.year}"
                    : "--/----",
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  helpText: "Pilih Periode",
                );
                if (picked != null) {
                  setState(() {
                    periode = picked;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              statusPembayaran = null;
              statusKeluarga = null;
              keluarga = null;
              iuran = null;
              periode = null;
            });
          },
          child: const Text("Reset Filter"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              "statusPembayaran": statusPembayaran,
              "statusKeluarga": statusKeluarga,
              "keluarga": keluarga,
              "iuran": iuran,
              "periode": periode,
            });
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
          child: const Text("Terapkan"),
        ),
      ],
    );
  }
}
