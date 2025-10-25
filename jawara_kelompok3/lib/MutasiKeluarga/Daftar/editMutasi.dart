import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class EditMutasiDialog extends StatefulWidget {
  final Map<String, String> mutasi;

  const EditMutasiDialog({super.key, required this.mutasi});

  @override
  State<EditMutasiDialog> createState() => _EditMutasiDialogState();
}

class _EditMutasiDialogState extends State<EditMutasiDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController namaCtrl;
  late TextEditingController alamatCtrl;
  late TextEditingController tanggalCtrl;
  late TextEditingController keteranganCtrl;
  String? jenisMutasi;

  @override
  void initState() {
    super.initState();
    namaCtrl = TextEditingController(text: widget.mutasi["nama"]);
    alamatCtrl = TextEditingController(text: widget.mutasi["alamat"]);
    tanggalCtrl = TextEditingController(text: widget.mutasi["tanggal"]);
    keteranganCtrl = TextEditingController(text: widget.mutasi["keterangan"]);
    jenisMutasi = widget.mutasi["jenis"];
  }

  void _simpan() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        "no": widget.mutasi["no"]!,
        "nama": namaCtrl.text,
        "jenis": jenisMutasi ?? "-",
        "tanggal": tanggalCtrl.text,
        "alamat": alamatCtrl.text,
        "keterangan": keteranganCtrl.text,
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
                "Edit Data Mutasi Keluarga",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: namaCtrl,
                decoration: const InputDecoration(
                  labelText: "Nama Kepala Keluarga",
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: jenisMutasi,
                decoration: const InputDecoration(
                  labelText: "Jenis Mutasi",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: "Masuk", child: Text("Masuk")),
                  DropdownMenuItem(value: "Keluar", child: Text("Keluar")),
                ],
                onChanged: (val) => setState(() => jenisMutasi = val),
                validator: (val) => val == null ? "Pilih jenis mutasi" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: tanggalCtrl,
                decoration: const InputDecoration(
                  labelText: "Tanggal Mutasi",
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      tanggalCtrl.text =
                          "${picked.day}-${picked.month}-${picked.year}";
                    });
                  }
                },
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: alamatCtrl,
                decoration: const InputDecoration(
                  labelText: "Alamat Asal / Tujuan",
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: keteranganCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Keterangan",
                  border: OutlineInputBorder(),
                ),
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
                      backgroundColor: AppTheme.primaryBlue,
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
