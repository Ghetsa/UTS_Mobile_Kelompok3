import 'package:flutter/material.dart';
import '../../../../controller/pengeluaran_lain_controller.dart';
import '../../../../data/models/pengeluaran_lain_model.dart';
import '../../../../../../core/layout/header.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/theme/app_theme.dart';

class PengeluaranLainTambahPage extends StatefulWidget {
  const PengeluaranLainTambahPage({super.key});

  @override
  State<PengeluaranLainTambahPage> createState() =>
      _PengeluaranLainTambahPageState();
}

class _PengeluaranLainTambahPageState extends State<PengeluaranLainTambahPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();
  DateTime? _selectedDate;
  String? _kategori;
  bool _loadingSubmit = false;

  final PengeluaranLainController controller = PengeluaranLainController();

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF4F8FB),
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Future<void> _simpan() async {
    if (_namaController.text.trim().isEmpty ||
        _nominalController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama dan nominal wajib diisi")),
      );
      return;
    }

    setState(() => _loadingSubmit = true);

    final tanggalFormatted = _selectedDate != null
        ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
        : '';

    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final pengeluaran = PengeluaranLainModel(
      docId: "",
      id: id,
      nama: _namaController.text.trim(),
      jenis: _kategori ?? 'Pengeluaran Lainnya',
      tanggal: tanggalFormatted,
      nominal: _nominalController.text.trim(),
      buktiUrl: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await controller.add(pengeluaran);

    setState(() => _loadingSubmit = false);
    if (mounted) Navigator.pop(context, true);
  }

  void _resetForm() {
    _namaController.clear();
    _nominalController.clear();
    setState(() {
      _selectedDate = null;
      _kategori = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      drawer: const AppSidebar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainHeader(
              title: "Pengeluaran Lain - Tambah",
              showSearchBar: false,
              showFilterButton: false,
            ),
            const SizedBox(height: 18),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Buat Pengeluaran Baru",
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  )),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _namaController,
                        decoration: _inputDecoration("Nama Pengeluaran"),
                      ),
                      const SizedBox(height: 12),
                      const Text("Tanggal Pengeluaran",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null)
                            setState(() => _selectedDate = picked);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F8FB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _selectedDate == null
                                      ? "--/--/----"
                                      : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                                  style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontSize: 14),
                                ),
                              ),
                              const Icon(Icons.calendar_today, size: 18),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _kategori,
                        decoration: _inputDecoration("Kategori Pengeluaran"),
                        items: [
                          "Pengeluaran Lainnya",
                          "Operasional",
                          "Perbaikan"
                        ]
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) => setState(() => _kategori = v),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _nominalController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration("Nominal"),
                      ),
                      const SizedBox(height: 12),
                      // Placeholder upload bukti
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                          color: const Color(0xFFF9FBFE),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.upload_file),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Upload bukti pengeluaran (.png/.jpg)",
                                style: TextStyle(color: Colors.grey.shade800),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text("Pilih"),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 46,
                              child: ElevatedButton(
                                onPressed: _loadingSubmit ? null : _simpan,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _loadingSubmit
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : const Text("Submit"),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 46,
                              child: OutlinedButton(
                                onPressed: _resetForm,
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.grey.shade300),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text("Reset"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
