import 'package:flutter/material.dart';
import '../../data/models/kegiatan_model.dart';
import '../../data/services/kegiatan_service.dart';
import '../../presentation/widgets/kegiatan_card.dart';
import '../../presentation/widgets/kegiatan_filter.dart';

class EditKegiatanDialog extends StatefulWidget {
  final KegiatanModel data;

  const EditKegiatanDialog({super.key, required this.data});

  @override
  State<EditKegiatanDialog> createState() => _EditKegiatanDialogState();
}

class _EditKegiatanDialogState extends State<EditKegiatanDialog> {
  final _formKey = GlobalKey<FormState>();
  final KegiatanService _service = KegiatanService();

  late TextEditingController _namaC;
  late TextEditingController _lokasiC;
  late TextEditingController _pjC;
  late TextEditingController _ketC;

  String? _kategori;
  String _status = "rencana";

  DateTime? _tglMulai;
  DateTime? _tglSelesai;

  final List<String> kategoriList = const [
    "Komunitas & Sosial",
    "Keamanan",
    "Keagamaan",
    "Pendidikan",
    "Olahraga",
  ];

  @override
  void initState() {
    super.initState();
    final d = widget.data;

    _namaC = TextEditingController(text: d.nama);
    _lokasiC = TextEditingController(text: d.lokasi);
    _pjC = TextEditingController(text: d.penanggungJawab);
    _ketC = TextEditingController(text: d.keterangan);

    _kategori = d.kategori;
    _status = d.status;
    _tglMulai = d.tanggalMulai;
    _tglSelesai = d.tanggalSelesai;
  }

  @override
  void dispose() {
    _namaC.dispose();
    _lokasiC.dispose();
    _pjC.dispose();
    _ketC.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? d) {
    if (d == null) return '--/--/----';
    return "${d.day.toString().padLeft(2, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.year}";
  }

  Future<void> _pickMulai() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _tglMulai ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() => _tglMulai = picked);
    }
  }

  Future<void> _pickSelesai() async {
    final base = _tglMulai ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _tglSelesai ?? base,
      firstDate: base,
      lastDate: DateTime(base.year + 5),
    );
    if (picked != null) {
      setState(() => _tglSelesai = picked);
    }
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    final dataUpdate = {
      "nama": _namaC.text.trim(),
      "kategori": _kategori ?? "",
      "lokasi": _lokasiC.text.trim(),
      "penanggung_jawab": _pjC.text.trim(),
      "status": _status,
      "keterangan": _ketC.text.trim(),
      "tanggal_mulai": _tglMulai,
      "tanggal_selesai": _tglSelesai,
    };

    final ok = await _service.updateKegiatan(widget.data.uid, dataUpdate);

    if (!mounted) return;

    Navigator.pop(context, ok);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Edit Kegiatan",
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _namaC,
                  decoration: const InputDecoration(labelText: "Nama"),
                  validator: (v) =>
                      v == null || v.isEmpty ? "Nama wajib diisi" : null,
                ),
                TextFormField(
                  controller: _lokasiC,
                  decoration: const InputDecoration(labelText: "Lokasi"),
                ),
                TextFormField(
                  controller: _pjC,
                  decoration: const InputDecoration(
                      labelText: "Penanggung Jawab"),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _kategori,
                  decoration: const InputDecoration(labelText: "Kategori"),
                  items: kategoriList
                      .map(
                        (k) => DropdownMenuItem(
                          value: k,
                          child: Text(k),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _kategori = v),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(labelText: "Status"),
                  items: const [
                    DropdownMenuItem(
                        value: "rencana", child: Text("Rencana")),
                    DropdownMenuItem(
                        value: "berjalan", child: Text("Berjalan")),
                    DropdownMenuItem(
                        value: "selesai", child: Text("Selesai")),
                    DropdownMenuItem(value: "batal", child: Text("Batal")),
                  ],
                  onChanged: (v) => setState(() => _status = v ?? "rencana"),
                ),
                const SizedBox(height: 8),
                // tanggal mulai
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Tanggal Mulai"),
                  subtitle: Text(_formatDate(_tglMulai)),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickMulai,
                  ),
                ),
                // tanggal selesai
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Tanggal Selesai"),
                  subtitle: Text(_formatDate(_tglSelesai)),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickSelesai,
                  ),
                ),
                TextFormField(
                  controller: _ketC,
                  maxLines: 3,
                  decoration:
                      const InputDecoration(labelText: "Keterangan"),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Batal"),
                    ),
                    ElevatedButton(
                      onPressed: _simpan,
                      child: const Text("Simpan"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
