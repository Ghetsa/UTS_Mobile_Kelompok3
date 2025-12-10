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
  String? _selectedStatus; // To handle status selection

  final List<String> _statusList = ["Belum Dibayar", "Sudah Dibayar"];

  @override
  void initState() {
    super.initState();
    _keluargaController = TextEditingController(text: widget.tagihan.keluarga);
    _iuranController = TextEditingController(text: widget.tagihan.iuran);
    _nominalController = TextEditingController(text: widget.tagihan.nominal);
    _selectedStatus = widget.tagihan.tagihanStatus; // Default to current status
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
        keluarga: widget.tagihan.keluarga, // No change to this
        status: widget.tagihan.status, // No change to this
        iuran: widget.tagihan.iuran, // No change to this
        kode: widget.tagihan.kode, // No change to this
        nominal: widget.tagihan.nominal, // No change to this
        periode: widget.tagihan.periode, // No change to this
        tagihanStatus: _selectedStatus!, // Only status changes
      );

      Navigator.pop(context, updatedTagihan); // Send back updated data
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
              const Text("Ubah status tagihan yang diperlukan.",
                  style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 24),

              // Nama Keluarga - Read only, non-editable
              TextFormField(
                controller: _keluargaController,
                decoration: const InputDecoration(labelText: "Nama Keluarga"),
                readOnly: true,
              ),
              const SizedBox(height: 16),

              // Iuran - Read only, non-editable
              TextFormField(
                controller: _iuranController,
                decoration: const InputDecoration(labelText: "Iuran"),
                readOnly: true,
              ),
              const SizedBox(height: 16),

              // Nominal - Read only, non-editable
              TextFormField(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Nominal (Rp)"),
                readOnly: true,
              ),
              const SizedBox(height: 16),

              // Status - Dropdown (Editable)
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(labelText: "Status Tagihan"),
                items: _statusList.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(
                      status,
                      style: TextStyle(
                        color: status == "Sudah Dibayar"
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Action buttons
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
