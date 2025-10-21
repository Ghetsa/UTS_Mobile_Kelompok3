import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class EditTagihanDialog extends StatefulWidget {
  final Map<String, dynamic> tagihan;

  const EditTagihanDialog({super.key, required this.tagihan});

  @override
  State<EditTagihanDialog> createState() => _EditTagihanDialogState();
}

class _EditTagihanDialogState extends State<EditTagihanDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _keluargaController;
  late TextEditingController _iuranController;
  late TextEditingController _nominalController;

  @override
  void initState() {
    super.initState();
    _keluargaController =
        TextEditingController(text: widget.tagihan['keluarga']);
    _iuranController = TextEditingController(text: widget.tagihan['iuran']);
    _nominalController = TextEditingController(text: widget.tagihan['nominal']);
  }

  @override
  void dispose() {
    _keluargaController.dispose();
    _iuranController.dispose();
    _nominalController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (_formKey.currentState!.validate()) {
      final updated = {
        "keluarga": _keluargaController.text,
        "iuran": _iuranController.text,
        "nominal": _nominalController.text,
      };
      Navigator.pop(context, updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Edit Tagihan",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text("Ubah data tagihan yang diperlukan.",
                  style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 24),

              TextFormField(
                controller: _keluargaController,
                decoration: const InputDecoration(
                    labelText: "Nama Keluarga",
                    border: OutlineInputBorder()),
                validator: (val) =>
                    val == null || val.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _iuranController,
                decoration: const InputDecoration(
                    labelText: "Iuran", border: OutlineInputBorder()),
                validator: (val) =>
                    val == null || val.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: "Nominal (Rp)",
                    border: OutlineInputBorder()),
                validator: (val) =>
                    val == null || val.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(foregroundColor: Colors.black54),
                    child: const Text("Batal"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _simpan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child:
                        const Text("Simpan", style: TextStyle(color: Colors.white)),
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
