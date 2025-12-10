import 'package:flutter/material.dart';
import '../../../data/models/warga_model.dart';
import '../../../data/services/rumah_service.dart';

class DetailWargaPage extends StatefulWidget {
  final WargaModel data;
  const DetailWargaPage({super.key, required this.data});

  @override
  State<DetailWargaPage> createState() => _DetailWargaPageState();
}

class _DetailWargaPageState extends State<DetailWargaPage> {
  final _rumahService = RumahService();

  String? _alamatRumah;
  bool _loadingRumah = true;

  @override
  void initState() {
    super.initState();
    _loadAlamatRumah();
  }

  Future<void> _loadAlamatRumah() async {
    try {
      if (widget.data.idRumah.isNotEmpty) {
        // kalau kamu punya getAlamatRumahByDocId:
        final alamat =
            await _rumahService.getAlamatRumahByDocId(widget.data.idRumah);

        // atau pakai getByDocId:
        // final rumah = await _rumahService.getByDocId(widget.data.idRumah);
        // final alamat = rumah?.alamat;

        if (!mounted) return;
        setState(() {
          _alamatRumah = alamat;
          _loadingRumah = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          _alamatRumah = null;
          _loadingRumah = false;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _alamatRumah = null;
        _loadingRumah = false;
      });
    }
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return "-";
    return "${dt.day.toString().padLeft(2, '0')}-"
        "${dt.month.toString().padLeft(2, '0')}-"
        "${dt.year}";
  }

  String _alamatText() {
    if (_loadingRumah) return "(memuat...)";
    if ((_alamatRumah ?? "").isEmpty) return "-";
    return _alamatRumah!;
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return AlertDialog(
      title: Text("Detail ${data.nama}"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row("NIK", data.nik),
            _row("No KK", data.noKk),
            _row("No HP", data.noHp),
            _row("Agama", data.agama),
            _row("Jenis Kelamin", data.jenisKelamin),
            _row("Pekerjaan", data.pekerjaan),
            _row("Pendidikan", data.pendidikan.toUpperCase()),
            _row("Status Warga", data.statusWarga),
            // 🔹 ganti "ID Rumah" → "Alamat Rumah"
            _row("Alamat Rumah", _alamatText()),
            _row("Tanggal Lahir", _formatDate(data.tanggalLahir)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Tutup"),
        ),
      ],
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        "$label: $value",
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
