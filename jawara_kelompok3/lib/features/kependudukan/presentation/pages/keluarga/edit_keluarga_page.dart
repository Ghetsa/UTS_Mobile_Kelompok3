import 'package:flutter/material.dart';

import '../../../data/models/keluarga_model.dart';
import '../../../data/models/rumah_model.dart';
import '../../../data/models/warga_model.dart';

import '../../../data/services/rumah_service.dart';
import '../../../data/services/warga_service.dart';

import '../../../controller/keluarga_controller.dart';

class EditKeluargaPage extends StatefulWidget {
  final KeluargaModel data;

  const EditKeluargaPage({super.key, required this.data});

  @override
  State<EditKeluargaPage> createState() => _EditKeluargaPageState();
}

class _EditKeluargaPageState extends State<EditKeluargaPage> {
  final KeluargaController _keluargaController = KeluargaController();
  final RumahService _rumahService = RumahService();
  final WargaService _wargaService = WargaService();

  late TextEditingController _noKkC;
  late TextEditingController _jumlahC;

  String _status = "aktif";

  // rumah
  List<RumahModel> _listRumah = [];
  String? _rumahId;
  bool _loadingRumah = true;

  // kepala keluarga (warga)
  List<WargaModel> _listWargaByRumah = [];
  String? _kepalaWargaId; // docId warga yang dipilih
  bool _loadingWarga = false;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final item = widget.data;

    _noKkC = TextEditingController(text: item.noKk);
    _jumlahC = TextEditingController(text: item.jumlahAnggota);

    _status = item.statusKeluarga.isEmpty
        ? "aktif"
        : item.statusKeluarga.toLowerCase().trim();
    if (!['aktif', 'pindah', 'sementara'].contains(_status)) {
      _status = 'aktif';
    }

    _rumahId = item.idRumah.isEmpty ? null : item.idRumah;

    // kalau model kamu punya idKepalaWarga -> pakai itu.
    // kalau belum ada, kita coba fallback dari data yg mungkin ada.
    // (aman kalau null)
    _kepalaWargaId =
        (item.idKepalaWarga.isNotEmpty) ? item.idKepalaWarga : null;

