import 'package:flutter/material.dart';
import '../../../../../../../core/theme/app_theme.dart';

class TambahIuranPage extends StatefulWidget {
  final bool isEdit;
  final Map<String, dynamic>? dataEdit;

  const TambahIuranPage({
    super.key,
    this.isEdit = false,
    this.dataEdit,
  });

  @override
  State<TambahIuranPage> createState() => _TambahIuranPageState();
}

class _TambahIuranPageState extends State<TambahIuranPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaC = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.dataEdit != null) {
      namaC.text = widget.dataEdit!["nama"];
    }
  }

  void _simpan() {
    if (_formKey.currentState!.validate()) {
      final data = {
        "id": widget.isEdit ? widget.dataEdit!["id"] : DateTime.now().millisecondsSinceEpoch.toString(),
        "nama": namaC.text,
      };

      Navigator.pop(context, data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? "Edit Kategori" : "Tambah Kategori"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Nama Kategori",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextFormField(
                controller: namaC,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: "Masukkan nama kategori",
                ),
                validator: (value) =>
                    value!.isEmpty ? "Nama kategori wajib diisi" : null,
              ),
              const SizedBox(height: 20),

              // Tombol simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _simpan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                  ),
                  child: const Text("Simpan", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
