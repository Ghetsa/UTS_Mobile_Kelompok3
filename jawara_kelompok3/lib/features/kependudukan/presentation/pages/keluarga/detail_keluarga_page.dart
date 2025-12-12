import 'package:flutter/material.dart';

import '../../../data/models/keluarga_model.dart';
import '../../../data/models/warga_model.dart';
import '../../../data/services/rumah_service.dart';
import '../../../data/services/warga_service.dart';

import 'kelola_anggota_keluarga_page.dart';

class DetailKeluargaPage extends StatefulWidget {
  final KeluargaModel data;

  const DetailKeluargaPage({super.key, required this.data});

  @override
  State<DetailKeluargaPage> createState() => _DetailKeluargaPageState();
}

class _DetailKeluargaPageState extends State<DetailKeluargaPage> {
  final RumahService _rumahService = RumahService();
  final WargaService _wargaService = WargaService();

  bool _loading = true;

  String _alamatRumah = "-";
  List<WargaModel> _anggota = [];

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() => _loading = true);

    try {
      // ✅ Alamat rumah dari docId rumah
      if (widget.data.idRumah.isNotEmpty) {
        final alamat =
            await _rumahService.getAlamatRumahByDocId(widget.data.idRumah);
        _alamatRumah = (alamat == null || alamat.trim().isEmpty) ? "-" : alamat;
      } else {
        _alamatRumah = "-";
      }

      // ✅ Anggota keluarga (dari id_keluarga = uid keluarga)
      final list = await _wargaService.getWargaByKeluargaId(widget.data.uid);

      if (!mounted) return;

      setState(() {
        _anggota = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _alamatRumah = "-";
        _anggota = [];
        _loading = false;
      });
    }
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value.isEmpty ? "-" : value)),
        ],
      ),
    );
  }

  Widget _anggotaSection() {
    if (_anggota.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 8),
        child: Text(
          "Belum ada anggota.",
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _anggota.length,
      separatorBuilder: (_, __) => const Divider(height: 12),
      itemBuilder: (_, i) {
        final w = _anggota[i];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 16,
              child: Text(
                w.nama.isNotEmpty ? w.nama[0].toUpperCase() : "?",
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    w.nama.isEmpty ? "-" : w.nama,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text("NIK: ${w.nik.isEmpty ? '-' : w.nik}"),
                  Text("No HP: ${w.noHp.isEmpty ? '-' : w.noHp}"),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final keluarga = widget.data;

    return AlertDialog(
      title: Text("Detail ${keluarga.kepalaKeluarga}"),
      content: SizedBox(
        width: double.maxFinite,
        child: _loading
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: Center(child: CircularProgressIndicator()),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _row("Kepala", keluarga.kepalaKeluarga),
                    _row("No KK", keluarga.noKk),
                    _row("Alamat Rumah", _alamatRumah), // ✅ bukan docId
                    _row("Jumlah Anggota", keluarga.jumlahAnggota),
                    _row("Status", keluarga.statusKeluarga),

                    const SizedBox(height: 14),
                    const Text(
                      "Anggota Keluarga",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    _anggotaSection(),
                  ],
                ),
              ),
      ),
      actions: [
        TextButton(
          child: const Text("Tutup"),
          onPressed: () => Navigator.pop(context, false),
        ),
        TextButton(
          child: const Text("Kelola Anggota"),
          onPressed: () async {
            final res = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => KelolaAnggotaKeluargaPage(keluarga: keluarga),
              ),
            );

            if (!context.mounted) return;

            // ✅ setelah kelola anggota, refresh isi detail supaya list anggota update
            if (res == true) {
              await _loadDetail();
            }
          },
        ),
      ],
    );
  }
}
