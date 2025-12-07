import 'package:flutter/material.dart';
import '../../../data/models/keluarga_model.dart';
import '../../../data/models/rumah_model.dart';
import '../../../data/services/rumah_service.dart';
import '../../../controller/keluarga_controller.dart';

class EditKeluargaPage extends StatefulWidget {
  final KeluargaModel data;

  const EditKeluargaPage({super.key, required this.data});

  @override
  State<EditKeluargaPage> createState() => _EditKeluargaPageState();
}

class _EditKeluargaPageState extends State<EditKeluargaPage> {
  final KeluargaController _controller = KeluargaController();
  final RumahService _rumahService = RumahService();

  late TextEditingController _kepalaC;
  late TextEditingController _noKkC;
  late TextEditingController _jumlahC;

  String _status = "aktif";
  List<RumahModel> _listRumah = [];
  String? _rumahId;
  bool _loadingRumah = true;

  @override
  void initState() {
    super.initState();
    final item = widget.data;

    _kepalaC = TextEditingController(text: item.kepalaKeluarga);
    _noKkC = TextEditingController(text: item.noKk);
    _jumlahC = TextEditingController(text: item.jumlahAnggota);

    _status = item.statusKeluarga.isEmpty
        ? "aktif"
        : item.statusKeluarga.toLowerCase();
    if (!['aktif', 'pindah', 'sementara'].contains(_status)) {
      _status = 'aktif';
    }

    _rumahId = item.idRumah.isEmpty ? null : item.idRumah;

    _loadRumah();
  }

  Future<void> _loadRumah() async {
    final result = await _rumahService.getAllRumah();
    setState(() {
      _listRumah = result;
      _loadingRumah = false;

      if (_rumahId != null && !_listRumah.any((r) => r.docId == _rumahId)) {
        _rumahId = null;
      }
    });
  }

  @override
  void dispose() {
    _kepalaC.dispose();
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
                controller: _kepalaC,
                decoration: const InputDecoration(labelText: "Kepala Keluarga"),
              ),
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
                onChanged: (v) => setState(() => _status = v ?? "aktif"),
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
                      onChanged: (v) => setState(() => _rumahId = v),
                    ),
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
                    onPressed: () => Navigator.pop(context, false),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final dataUpdate = {
                        "kepala_keluarga": _kepalaC.text.trim(),
                        "no_kk": _noKkC.text.trim(),
                        "jumlah_anggota": _jumlahC.text.trim(),
                        "status_keluarga": _status,
                        "id_rumah": _rumahId ?? "",
                      };

                      final ok =
                          await _controller.update(widget.data.uid, dataUpdate);

                      if (!context.mounted) return;
                      Navigator.pop(context, ok);
                    },
                    child: const Text("Simpan"),
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
