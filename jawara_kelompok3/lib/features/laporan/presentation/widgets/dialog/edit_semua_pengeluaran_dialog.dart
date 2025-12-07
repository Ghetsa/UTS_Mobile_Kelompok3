import 'package:flutter/material.dart';
import '../../../data/services/semua_pengeluaran_service.dart';
import '../../../data/models/semua_pengeluaran_model.dart';

class EditPengeluaranDialog extends StatefulWidget {
  final PengeluaranModel pengeluaran;

  const EditPengeluaranDialog({super.key, required this.pengeluaran});

  @override
  _EditPengeluaranDialogState createState() => _EditPengeluaranDialogState();
}

class _EditPengeluaranDialogState extends State<EditPengeluaranDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController namaCtrl;
  late TextEditingController nominalCtrl;
  late TextEditingController tanggalCtrl;
  late TextEditingController jenisCtrl;

  @override
  void initState() {
    super.initState();
    namaCtrl = TextEditingController(text: widget.pengeluaran.nama);
    nominalCtrl = TextEditingController(text: widget.pengeluaran.nominal);
    tanggalCtrl = TextEditingController(text: widget.pengeluaran.tanggal);
    jenisCtrl = TextEditingController(text: widget.pengeluaran.jenis);
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final updated = PengeluaranModel(
        id: widget.pengeluaran.id,
        nama: namaCtrl.text.trim(),
        jenis: jenisCtrl.text.trim(),
        tanggal: tanggalCtrl.text.trim(),
        nominal: nominalCtrl.text.trim(),
        createdAt: widget.pengeluaran.createdAt,
        updatedAt: DateTime.now(),
      );
      Navigator.pop(context, updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Edit Pengeluaran", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(controller: namaCtrl, decoration: const InputDecoration(labelText: "Nama"), validator: (val) => val!.isEmpty ? "Wajib diisi" : null),
              const SizedBox(height: 12),
              TextFormField(controller: jenisCtrl, decoration: const InputDecoration(labelText: "Jenis Pengeluaran"), validator: (val) => val!.isEmpty ? "Wajib diisi" : null),
              const SizedBox(height: 12),
              TextFormField(controller: tanggalCtrl, decoration: const InputDecoration(labelText: "Tanggal"), validator: (val) => val!.isEmpty ? "Wajib diisi" : null),
              const SizedBox(height: 12),
              TextFormField(controller: nominalCtrl, decoration: const InputDecoration(labelText: "Nominal"), validator: (val) => val!.isEmpty ? "Wajib diisi" : null),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
                  const SizedBox(width: 8),
                  ElevatedButton(onPressed: _save, child: const Text("Simpan")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
