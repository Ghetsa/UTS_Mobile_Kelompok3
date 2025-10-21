import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class EditPengeluaranDialog extends StatefulWidget {
  final Map<String, dynamic> pengeluaran;

  const EditPengeluaranDialog({super.key, required this.pengeluaran});

  @override
  State<EditPengeluaranDialog> createState() => _EditPengeluaranDialogState();
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
    namaCtrl = TextEditingController(text: widget.pengeluaran["nama"]);
    nominalCtrl = TextEditingController(text: widget.pengeluaran["nominal"]);
    tanggalCtrl = TextEditingController(text: widget.pengeluaran["tanggal"]);
    jenisCtrl = TextEditingController(text: widget.pengeluaran["jenis"]);
  }

  void _simpan() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        "no": widget.pengeluaran["no"],
        "nama": namaCtrl.text,
        "jenis": jenisCtrl.text,
        "tanggal": tanggalCtrl.text,
        "nominal": nominalCtrl.text,
      });
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Edit Pengeluaran",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: namaCtrl,
                decoration: const InputDecoration(labelText: "Nama"),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: jenisCtrl,
                decoration:
                    const InputDecoration(labelText: "Jenis Pengeluaran"),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: tanggalCtrl,
                decoration: const InputDecoration(labelText: "Tanggal"),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: nominalCtrl,
                decoration: const InputDecoration(labelText: "Nominal"),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Batal"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _simpan,
                    child: const Text("Simpan"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
