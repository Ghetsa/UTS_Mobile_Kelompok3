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

  late TextEditingController keteranganC;
  late String jenisMutasi;

  @override
  void initState() {
    super.initState();
    keteranganC = TextEditingController(text: widget.data.keterangan);
    jenisMutasi = widget.data.jenisMutasi;
  }

  @override
  void dispose() {
    keteranganC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Mutasi"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: jenisMutasi,
            items: const [
              DropdownMenuItem(value: "Masuk", child: Text("Masuk")),
              DropdownMenuItem(value: "Keluar", child: Text("Keluar")),
            ],
            decoration: const InputDecoration(labelText: "Jenis Mutasi"),
            onChanged: (v) {
              if (v != null) {
                setState(() => jenisMutasi = v);
              }
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: keteranganC,
            decoration: const InputDecoration(labelText: "Keterangan"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () async {
            await _service.updateMutasi(widget.data.uid, {
              "jenis_mutasi": jenisMutasi,
              "keterangan": keteranganC.text,
              // kalau mau, di sini juga bisa update "tanggal"
            });

            Navigator.pop(context, true); // return true = sukses
          },
          child: const Text("Simpan"),
        ),
      ],
    );
  }
}
