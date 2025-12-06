import 'package:flutter/material.dart';
import '../../../data/services/kategori_iuran_service.dart';
import '../../../data/models/kategori_iuran_model.dart';

class EditIuranDialog extends StatefulWidget {
  final Map<String, String?> iuran; // Mengubah Map menjadi Map<String, String?>

  const EditIuranDialog({super.key, required this.iuran});

  @override
  State<EditIuranDialog> createState() => _EditIuranDialogState();
}

class _EditIuranDialogState extends State<EditIuranDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController namaCtrl;
  late TextEditingController nominalCtrl;
  late TextEditingController jenisCtrl;
  final KategoriIuranService _service = KategoriIuranService();

  @override
  void initState() {
    super.initState();
    // Menangani nilai null dengan cara memberi nilai default jika null
    namaCtrl = TextEditingController(text: widget.iuran["nama"] ?? '');
    nominalCtrl = TextEditingController(text: widget.iuran["nominal"] ?? '');
    jenisCtrl = TextEditingController(text: widget.iuran["jenis"] ?? '');
  }

  void _simpan() {
    if (_formKey.currentState!.validate()) {
      final updated = KategoriIuranModel(
        id: widget.iuran['id']!, // Pastikan id tidak null
        nama: namaCtrl.text.trim(),
        jenis: jenisCtrl.text.trim(),
        nominal: nominalCtrl.text.trim(),
        createdAt: widget.iuran['created_at'] != null
            ? DateTime.parse(widget.iuran['created_at']!)
            : null, // Pastikan created_at diubah menjadi DateTime jika tidak null
        updatedAt: DateTime.now(),
      );

      Navigator.pop(context, updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                "Edit Kategori Iuran",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: namaCtrl,
                decoration: const InputDecoration(labelText: "Nama Iuran"),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: jenisCtrl,
                decoration: const InputDecoration(labelText: "Jenis Iuran"),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: nominalCtrl,
                decoration: const InputDecoration(labelText: "Nominal (Rp)"),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
                keyboardType: TextInputType.number,
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
                      backgroundColor: theme.colorScheme.primary,
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
