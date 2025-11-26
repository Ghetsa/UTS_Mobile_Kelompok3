import 'package:flutter/material.dart';
import '../../../data/models/mutasi_model.dart';
import '../../../data/services/mutasi_service.dart';

class EditMutasiDialog extends StatefulWidget {
  final MutasiModel data;

  const EditMutasiDialog({super.key, required this.data});

  @override
  State<EditMutasiDialog> createState() => _EditMutasiDialogState();
}

class _EditMutasiDialogState extends State<EditMutasiDialog> {
  final _service = MutasiService();

  late TextEditingController alasanC;
  late String jenis;

  @override
  void initState() {
    super.initState();
    alasanC = TextEditingController(text: widget.data.alasan);
    jenis = widget.data.jenis;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Mutasi"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField(
            value: jenis,
            items: const [
              DropdownMenuItem(value: "Masuk", child: Text("Masuk")),
              DropdownMenuItem(value: "Keluar", child: Text("Keluar")),
            ],
            decoration: const InputDecoration(labelText: "Jenis"),
            onChanged: (v) => jenis = v!,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: alasanC,
            decoration: const InputDecoration(labelText: "Alasan"),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal")),
        ElevatedButton(
          onPressed: () async {
            await _service.updateMutasi(widget.data.uid, {
              "jenis": jenis,
              "alasan": alasanC.text,
            });
            Navigator.pop(context, true);
          },
          child: const Text("Simpan"),
        ),
      ],
    );
  }
}
