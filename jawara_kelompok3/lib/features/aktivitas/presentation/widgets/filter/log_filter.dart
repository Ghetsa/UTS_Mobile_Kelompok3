import 'package:flutter/material.dart';

class FilterLogDialog extends StatefulWidget {
  final Function(Map<String, dynamic> filterData) onApply;

  const FilterLogDialog({super.key, required this.onApply});

  @override
  State<FilterLogDialog> createState() => _FilterLogDialogState();
}

class _FilterLogDialogState extends State<FilterLogDialog> {
  String? selectedRole;
  DateTime? startDate;
  DateTime? endDate;

  Future<void> _pickDate({required bool isStart}) async {
    final initialDate = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Filter Log",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dropdown Role
            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration: const InputDecoration(
                  labelText: "Aktor / Role", border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: "admin", child: Text("Admin")),
                DropdownMenuItem(value: "warga", child: Text("Warga")),
              ],
              onChanged: (v) => setState(() => selectedRole = v),
            ),
            const SizedBox(height: 16),

            // Tanggal Mulai
            GestureDetector(
              onTap: () => _pickDate(isStart: true),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Tanggal Mulai",
                    border: const OutlineInputBorder(),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                      text: startDate != null
                          ? "${startDate!.day}/${startDate!.month}/${startDate!.year}"
                          : ""),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tanggal Selesai
            GestureDetector(
              onTap: () => _pickDate(isStart: false),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Tanggal Selesai",
                    border: const OutlineInputBorder(),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                      text: endDate != null
                          ? "${endDate!.day}/${endDate!.month}/${endDate!.year}"
                          : ""),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal")),
        ElevatedButton(
          onPressed: () {
            final filterData = {
              "role": selectedRole,
              "start_date": startDate,
              "end_date": endDate,
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