    _loadRumah();
  }

  Future<void> _loadRumah() async {
    final result = await _rumahService.getAllRumah();
    if (!mounted) return;
    setState(() {
      _listRumah = result;
      _loadingRumah = false;

      if (_rumahId != null && !_listRumah.any((r) => r.docId == _rumahId)) {
        _rumahId = null;
      }
    });

    // setelah rumah siap -> load warga sesuai rumah terpilih
    await _loadWargaByRumah(_rumahId);
  }

  Future<void> _loadWargaByRumah(String? rumahDocId) async {
    if (rumahDocId == null || rumahDocId.isEmpty) {
      if (!mounted) return;
      setState(() {
        _listWargaByRumah = [];
        _kepalaWargaId = null;
        _loadingWarga = false;
      });
      return;
    }

    if (!mounted) return;
    setState(() => _loadingWarga = true);

    // ✅ ambil warga berdasarkan rumah
    final list = await _wargaService.getWargaByRumahId(rumahDocId);

    if (!mounted) return;
    setState(() {
      _listWargaByRumah = list;
      _loadingWarga = false;

      // kalau kepala yg sebelumnya tidak ada di rumah ini, reset
      if (_kepalaWargaId != null &&
          !_listWargaByRumah.any((w) => w.docId == _kepalaWargaId)) {
        _kepalaWargaId = null;
      }

      // optional: kalau belum ada yg dipilih dan list tidak kosong -> auto pilih pertama
      // (kalau kamu ga mau auto pilih, hapus blok ini)
      // if (_kepalaWargaId == null && _listWargaByRumah.isNotEmpty) {
      //   _kepalaWargaId = _listWargaByRumah.first.docId;
      // }
    });
  }

  Future<void> _save() async {
    final noKk = _noKkC.text.trim();
    final jumlah = _jumlahC.text.trim();

    if (noKk.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No KK wajib diisi")),
      );
      return;
    }

    if (jumlah.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Jumlah anggota wajib diisi")),
      );
      return;
    }

    // aturan: kalau status aktif/sementara, wajib pilih rumah
    if ((_status == "aktif" || _status == "sementara") &&
        (_rumahId == null || _rumahId!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Untuk status Aktif/Sementara, rumah wajib dipilih"),
        ),
      );
      return;
    }

    // kalau status aktif/sementara dan rumah dipilih -> kepala keluarga wajib dipilih dari warga rumah tsb
    if ((_status == "aktif" || _status == "sementara") &&
        (_kepalaWargaId == null || _kepalaWargaId!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Kepala keluarga wajib dipilih dari warga rumah tersebut")),
      );
      return;
    }

    final rumahFinal = (_status == "pindah") ? "" : (_rumahId ?? "");

    // cari nama kepala dari list warga rumah
    String kepalaNamaFinal = widget.data.kepalaKeluarga; // fallback aman
    if (_kepalaWargaId != null && _kepalaWargaId!.isNotEmpty) {
      final kepala = _listWargaByRumah.firstWhere(
        (w) => w.docId == _kepalaWargaId,
        orElse: () => _listWargaByRumah.isNotEmpty
            ? _listWargaByRumah.first
            : throw Exception(),
      );
      kepalaNamaFinal = kepala.nama;
    }

    final dataUpdate = <String, dynamic>{
      "no_kk": noKk,
      "jumlah_anggota": jumlah,
      "status_keluarga": _status,
      "id_rumah": rumahFinal,

      // ✅ penting: simpan relasi kepala keluarga
      "kepala_keluarga":
          (_status == "pindah") ? widget.data.kepalaKeluarga : kepalaNamaFinal,
      "id_kepala_warga": (_status == "pindah") ? "" : (_kepalaWargaId ?? ""),
    };

    setState(() => _saving = true);

    final ok = await _keluargaController.updateWithRumahAutomation(
      widget.data.uid,
      dataUpdate,
    );

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menyimpan perubahan keluarga")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ Data keluarga berhasil diperbarui"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _noKkC.dispose();
    _jumlahC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Edit Keluarga",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _noKkC,
                decoration: const InputDecoration(labelText: "No KK"),
              ),

              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: "Status Keluarga"),
                items: const [
                  DropdownMenuItem(value: "aktif", child: Text("Aktif")),
                  DropdownMenuItem(value: "pindah", child: Text("Pindah")),
                  DropdownMenuItem(
                      value: "sementara", child: Text("Sementara")),
                ],
                onChanged: (v) async {
                  final val = v ?? "aktif";
                  setState(() => _status = val);

                  // kalau pindah -> kosongkan rumah & kepala
                  if (val == "pindah") {
                    setState(() {
                      _rumahId = null;
                      _kepalaWargaId = null;
                      _listWargaByRumah = [];
                    });
                  } else {
                    // kalau balik aktif/sementara -> load warga sesuai rumah
                    await _loadWargaByRumah(_rumahId);
                  }
                },
              ),

              const SizedBox(height: 10),

              _loadingRumah
                  ? const LinearProgressIndicator()
                  : DropdownButtonFormField<String>(
                      value: _rumahId,
                      decoration:
                          const InputDecoration(labelText: "Pilih Rumah"),
                      isExpanded: true,
                      items: _listRumah.map((r) {
                        return DropdownMenuItem(
                          value: r.docId,
                          child: Text("No. ${r.nomor} • ${r.alamat}"),
                        );
                      }).toList(),
                      onChanged: (_status == "pindah")
                          ? null
                          : (v) async {
                              setState(() => _rumahId = v);
                              await _loadWargaByRumah(v);
                            },
                    ),

              const SizedBox(height: 10),

              // ✅ Kepala keluarga dropdown (filtered by rumah)
              _status == "pindah"
                  ? const SizedBox.shrink()
                  : (_loadingWarga
                      ? const LinearProgressIndicator()
                      : DropdownButtonFormField<String>(
                          value: _kepalaWargaId,
                          decoration: const InputDecoration(
                            labelText: "Kepala Keluarga (Warga di rumah ini)",
                          ),
                          isExpanded: true,
                          items: _listWargaByRumah.map((w) {
                            return DropdownMenuItem(
                              value: w.docId,
                              child: Text("${w.nama} • NIK: ${w.nik}"),
                            );
                          }).toList(),
                          onChanged: (v) => setState(() => _kepalaWargaId = v),
                        )),

              const SizedBox(height: 10),

              TextField(
                controller: _jumlahC,
                decoration: const InputDecoration(labelText: "Jumlah Anggota"),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: const Text("Batal"),
                    onPressed:
                        _saving ? null : () => Navigator.pop(context, false),
                  ),
                  ElevatedButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("Simpan"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
