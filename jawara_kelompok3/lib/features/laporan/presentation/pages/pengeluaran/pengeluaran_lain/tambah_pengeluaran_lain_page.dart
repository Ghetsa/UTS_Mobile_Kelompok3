import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../controller/pengeluaran_lain_controller.dart';
import '../../../../data/models/pengeluaran_lain_model.dart';

class TambahPengeluaranLainPage extends StatefulWidget {
  final bool isEdit;
  final PengeluaranLainModel? dataEdit;

  const TambahPengeluaranLainPage({
    super.key,
    this.isEdit = false,
    this.dataEdit,
  });

  @override
  State<TambahPengeluaranLainPage> createState() =>
      _TambahPengeluaranLainPageState();
}

class _TambahPengeluaranLainPageState
    extends State<TambahPengeluaranLainPage> {
  final _form = GlobalKey<FormState>();

  final nama = TextEditingController();
  final jenis = TextEditingController();
  final tanggal = TextEditingController();
  final nominal = TextEditingController();

  final controller = PengeluaranLainController();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.dataEdit != null) {
      nama.text = widget.dataEdit!.nama;
      jenis.text = widget.dataEdit!.jenis;
      tanggal.text = widget.dataEdit!.tanggal;
      nominal.text = widget.dataEdit!.nominal.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? "Edit Pengeluaran" : "Tambah Pengeluaran"),
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _input("Nama Pengeluaran", nama),
            _input("Jenis", jenis),

            // Input tanggal dengan date picker
            TextFormField(
              controller: tanggal,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Tanggal",
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: pilihTanggal,
              validator: (v) => v!.isEmpty ? "Tanggal wajib diisi" : null,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: nominal,
              decoration: const InputDecoration(labelText: "Nominal"),
              keyboardType: TextInputType.number,
              validator: (v) => v!.isEmpty ? "Nominal wajib diisi" : null,
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
              ),
              child: const Text("Simpan", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                if (!_form.currentState!.validate()) return;

                final data = {
                  "nama": nama.text,
                  "jenis": jenis.text,
                  "tanggal": tanggal.text,
                  "nominal": int.parse(nominal.text),
                  "bukti_url": null,
                };

                if (widget.isEdit) {
                  await controller.updatePengeluaran(widget.dataEdit!.id, data);
                } else {
                  await controller.addPengeluaran(data);
                }

                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        decoration: InputDecoration(labelText: label),
        validator: (v) => v!.isEmpty ? "$label wajib diisi" : null,
      ),
    );
  }

  Future pilihTanggal() async {
    final pick = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (pick != null) {
      tanggal.text = "${pick.day}/${pick.month}/${pick.year}";
    }
  }
}
