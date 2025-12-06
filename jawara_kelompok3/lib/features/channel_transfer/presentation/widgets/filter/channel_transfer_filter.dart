import 'package:flutter/material.dart';

class FilterChannelDialog extends StatefulWidget {
  final Function(Map<String, dynamic> filterData) onApply;

  const FilterChannelDialog({
    super.key,
    required this.onApply,
  });

  @override
  State<FilterChannelDialog> createState() => _FilterChannelDialogState();
}

class _FilterChannelDialogState extends State<FilterChannelDialog> {
  TextEditingController namaController = TextEditingController();

  String? selectedTipe;
  String? selectedStatus;
  String? selectedThumbnail;
  DateTime? selectedDate;

  Future<void> pickDate() async {
    final now = DateTime.now();
    final result = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 1),
    );

    if (result != null) {
      setState(() => selectedDate = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Filter Channel Transfer",
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
                labelText: "Nama Channel",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Tipe
            DropdownButtonFormField<String>(
              value: selectedTipe,
              decoration: const InputDecoration(
                labelText: "Tipe Channel",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "manual", child: Text("Manual")),
                DropdownMenuItem(value: "otomatis", child: Text("Otomatis")),
                DropdownMenuItem(value: "qr", child: Text("QR Code")),
              ],
              onChanged: (v) => setState(() => selectedTipe = v),
            ),
            const SizedBox(height: 16),

            // Status
            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: const InputDecoration(
                labelText: "Status Channel",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "aktif", child: Text("Aktif")),
                DropdownMenuItem(value: "nonaktif", child: Text("Nonaktif")),
              ],
              onChanged: (v) => setState(() => selectedStatus = v),
            ),
            const SizedBox(height: 16),

            // Memiliki Thumbnail?
            DropdownButtonFormField<String>(
              value: selectedThumbnail,
              decoration: const InputDecoration(
                labelText: "Memiliki Thumbnail?",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "ya", child: Text("Ya")),
                DropdownMenuItem(value: "tidak", child: Text("Tidak")),
              ],
              onChanged: (v) => setState(() => selectedThumbnail = v),
            ),
            const SizedBox(height: 16),

            // Tanggal Dibuat
            GestureDetector(
              onTap: pickDate,
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Tanggal Dibuat",
                    hintText: selectedDate == null
                        ? "Pilih tanggal"
                        : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                    border: const OutlineInputBorder(),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                ),
              ),
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
              "tipe": selectedTipe,
              "status": selectedStatus,
              "thumbnail": selectedThumbnail,
              "created_at": selectedDate,
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
