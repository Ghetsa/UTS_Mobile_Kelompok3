import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class EditKeluargaDialog extends StatefulWidget {
  final Map<String, dynamic> keluarga;

  const EditKeluargaDialog({super.key, required this.keluarga});

  @override
  State<EditKeluargaDialog> createState() => _EditKeluargaDialogState();
}

class _EditKeluargaDialogState extends State<EditKeluargaDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaKeluargaController;
  late TextEditingController _kepalaController;
  late TextEditingController _alamatController;
  late TextEditingController _statusKepemilikanController;
  late TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    _namaKeluargaController =
        TextEditingController(text: widget.keluarga['namaKeluarga']);
    _kepalaController =
        TextEditingController(text: widget.keluarga['kepalaKeluarga']);
    _alamatController = TextEditingController(text: widget.keluarga['alamat']);
    _statusKepemilikanController =
        TextEditingController(text: widget.keluarga['statusKepemilikan']);
    _statusController = TextEditingController(text: widget.keluarga['status']);
  }

  @override
  void dispose() {
    _namaKeluargaController.dispose();
    _kepalaController.dispose();
    _alamatController.dispose();
    _statusKepemilikanController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (_formKey.currentState!.validate()) {
      final updated = {
        "namaKeluarga": _namaKeluargaController.text,
        "kepalaKeluarga": _kepalaController.text,
        "alamat": _alamatController.text,
        "statusKepemilikan": _statusKepemilikanController.text,
        "status": _statusController.text,
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Edit Keluarga",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                const Text("Ubah data keluarga yang diperlukan.",
                    style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 24),

                _buildField("Nama Keluarga", _namaKeluargaController),
                const SizedBox(height: 16),
                _buildField("Kepala Keluarga", _kepalaController),
                const SizedBox(height: 16),
                _buildField("Alamat", _alamatController),
                const SizedBox(height: 16),
                _buildField("Status Kepemilikan", _statusKepemilikanController),
                const SizedBox(height: 16),
                _buildField("Status", _statusController),
                const SizedBox(height: 24),

                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
      validator: (val) => val == null || val.isEmpty ? "Wajib diisi" : null,
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
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
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text("Simpan",
              style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
