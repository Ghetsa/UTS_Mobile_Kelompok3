import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../data/models/tagihan_model.dart';

class EditTagihanDialog extends StatefulWidget {
  final TagihanModel tagihan;

  const EditTagihanDialog({super.key, required this.tagihan});

  @override
  _EditTagihanDialogState createState() => _EditTagihanDialogState();
}

class _EditTagihanDialogState extends State<EditTagihanDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _keluargaController;
  late TextEditingController _iuranController;
  late TextEditingController _nominalController;

  @override
  void initState() {
    super.initState();
    _keluargaController = TextEditingController(text: widget.tagihan.keluarga);
    _iuranController = TextEditingController(text: widget.tagihan.iuran);
    _nominalController = TextEditingController(text: widget.tagihan.nominal);
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
      final updatedTagihan = TagihanModel(
        id: widget.tagihan.id,
        keluarga: _keluargaController.text,
        status: widget.tagihan.status,
        iuran: _iuranController.text,
        kode: widget.tagihan.kode,
        nominal: _nominalController.text,
        periode: widget.tagihan.periode,
        tagihanStatus: widget.tagihan.tagihanStatus,
      );

      Navigator.pop(context, updatedTagihan);
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
                decoration: const InputDecoration(labelText: "Nama Keluarga"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _iuranController,
                decoration: const InputDecoration(labelText: "Iuran"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Nominal (Rp)"),
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
                    child: const Text("Simpan", style: TextStyle(color: Colors.white)),
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
