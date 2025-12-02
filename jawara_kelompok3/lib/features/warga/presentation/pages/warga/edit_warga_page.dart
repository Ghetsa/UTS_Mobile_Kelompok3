import 'package:flutter/material.dart';
import '../../../data/models/warga_model.dart';
import '../../../data/services/warga_service.dart';

class EditWargaPage extends StatefulWidget {
  final WargaModel data;

  const EditWargaPage({super.key, required this.data});

  @override
  State<EditWargaPage> createState() => _EditWargaPageState();
}

class _EditWargaPageState extends State<EditWargaPage> {
  final WargaService _service = WargaService();

  late TextEditingController namaC;
  late TextEditingController nikC;
  late TextEditingController noHpC;
  late TextEditingController pekerjaanC;
  late TextEditingController pendidikanC;
  late TextEditingController idRumahC;

  String jenisKelamin = "p";
  String statusWarga = "aktif";
  String? agama;   // ⬅ dropdown agama

  final List<String> agamaList = [
    "Islam",
    "Kristen",
    "Katolik",
    "Hindu",
    "Buddha",
    "Konghucu",
  ];

  @override
  void initState() {
    super.initState();
    final w = widget.data;

    namaC = TextEditingController(text: w.nama);
    nikC = TextEditingController(text: w.nik);
    noHpC = TextEditingController(text: w.noHp);
    pekerjaanC = TextEditingController(text: w.pekerjaan);
    pendidikanC = TextEditingController(text: w.pendidikan);
    idRumahC = TextEditingController(text: w.idRumah);

    jenisKelamin = w.jenisKelamin;
    statusWarga = w.statusWarga;
    agama = w.agama;   // ⬅ set nilai awal dropdown
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Data Warga"),
      content: SizedBox(
        width: 350,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: namaC,
                decoration: const InputDecoration(labelText: "Nama"),
              ),
              TextField(
                controller: nikC,
                decoration: const InputDecoration(labelText: "NIK"),
              ),
              TextField(
                controller: noHpC,
                decoration: const InputDecoration(labelText: "No HP"),
              ),

              // =======================================================
              // 🔵 AGAMA — Ganti dari TextField menjadi Dropdown
              // =======================================================
              DropdownButtonFormField<String>(
                value: agama,
                decoration: const InputDecoration(labelText: "Agama"),
                items: agamaList
                    .map((a) => DropdownMenuItem(
                          value: a,
                          child: Text(a),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => agama = v),
              ),

              TextField(
                controller: pekerjaanC,
                decoration: const InputDecoration(labelText: "Pekerjaan"),
              ),
              TextField(
                controller: pendidikanC,
                decoration: const InputDecoration(labelText: "Pendidikan"),
              ),
              TextField(
                controller: idRumahC,
                decoration: const InputDecoration(labelText: "ID Rumah"),
              ),

              const SizedBox(height: 10),

              DropdownButtonFormField(
                value: jenisKelamin,
                items: const [
                  DropdownMenuItem(value: "l", child: Text("Laki-laki")),
                  DropdownMenuItem(value: "p", child: Text("Perempuan")),
                ],
                decoration: const InputDecoration(labelText: "Jenis Kelamin"),
                onChanged: (v) => setState(() => jenisKelamin = v!),
              ),

              DropdownButtonFormField(
                value: statusWarga,
                items: const [
                  DropdownMenuItem(value: "aktif", child: Text("Aktif")),
                  DropdownMenuItem(value: "nonaktif", child: Text("Tidak Aktif")),
                ],
                decoration: const InputDecoration(labelText: "Status Warga"),
                onChanged: (v) => setState(() => statusWarga = v!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () async {
            final updated = {
              "nama": namaC.text,
              "nik": nikC.text,
              "no_hp": noHpC.text,
              "agama": agama,                    // ⬅ dropdown agama
              "pekerjaan": pekerjaanC.text,
              "pendidikan": pendidikanC.text,
              "id_rumah": idRumahC.text,
              "jenis_kelamin": jenisKelamin,
              "status_warga": statusWarga,
              "updated_at": DateTime.now(),
            };

            await _service.updateWarga(widget.data.docId, updated);
            Navigator.pop(context, true);
          },
          child: 
          const Text("Simpan"),
          

        ),
      ],
    );
  }
}
