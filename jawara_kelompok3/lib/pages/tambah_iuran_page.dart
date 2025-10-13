import 'package:flutter/material.dart';

class TambahIuranPage extends StatefulWidget {
  const TambahIuranPage({super.key});

  @override
  State<TambahIuranPage> createState() => _TambahIuranPageState();
}

class _TambahIuranPageState extends State<TambahIuranPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nominalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Iuran")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(labelText: "Nama Iuran"),
                validator: (value) => value!.isEmpty ? "Tidak boleh kosong" : null,
              ),
              TextFormField(
                controller: nominalController,
                decoration: const InputDecoration(labelText: "Nominal"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Tidak boleh kosong" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context);
                  }
                },
                child: const Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
