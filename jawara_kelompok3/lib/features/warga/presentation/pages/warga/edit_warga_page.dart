import 'package:flutter/material.dart';
import '../../../data/models/warga_model.dart';
import '../../../data/services/warga_service.dart';

// 🔹 Import Rumah untuk dropdown
import '../../../data/models/rumah_model.dart';
import '../../../data/services/rumah_service.dart';

class EditWargaPage extends StatefulWidget {
  final WargaModel data;

  const EditWargaPage({super.key, required this.data});

  @override
  State<EditWargaPage> createState() => _EditWargaPageState();
}

class _EditWargaPageState extends State<EditWargaPage> {
  final WargaService _service = WargaService();
  final RumahService _rumahService = RumahService();

  late TextEditingController namaC;
  late TextEditingController nikC;
  late TextEditingController noHpC;
  late TextEditingController pekerjaanC;
  late TextEditingController pendidikanC;

  String jenisKelamin = "p";
  String statusWarga = "aktif";
  String? agama; // dropdown agama

  final List<String> agamaList = [
    "Islam",
    "Kristen",
    "Katolik",
    "Hindu",
    "Buddha",
    "Konghucu",
    "Kepercayaan YME", // ⬅️ TAMBAHAN
  ];

  // 🔹 Data rumah untuk dropdown
  List<RumahModel> _listRumah = [];
  String? _selectedRumahDocId; // simpan docId rumah
  bool _loadingRumah = true;

  @override
  void initState() {
    super.initState();
    final w = widget.data;

    namaC = TextEditingController(text: w.nama);
    nikC = TextEditingController(text: w.nik);
    noHpC = TextEditingController(text: w.noHp);
    pekerjaanC = TextEditingController(text: w.pekerjaan);
    pendidikanC = TextEditingController(text: w.pendidikan);

    jenisKelamin = w.jenisKelamin;
    statusWarga = w.statusWarga;
    agama = w.agama;

    // 🔹 set awal docId rumah dari data lama
    _selectedRumahDocId = w.idRumah;

    _loadRumah();
  }

  Future<void> _loadRumah() async {
    final result = await _rumahService.getAllRumah();
    setState(() {
      _listRumah = result;
      _loadingRumah = false;
    });
  }

  @override
  void dispose() {
    namaC.dispose();
    nikC.dispose();
    noHpC.dispose();
    pekerjaanC.dispose();
    pendidikanC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Data Warga"),
      content: SizedBox(
        width: 360,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: namaC,
                decoration: const InputDecoration(labelText: "Nama"),
              ),
              TextField(
                controller: nikC,
                decoration: const InputDecoration(labelText: "NIK"),
              ),
              TextField(
                controller: noHpC,
                decoration: const InputDecoration(labelText: "No HP"),
              ),

              // 🔵 AGAMA — Dropdown
              DropdownButtonFormField<String>(
                value: agama,
                decoration: const InputDecoration(labelText: "Agama"),
                items: agamaList
                    .map(
                      (a) => DropdownMenuItem(
                        value: a,
                        child: Text(a),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => agama = v),
              ),

              // PEKERJAAN (boleh dikosongi)
              TextField(
                controller: pekerjaanC,
                decoration: const InputDecoration(labelText: "Pekerjaan"),
              ),

              // 🔽 PENDIDIKAN — Dropdown (tambah "Belum sekolah")
              DropdownButtonFormField<String>(
                value: pendidikanC.text.isEmpty ? null : pendidikanC.text,
                decoration: const InputDecoration(labelText: "Pendidikan"),
                items: const [
                  DropdownMenuItem(
                      value: "Belum sekolah", child: Text("Belum sekolah")),
                  DropdownMenuItem(value: "SD", child: Text("SD")),
                  DropdownMenuItem(value: "SMP", child: Text("SMP")),
                  DropdownMenuItem(
                      value: "SMA", child: Text("SMA / SMK")),
                  DropdownMenuItem(value: "D3", child: Text("D3")),
                  DropdownMenuItem(value: "D4", child: Text("D4")),
                  DropdownMenuItem(value: "S1", child: Text("S1")),
                  DropdownMenuItem(value: "S2", child: Text("S2")),
                  DropdownMenuItem(value: "S3", child: Text("S3")),
                ],
                onChanged: (v) {
                  if (v != null) {
                    setState(() => pendidikanC.text = v);
                  }
                },
              ),

              const SizedBox(height: 10),

              // 🔹 DROPDOWN PILIH RUMAH
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Pilih Rumah",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              _loadingRumah
                  ? const LinearProgressIndicator()
                  : DropdownButtonFormField<String>(
                      value: _selectedRumahDocId,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: "Pilih Rumah", // ⬅️ HAPUS 'ID RUMAH'
                      ),
                      items: _listRumah.map((r) {
                        return DropdownMenuItem(
                          value: r.docId, // simpan docId rumah
                          child: Text("No. ${r.nomor} • ${r.alamat}"),
                        );
                      }).toList(),
                      onChanged: (v) => setState(() {
                        _selectedRumahDocId = v;
                      }),
                    ),

              const SizedBox(height: 10),

              DropdownButtonFormField(
                value: jenisKelamin,
                items: const [
                  DropdownMenuItem(value: "L", child: Text("Laki-laki")),
                  DropdownMenuItem(value: "P", child: Text("Perempuan")),
                ],
                decoration: const InputDecoration(labelText: "Jenis Kelamin"),
                onChanged: (v) => setState(() => jenisKelamin = v!),
              ),

              DropdownButtonFormField(
                value: statusWarga,
                items: const [
                  DropdownMenuItem(value: "Aktif", child: Text("Aktif")),
                  DropdownMenuItem(
                    value: "Nonaktif",
                    child: Text("Tidak Aktif"),
                  ),
                ],
                decoration: const InputDecoration(labelText: "Status Warga"),
                onChanged: (v) => setState(() => statusWarga = v!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () async {
            final updated = {
              "nama": namaC.text,
              "nik": nikC.text,
              "no_hp": noHpC.text,
              "agama": agama,
              "pekerjaan": pekerjaanC.text,
              "pendidikan": pendidikanC.text, // dari dropdown
              "id_rumah": _selectedRumahDocId ?? widget.data.idRumah,
              "jenis_kelamin": jenisKelamin,
              "status_warga": statusWarga,
              "updated_at": DateTime.now(),
            };

            await _service.updateWarga(widget.data.docId, updated);
            if (!mounted) return;
            Navigator.pop(context, true);
          },
          child: const Text("Simpan"),
        ),
      ],
    );
  }
}
