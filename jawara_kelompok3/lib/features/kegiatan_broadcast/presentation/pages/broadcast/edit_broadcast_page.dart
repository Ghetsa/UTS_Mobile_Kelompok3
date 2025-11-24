import 'package:flutter/material.dart';
// uses Theme.of(context) for colors

class EditBroadcastDialog extends StatefulWidget {
  final Map<String, String> broadcast;

  const EditBroadcastDialog({super.key, required this.broadcast});

  @override
  State<EditBroadcastDialog> createState() => _EditBroadcastDialogState();
}

class _EditBroadcastDialogState extends State<EditBroadcastDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judulController;
  late TextEditingController _isiController;
  late TextEditingController _tanggalController;
  late TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.broadcast['judul']);
    _isiController = TextEditingController(text: widget.broadcast['isi']);
    _tanggalController =
        TextEditingController(text: widget.broadcast['tanggal']);
    _statusController = TextEditingController(text: widget.broadcast['status']);
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pop(context, {
        'no': widget.broadcast['no'] ?? '',
        'judul': _judulController.text,
        'isi': _isiController.text,
        'tanggal': _tanggalController.text,
        'status': _statusController.text,
      });
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
                'Edit Broadcast',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(labelText: 'Judul Broadcast'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _isiController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Isi Pesan'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tanggalController,
                decoration: const InputDecoration(labelText: 'Tanggal'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _save,
                    child: const Text('Simpan'),
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
