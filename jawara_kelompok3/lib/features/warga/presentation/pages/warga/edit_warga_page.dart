import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/layout/sidebar.dart';

class EditWargaDialog extends StatefulWidget {
  final Map<String, dynamic> warga;

  const EditWargaDialog({super.key, required this.warga});

  @override
  State<EditWargaDialog> createState() => _EditWargaDialogState();
}

class _EditWargaDialogState extends State<EditWargaDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _nikController;
  late TextEditingController _keluargaController;
  late TextEditingController _jenisKelaminController;
  late TextEditingController _statusDomisiliController;
  late TextEditingController _statusHidupController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.warga['nama']);
    _nikController = TextEditingController(text: widget.warga['nik']);
    _keluargaController =
        TextEditingController(text: widget.warga['keluarga']);
    _jenisKelaminController =
        TextEditingController(text: widget.warga['jenisKelamin']);
    _statusDomisiliController =
        TextEditingController(text: widget.warga['statusDomisili']);
    _statusHidupController =
        TextEditingController(text: widget.warga['statusHidup']);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _keluargaController.dispose();
    _jenisKelaminController.dispose();
    _statusDomisiliController.dispose();
    _statusHidupController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (_formKey.currentState!.validate()) {
      final updated = {
        "nama": _namaController.text,
        "nik": _nikController.text,
        "keluarga": _keluargaController.text,
        "jenisKelamin": _jenisKelaminController.text,
        "statusDomisili": _statusDomisiliController.text,
        "statusHidup": _statusHidupController.text,
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Edit Warga",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                const Text("Ubah data warga yang diperlukan.",
                    style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 24),

                _buildField("Nama", _namaController),
                const SizedBox(height: 16),
                _buildField("NIK", _nikController),
                const SizedBox(height: 16),
                _buildField("Keluarga", _keluargaController),
                const SizedBox(height: 16),
                _buildField("Jenis Kelamin", _jenisKelaminController),
                const SizedBox(height: 16),
                _buildField("Status Domisili", _statusDomisiliController),
                const SizedBox(height: 16),
                _buildField("Status Hidup", _statusHidupController),
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
      validator: (val) =>
          val == null || val.isEmpty ? "Wajib diisi" : null,
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
