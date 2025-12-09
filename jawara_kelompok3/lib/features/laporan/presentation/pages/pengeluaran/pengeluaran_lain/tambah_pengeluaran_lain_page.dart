import 'package:flutter/material.dart';
import '../../../../../../core/layout/header.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../controller/pengeluaran_lain_controller.dart';
import '../../../../data/models/pengeluaran_lain_model.dart';

class TambahPengeluaranLainPage extends StatefulWidget {
  final bool isEdit;
  final PengeluaranLainModel? dataEdit;

  const TambahPengeluaranLainPage({
    super.key,
    this.isEdit = false,
    this.dataEdit,
  });

  @override
  State<TambahPengeluaranLainPage> createState() =>
      _TambahPengeluaranLainPageState();
}

class _TambahPengeluaranLainPageState extends State<TambahPengeluaranLainPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _jenisController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();
  DateTime? _selectedDate;
  bool _loadingSubmit = false;

  final PengeluaranLainController controller = PengeluaranLainController();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.dataEdit != null) {
      _namaController.text = widget.dataEdit!.nama;
      _jenisController.text = widget.dataEdit!.jenis;
      _nominalController.text = widget.dataEdit!.nominal.toString();
      // Parse tanggal dari format "d/m/y"
      _selectedDate = _parseTanggal(widget.dataEdit!.tanggal);
    }
  }

  DateTime? _parseTanggal(String tanggalStr) {
    try {
      final parts = tanggalStr.split('/');
      if (parts.length == 3) {
        return DateTime(
            int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
      }
    } catch (e) {
      return null;
    }
    return null;
  }

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
    // Validasi sederhana
    if (_namaController.text.trim().isEmpty ||
        _jenisController.text.trim().isEmpty ||
        _nominalController.text.trim().isEmpty ||
        _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field wajib diisi")),
      );
      return;
    }

    setState(() => _loadingSubmit = true);

    final data = {
      "nama": _namaController.text,
      "jenis": _jenisController.text,
      "tanggal":
          "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
      "nominal": int.parse(_nominalController.text),
      "bukti_url": null,
    };

    try {
      if (widget.isEdit) {
        await controller.updatePengeluaran(widget.dataEdit!.id, data);
      } else {
        await controller.addPengeluaran(data);
      }
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => _loadingSubmit = false);
      }
    }
  }

  void _resetForm() {
    _namaController.clear();
    _jenisController.clear();
    _nominalController.clear();
    setState(() {
      _selectedDate = null;
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
              title: widget.isEdit
                  ? "Pengeluaran Lain - Edit"
                  : "Pengeluaran Lain - Tambah",
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
                      Text(
                        widget.isEdit
                            ? "Edit Pengeluaran Lainnya"
                            : "Buat Pengeluaran Baru",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),

                      // Nama
                      TextField(
                        controller: _namaController,
                        decoration: _inputDecoration("Nama Pengeluaran"),
                      ),
                      const SizedBox(height: 12),

                      // Jenis
                      TextField(
                        controller: _jenisController,
                        decoration: _inputDecoration("Jenis Pengeluaran"),
                      ),
                      const SizedBox(height: 12),

                      // Tanggal (picker)
                      const Text(
                        "Tanggal Pengeluaran",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => _selectedDate = picked);
                          }
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

                      // Nominal
                      TextField(
                        controller: _nominalController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration("Nominal"),
                      ),
                      const SizedBox(height: 12),

                      // Upload bukti (placeholder)
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
                              onPressed: () {
                                // placeholder: tidak ada logic upload
                              },
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

                      // Tombol: Simpan + Reset
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
                                        color: Colors.white,
                                      )
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

  @override
  void dispose() {
    _namaController.dispose();
    _jenisController.dispose();
    _nominalController.dispose();
    super.dispose();
  }
}
