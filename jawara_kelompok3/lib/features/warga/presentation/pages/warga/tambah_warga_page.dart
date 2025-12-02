import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../controller/warga_controller.dart';
import '../../../data/models/warga_model.dart';

class TambahWargaPage extends StatefulWidget {
  const TambahWargaPage({super.key});

  @override
  State<TambahWargaPage> createState() => _TambahWargaPageState();
}

class _TambahWargaPageState extends State<TambahWargaPage> {
  final _formKey = GlobalKey<FormState>();

  // CONTROLLER INPUT
  final TextEditingController namaC = TextEditingController();
  final TextEditingController nikC = TextEditingController();
  final TextEditingController noKkC = TextEditingController();
  final TextEditingController noHpC = TextEditingController();
  final TextEditingController agamaC = TextEditingController();
  final TextEditingController pendidikanC = TextEditingController();
  final TextEditingController pekerjaanC = TextEditingController();
  final TextEditingController idRumahC = TextEditingController();

  // FIELD LAIN
  String jenisKelamin = "p"; // default
  String statusWarga = "aktif";
  DateTime? tanggalLahir;

  final wargaController = WargaController();

  Future<void> onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();

    final warga = WargaModel(
      docId: "", // docId akan di-generate Firestore, jadi kosong dulu
      uid: now.millisecondsSinceEpoch.toString(),
      nama: namaC.text.trim(),
      nik: nikC.text.trim(),
      noKk: noKkC.text.trim(),
      noHp: noHpC.text.trim(),
      agama: agamaC.text.trim(),
      jenisKelamin: jenisKelamin,
      pekerjaan: pekerjaanC.text.trim(),
      pendidikan: pendidikanC.text.trim(),
      idRumah: idRumahC.text.trim(),
      statusWarga: statusWarga,
      tanggalLahir: tanggalLahir ?? now,
      createdAt: now,
      updatedAt: now,
    );

    final success = await wargaController.addWarga(warga);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Warga berhasil ditambahkan")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menambahkan warga"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickTanggalLahir() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: tanggalLahir ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => tanggalLahir = picked);
    }
  }

  @override
  void dispose() {
    namaC.dispose();
    nikC.dispose();
    noKkC.dispose();
    noHpC.dispose();
    agamaC.dispose();
    pendidikanC.dispose();
    pekerjaanC.dispose();
    idRumahC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Warga")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: namaC,
                decoration: const InputDecoration(labelText: "Nama"),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "Nama wajib diisi" : null,
              ),
              TextFormField(
                controller: nikC,
                decoration: const InputDecoration(labelText: "NIK"),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "NIK wajib diisi" : null,
              ),
              TextFormField(
                controller: noKkC,
                decoration: const InputDecoration(labelText: "No KK"),
              ),
              TextFormField(
                controller: noHpC,
                decoration: const InputDecoration(labelText: "No HP"),
              ),
              TextFormField(
                controller: agamaC,
                decoration: const InputDecoration(labelText: "Agama"),
              ),
              TextFormField(
                controller: pendidikanC,
                decoration: const InputDecoration(labelText: "Pendidikan"),
              ),
              TextFormField(
                controller: pekerjaanC,
                decoration: const InputDecoration(labelText: "Pekerjaan"),
              ),
              TextFormField(
                controller: idRumahC,
                decoration: const InputDecoration(labelText: "ID Rumah"),
              ),

              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: jenisKelamin,
                decoration:
                    const InputDecoration(labelText: "Jenis Kelamin"),
                items: const [
                  DropdownMenuItem(value: "l", child: Text("Laki-laki")),
                  DropdownMenuItem(value: "p", child: Text("Perempuan")),
                ],
                onChanged: (v) {
                  if (v != null) {
                    setState(() => jenisKelamin = v);
                  }
                },
              ),

              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: statusWarga,
                decoration:
                    const InputDecoration(labelText: "Status Warga"),
                items: const [
                  DropdownMenuItem(value: "aktif", child: Text("Aktif")),
                  DropdownMenuItem(value: "nonaktif", child: Text("Nonaktif")),
                ],
                onChanged: (v) {
                  if (v != null) {
                    setState(() => statusWarga = v);
                  }
                },
              ),

              const SizedBox(height: 12),
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: "Tanggal Lahir",
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        tanggalLahir == null
                            ? "--/--/----"
                            : "${tanggalLahir!.day.toString().padLeft(2, '0')}-"
                              "${tanggalLahir!.month.toString().padLeft(2, '0')}-"
                              "${tanggalLahir!.year}",
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: _pickTanggalLahir,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onSubmit,
                child: const Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
