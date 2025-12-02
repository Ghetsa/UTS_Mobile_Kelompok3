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
  final _nomorC = TextEditingController();
  final _penghuniC = TextEditingController();
  final _rtC = TextEditingController();
  final _rwC = TextEditingController();

  String? _statusRumah = "Dihuni";
  String? _kepemilikan = "Pemilik";

  final RumahService _service = RumahService();
  bool _loading = false;

  Future<void> _save() async {
    if (_alamatC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Alamat wajib diisi")),
      );
      return;
    }

    if (_nomorC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nomor rumah wajib diisi")),
      );
      return;
    }

    setState(() => _loading = true);

    /// id rumah (field "id") bisa kode unik internal
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final rumah = RumahModel(
      docId: "", // biarkan kosong → service akan pakai add()
      id: id,
      alamat: _alamatC.text.trim(),
      nomor: _nomorC.text.trim(), // ⬅️ penting
      statusRumah: _statusRumah ?? "Dihuni",
      kepemilikan: _kepemilikan ?? "Pemilik",
      penghuniKeluargaId: _penghuniC.text.trim(),
      rt: _rtC.text.trim().isEmpty ? "1" : _rtC.text.trim(),
      rw: _rwC.text.trim().isEmpty ? "1" : _rwC.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final ok = await _service.addRumah(rumah);

    setState(() => _loading = false);

    if (!mounted) return;

    if (ok) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menambah rumah")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Rumah')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Alamat
            TextField(
              controller: _alamatC,
              decoration: const InputDecoration(labelText: 'Alamat'),
            ),
            const SizedBox(height: 8),

            // Nomor rumah (field "nomor")
            TextField(
              controller: _nomorC,
              decoration: const InputDecoration(
                labelText: 'Nomor Rumah',
                helperText: 'Contoh: 01, 1A, 12B, dsb.',
              ),
            ),
            const SizedBox(height: 8),

            // Penghuni (ID keluarga)
            TextField(
              controller: _penghuniC,
              decoration: const InputDecoration(
                labelText: 'Penghuni (ID Keluarga)',
                helperText:
                    'Isi dengan ID keluarga (boleh dikosongkan jika belum ada)',
              ),
            ),
            const SizedBox(height: 8),

            // RT / RW
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _rtC,
                    decoration: const InputDecoration(labelText: 'RT'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _rwC,
                    decoration: const InputDecoration(labelText: 'RW'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Status rumah
            DropdownButtonFormField<String>(
              value: _statusRumah,
              items: const [
                DropdownMenuItem(value: "Dihuni", child: Text("Dihuni")),
                DropdownMenuItem(value: "Kosong", child: Text("Kosong")),
                DropdownMenuItem(value: "Renovasi", child: Text("Renovasi")),
              ],
              onChanged: (v) => setState(() => _statusRumah = v),
              decoration: const InputDecoration(labelText: 'Status Rumah'),
            ),
            const SizedBox(height: 8),

            // Kepemilikan
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
                  : const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
