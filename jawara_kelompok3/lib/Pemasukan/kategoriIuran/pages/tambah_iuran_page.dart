import 'package:flutter/material.dart';
import '../../../main.dart';

class TambahKategoriPage extends StatefulWidget {
  const TambahKategoriPage({super.key});

  @override
  State<TambahKategoriPage> createState() => _TambahKategoriPageState();
}

class _TambahKategoriPageState extends State<TambahKategoriPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nominalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Kategori Iuran"),
        backgroundColor: const Color(0xFF2D531A),
        foregroundColor: const Color(0xFFEBDDD0),
      ),
      drawer: const AppSidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(labelText: "Nama Iuran"),
                validator: (value) =>
                    value!.isEmpty ? "Tidak boleh kosong" : null,
              ),
              TextFormField(
                controller: nominalController,
                decoration: const InputDecoration(labelText: "Nominal"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "Tidak boleh kosong" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.save, color: Color(0xFFEBDDD0)),
                label: const Text("Simpan"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D531A),
                  foregroundColor: const Color(0xFFEBDDD0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
