import 'package:flutter/material.dart';

class EditKegiatanDialog extends StatefulWidget {
  final Map<String, String> kegiatan;

  const EditKegiatanDialog({super.key, required this.kegiatan});

  @override
  State<EditKegiatanDialog> createState() => _EditKegiatanDialogState();
}

class _EditKegiatanDialogState extends State<EditKegiatanDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController namaCtrl;
  late TextEditingController tanggalCtrl;
  late TextEditingController jenisCtrl;
  late TextEditingController lokasiCtrl;

  @override
  void initState() {
    super.initState();
    namaCtrl = TextEditingController(text: widget.kegiatan["nama"]);
    tanggalCtrl = TextEditingController(text: widget.kegiatan["tanggal"]);
    jenisCtrl = TextEditingController(text: widget.kegiatan["jenis"]);
    lokasiCtrl = TextEditingController(text: widget.kegiatan["lokasi"]);
  }

  void _simpan() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        "no": widget.kegiatan["no"]!,
        "nama": namaCtrl.text,
        "jenis": jenisCtrl.text,
        "tanggal": tanggalCtrl.text,
        "lokasi": lokasiCtrl.text,
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
                "Edit Kegiatan",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: namaCtrl,
                decoration: const InputDecoration(labelText: "Nama Kegiatan"),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: jenisCtrl,
                decoration: const InputDecoration(labelText: "Jenis Kegiatan"),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: tanggalCtrl,
                decoration: const InputDecoration(labelText: "Tanggal Kegiatan"),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: lokasiCtrl,
                decoration: const InputDecoration(labelText: "Lokasi Kegiatan"),
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
