import 'package:flutter/material.dart';

class TambahMutasiPage extends StatefulWidget {
  const TambahMutasiPage({super.key});

  @override
  State<TambahMutasiPage> createState() => _TambahMutasiPageState();
}

class _TambahMutasiPageState extends State<TambahMutasiPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();
  DateTime? _selectedDate;
  String? _kategori;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mutasi Keluarga - Tambah",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4B3D1A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                const Text(
                  "Form Tambah Mutasi Keluarga",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Nama pemasukan
                TextField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: "Nama Pemasukan",
                    hintText: "Masukkan nama pemasukan",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Tanggal
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: "Tanggal Pemasukan",
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? "--/--/----"
                              : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Kategori
                DropdownButtonFormField<String>(
                  initialValue: _kategori,
                  decoration: const InputDecoration(
                    labelText: "Kategori Pemasukan",
                    border: OutlineInputBorder(),
                  ),
                  items: ["Pendapatan Lainnya", "Donasi", "Sumbangan"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _kategori = value;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Nominal
                TextField(
                  controller: _nominalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Nominal",
                    hintText: "Masukkan nominal pemasukan",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Upload bukti
                Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text("Upload bukti pemasukan (.png/.jpg)"),
                ),
                const SizedBox(height: 16),

                // Tombol
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        // Simpan logika submit
                      },
                      child: const Text("Submit"),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton(
                      onPressed: () {
                        _namaController.clear();
                        _nominalController.clear();
                        setState(() {
                          _selectedDate = null;
                          _kategori = null;
                        });
                      },
                      child: const Text("Reset"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
