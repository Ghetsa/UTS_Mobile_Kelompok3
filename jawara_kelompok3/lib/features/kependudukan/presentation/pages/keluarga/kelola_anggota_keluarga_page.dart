import 'package:flutter/material.dart';

import '../../../data/models/keluarga_model.dart';
import '../../../data/models/warga_model.dart';
import '../../../data/services/warga_service.dart';
import '../../../data/services/keluarga_service.dart';
import '../../../../../core/theme/app_theme.dart';

class KelolaAnggotaKeluargaPage extends StatefulWidget {
  final KeluargaModel keluarga;

  const KelolaAnggotaKeluargaPage({
    super.key,
    required this.keluarga,
  });

  @override
  State<KelolaAnggotaKeluargaPage> createState() =>
      _KelolaAnggotaKeluargaPageState();
}

class _KelolaAnggotaKeluargaPageState extends State<KelolaAnggotaKeluargaPage> {
  final WargaService _wargaService = WargaService();
  final KeluargaService _keluargaService = KeluargaService();

  List<WargaModel> _anggota = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAnggota();
  }

  // ============================================================
  // 🔵 MUAT LIST ANGGOTA + SINKRON JUMLAH ANGGOTA
  // ============================================================
  Future<void> _loadAnggota() async {
    setState(() => _loading = true);

    // Ambil semua warga yang punya id_keluarga = keluarga.uid
    final list = await _wargaService.getWargaByKeluargaId(widget.keluarga.uid);

    if (!mounted) return;

    setState(() {
      _anggota = list;
    });

    // Sinkron jumlah_anggota di dokumen keluarga
    await _syncJumlahAnggota();

    if (!mounted) return;
    setState(() => _loading = false);
  }

  // ============================================================
  // 🔷 SINKRON jumlah_anggota di koleksi keluarga
  // ============================================================
  Future<void> _syncJumlahAnggota() async {
    final keluargaId = widget.keluarga.uid;

    final count = await _wargaService.countWargaByKeluarga(keluargaId);

    await _keluargaService.updateKeluarga(keluargaId, {
      "jumlah_anggota": count.toString(),
    });
  }

  // ============================================================
  // 🟢 TAMBAH ANGGOTA DARI "WARGA SERUMAH"
  // ============================================================
  Future<void> _openTambahAnggota() async {
    // Ambil semua warga serumah dengan keluarga ini
    final wargaSerumah =
        await _wargaService.getWargaByRumahId(widget.keluarga.idRumah);

    // Filter: hanya yang id_keluarga masih kosong
    final calon = wargaSerumah.where((w) => w.idKeluarga.isEmpty).toList();

    if (calon.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tidak ada warga serumah yang belum punya keluarga."),
        ),
      );
      return;
    }

    String? selectedWargaId;

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Anggota Keluarga"),
        content: StatefulBuilder(
          builder: (context, setStateDialog) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Pilih warga serumah yang akan dijadikan anggota keluarga.",
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedWargaId,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: "Warga Serumah",
                    border: OutlineInputBorder(),
                  ),
                  items: calon.map((w) {
                    return DropdownMenuItem(
                      value: w.docId,
                      child: Text("${w.nama} • NIK: ${w.nik}"),
                    );
                  }).toList(),
                  onChanged: (v) {
                    setStateDialog(() {
                      selectedWargaId = v;
                    });
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (selectedWargaId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Silakan pilih satu warga dulu."),
                  ),
                );
                return;
              }

              // Cari objek WargaModel-nya
              final warga = calon.firstWhere((w) => w.docId == selectedWargaId,
                  orElse: () => calon.first);

              // Update id_keluarga warga tersebut
              final ok = await _wargaService.assignToKeluargaAtomic(
                wargaDocId: warga.docId,
                keluargaId: widget.keluarga.uid,
                rumahId: widget.keluarga.idRumah,
                noKk: widget.keluarga.noKk,
              );

              if (!ok) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Gagal menambah anggota keluarga."),
                  ),
                );
                return;
              }

              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("✅ Anggota berhasil ditambahkan ke keluarga"),
                  backgroundColor: Colors.green,
                ),
              );

              Navigator.pop(context, true);
            },
            child: const Text("Tambah"),
          ),
        ],
      ),
    );

    if (result == true) {
      await _loadAnggota();
    }
  }

  // ============================================================
  // 🔴 HAPUS ANGGOTA (LEPAS DARI KELUARGA)
  // ============================================================
  Future<void> _hapusAnggota(WargaModel warga) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Anggota?"),
        content: Text("Warga '${warga.nama}' akan dilepas dari keluarga ini ."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final ok = await _wargaService.updateWarga(warga.docId, {
      'id_keluarga': '',
    });

    if (!ok) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menghapus anggota keluarga."),
        ),
      );
      return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Anggota berhasil dihapus dari keluarga"),
          backgroundColor: Colors.green,
        ),
      );
    }

    await _loadAnggota();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F2F9),
      appBar: AppBar(
        backgroundColor: Color(0xFF0C88C2),
        foregroundColor: Colors.white,
        title: Text("Anggota - ${widget.keluarga.kepalaKeluarga}"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryBlue,
        onPressed: _openTambahAnggota,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _anggota.isEmpty
              ? const Center(
                  child: Text(
                    "Belum ada anggota.\nTekan tombol + untuk menambahkan.",
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _anggota.length,
                  itemBuilder: (_, i) {
                    final w = _anggota[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            w.nama.isNotEmpty ? w.nama[0].toUpperCase() : "?",
                          ),
                        ),
                        title: Text(w.nama),
                        subtitle: Text("NIK: ${w.nik}\nNo HP: ${w.noHp}"),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline,
                              color: Colors.red),
                          onPressed: () => _hapusAnggota(w),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
