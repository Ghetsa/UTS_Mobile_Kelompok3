import 'package:flutter/material.dart';
import '../../../controller/warga_controller.dart';
import '../../../data/models/warga_model.dart';

class TambahWargaPage extends StatefulWidget {
  const TambahWargaPage({super.key});

  @override
  State<TambahWargaPage> createState() => _TambahWargaPageState();
}

class _TambahWargaPageState extends State<TambahWargaPage> {
  // CONTROLLER INPUT
  TextEditingController namaC = TextEditingController();
  TextEditingController nikC = TextEditingController();
  TextEditingController noKkC = TextEditingController();
  TextEditingController noHpC = TextEditingController();
  TextEditingController agamaC = TextEditingController();
  TextEditingController pendidikanC = TextEditingController();
  TextEditingController pekerjaanC = TextEditingController();
  TextEditingController idRumahC = TextEditingController();

  // FIELD LAIN
  String jenisKelamin = "p"; // default
  String statusWarga = "aktif";
  DateTime? tanggalLahir;

  final wargaController = WargaController();

  Future<void> onSubmit() async {
    final warga = WargaModel(
      uid: DateTime.now().millisecondsSinceEpoch.toString(),
      nama: namaC.text,
      nik: nikC.text,
      noKk: noKkC.text,
      noHp: noHpC.text,
      agama: agamaC.text,
      jenisKelamin: jenisKelamin,
      pendidikan: pendidikanC.text,
      pekerjaan: pekerjaanC.text,
      statusWarga: statusWarga,
      idRumah: idRumahC.text,
      tanggalLahir: tanggalLahir ?? DateTime.now(),
      createdAt: DateTime.now(),
    );

    await wargaController.addWarga(warga);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Warga berhasil ditambahkan")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Warga")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
              controller: noKkC,
              decoration: const InputDecoration(labelText: "No KK"),
            ),
            TextField(
              controller: noHpC,
              decoration: const InputDecoration(labelText: "No HP"),
            ),
            TextField(
              controller: agamaC,
              decoration: const InputDecoration(labelText: "Agama"),
            ),
            TextField(
              controller: pendidikanC,
              decoration: const InputDecoration(labelText: "Pendidikan"),
            ),
            TextField(
              controller: pekerjaanC,
              decoration: const InputDecoration(labelText: "Pekerjaan"),
            ),
            TextField(
              controller: idRumahC,
              decoration: const InputDecoration(labelText: "ID Rumah"),
            ),

            const SizedBox(height: 10),
            DropdownButtonFormField(
              value: jenisKelamin,
              decoration: const InputDecoration(labelText: "Jenis Kelamin"),
              items: const [
                DropdownMenuItem(value: "l", child: Text("Laki-laki")),
                DropdownMenuItem(value: "p", child: Text("Perempuan")),
              ],
              onChanged: (v) {
                setState(() => jenisKelamin = v.toString());
              },
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: onSubmit,
              child: const Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}
