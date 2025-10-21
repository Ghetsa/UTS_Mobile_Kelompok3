import 'package:flutter/material.dart';
import '../../../Theme/app_theme.dart';

class EditRumahDialog extends StatefulWidget {
  final Map<String, dynamic> rumah;

  const EditRumahDialog({super.key, required this.rumah});

  @override
  State<EditRumahDialog> createState() => _EditRumahDialogState();
}

class _EditRumahDialogState extends State<EditRumahDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _noController;
  late TextEditingController _alamatController;
  late TextEditingController _statusController;
  late TextEditingController _kepemilikanController;
  late TextEditingController _penghuniController;

  @override
  void initState() {
    super.initState();
    _noController = TextEditingController(text: widget.rumah['no'].toString());
    _alamatController = TextEditingController(text: widget.rumah['alamat']);
    _statusController = TextEditingController(text: widget.rumah['status']);
    _kepemilikanController =
        TextEditingController(text: widget.rumah['kepemilikan']);
    _penghuniController =
        TextEditingController(text: widget.rumah['penghuni']);
  }

  @override
  void dispose() {
    _noController.dispose();
    _alamatController.dispose();
    _statusController.dispose();
    _kepemilikanController.dispose();
    _penghuniController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (_formKey.currentState!.validate()) {
      final updated = {
        "no": _noController.text,
        "alamat": _alamatController.text,
        "status": _statusController.text,
        "kepemilikan": _kepemilikanController.text,
        "penghuni": _penghuniController.text,
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
                const Text("Edit Rumah",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                const Text("Ubah data rumah yang diperlukan.",
                    style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 24),

                _buildField("Nomor Rumah", _noController),
                const SizedBox(height: 16),
                _buildField("Alamat", _alamatController),
                const SizedBox(height: 16),
                _buildField("Status", _statusController),
                const SizedBox(height: 16),
                _buildField("Status Kepemilikan", _kepemilikanController),
                const SizedBox(height: 16),
                _buildField("Penghuni", _penghuniController),
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
