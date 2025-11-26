import 'package:flutter/material.dart';
import '../../../data/models/rumah_model.dart';
import '../../../data/services/rumah_service.dart';

class TambahRumahPage extends StatefulWidget {
  const TambahRumahPage({super.key});

  @override
  State<TambahRumahPage> createState() => _TambahRumahPageState();
}

class _TambahRumahPageState extends State<TambahRumahPage> {
  final _alamatC = TextEditingController();
  final _penghuniC = TextEditingController();
  String? _status = "Tersedia";
  String? _kepemilikan = "Kosong";
  final RumahService _service = RumahService();
  bool _loading = false;

  Future<void> _save() async {
    setState(() => _loading = true);
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final rumah = RumahModel(
      id: id,
      alamat: _alamatC.text,
      status: _status ?? "Tersedia",
      kepemilikan: _kepemilikan ?? "Kosong",
      penghuni: _penghuniC.text.isEmpty ? '-' : _penghuniC.text,
      idRumah: null,
      createdAt: DateTime.now(),
    );
    final ok = await _service.addRumah(rumah);
    setState(() => _loading = false);
    if (ok)
      Navigator.pop(context, true);
    else
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Gagal tambah rumah")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Rumah')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
                controller: _alamatC,
                decoration: const InputDecoration(labelText: 'Alamat')),
            const SizedBox(height: 8),
            TextField(
                controller: _penghuniC,
                decoration: const InputDecoration(labelText: 'Penghuni')),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _status,
              items: const [
                DropdownMenuItem(value: "Ditempati", child: Text("Ditempati")),
                DropdownMenuItem(value: "Tersedia", child: Text("Tersedia")),
              ],
              onChanged: (v) => setState(() => _status = v),
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _kepemilikan,
              items: const [
                DropdownMenuItem(value: "Pemilik", child: Text("Pemilik")),
                DropdownMenuItem(value: "Penyewa", child: Text("Penyewa")),
                DropdownMenuItem(value: "Kosong", child: Text("Kosong")),
              ],
              onChanged: (v) => setState(() => _kepemilikan = v),
              decoration: const InputDecoration(labelText: 'Kepemilikan'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: _loading ? null : _save,
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('Simpan')),
          ],
        ),
      ),
    );
  }
}
