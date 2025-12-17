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
  final List<String> pekerjaanList = const [
    "Belum bekerja",
    "Pelajar / Mahasiswa",
    "PNS",
    "TNI / POLRI",
    "Karyawan Swasta",
    "Wiraswasta",
    "Petani",
    "Buruh",
    "Ibu Rumah Tangga",
    "Lainnya",
  ];

  late TextEditingController namaC;
  late TextEditingController nikC;
  late TextEditingController noHpC;
  late TextEditingController pekerjaanC;

  // dropdown values
  String? agama; // nullable supaya aman jika kosong / tidak ada di list
  String? pendidikan; // nullable supaya aman jika kosong / tidak ada di list
  String? jenisKelamin; // nullable supaya aman
  String? statusWarga; // nullable supaya aman
  String? pekerjaan;

  final List<String> agamaList = const [
    "Islam",
    "Kristen",
    "Katolik",
    "Hindu",
    "Buddha",
    "Konghucu",
    "Kepercayaan YME",
  ];

  final List<String> pendidikanList = const [
    "Belum sekolah",
    "SD",
    "SMP",
    "SMA",
    "D3",
    "D4",
    "S1",
    "S2",
    "S3",
  ];

  final List<String> jenisKelaminList = const [
    "L",
    "P"
  ]; // simpan value konsisten
  final List<String> statusWargaList = const ["Aktif", "Nonaktif"];

  // 🔹 Data rumah untuk dropdown
  List<RumahModel> _listRumah = [];
  String? _selectedRumahDocId;
  bool _loadingRumah = true;

  // ---------- helper: amanin value dropdown ----------
  String? _safeValue(String? value, List<String> allowed) {
    if (value == null) return null;
    final v = value.trim();
    if (v.isEmpty) return null;

    // coba match exact
    if (allowed.contains(v)) return v;

    // coba match lower-case (biar kasus "aktif" vs "Aktif" aman)
    final idx = allowed.indexWhere((e) => e.toLowerCase() == v.toLowerCase());
    if (idx != -1) return allowed[idx];

    return null; // tidak ada di items -> null supaya tidak assert
  }

  String? _safeRumah(String? rumahDocId) {
    if (rumahDocId == null) return null;
    final v = rumahDocId.trim();
    if (v.isEmpty) return null;

    final exists = _listRumah.any((r) => r.docId == v);
    return exists ? v : null;
  }

  @override
  void initState() {
    super.initState();
    final w = widget.data;

    namaC = TextEditingController(text: (w.nama).trim());
    nikC = TextEditingController(text: (w.nik).trim());
    noHpC = TextEditingController(text: (w.noHp).trim());
    pekerjaanC = TextEditingController(text: (w.pekerjaan).trim());

    // set awal value dropdown dengan safeValue
    agama = _safeValue(w.agama, agamaList);
    pendidikan = _safeValue(w.pendidikan, pendidikanList);
    pekerjaan = _safeValue(w.pekerjaan, pekerjaanList);

    // jenis kelamin / status sering beda kapital → amankan
    jenisKelamin = _safeValue(w.jenisKelamin, jenisKelaminList);
    statusWarga = _safeValue(w.statusWarga, statusWargaList);

    // rumah: set dulu, nanti divalidasi setelah list rumah kebaca
    _selectedRumahDocId = (w.idRumah).trim().isEmpty ? null : w.idRumah.trim();

    _loadRumah();
  }

  Future<void> _loadRumah() async {
    final result = await _rumahService.getAllRumah();
    if (!mounted) return;

    setState(() {
      _listRumah = result;
      _loadingRumah = false;

      // setelah rumah ter-load, amankan value rumah biar tidak crash
      _selectedRumahDocId = _safeRumah(_selectedRumahDocId);
    });
  }

  @override
  void dispose() {
    namaC.dispose();
    nikC.dispose();
    noHpC.dispose();
    pekerjaanC.dispose();
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

              // ✅ AGAMA — Dropdown aman
              DropdownButtonFormField<String>(
                value: agama, // bisa null
                decoration: const InputDecoration(labelText: "Agama"),
                items: agamaList
                    .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                    .toList(),
                onChanged: (v) => setState(() => agama = v),
              ),

              // PEKERJAAN (boleh kosong)
              DropdownButtonFormField<String>(
                value: pekerjaan,
                decoration: const InputDecoration(labelText: "Pekerjaan"),
                items: pekerjaanList
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (v) => setState(() {
                  pekerjaan = v;
                  pekerjaanC.text = v ?? '';
                }),
              ),

              // ✅ PENDIDIKAN — Dropdown aman
              DropdownButtonFormField<String>(
                value: pendidikan, // bisa null
                decoration: const InputDecoration(labelText: "Pendidikan"),
                items: pendidikanList
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (v) => setState(() => pendidikan = v),
              ),

              const SizedBox(height: 10),

              // ✅ DROPDOWN PILIH RUMAH — aman walau id_rumah kosong / tidak ada
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
                      value: _selectedRumahDocId, // bisa null
                      isExpanded: true,
                      decoration:
                          const InputDecoration(labelText: "Pilih Rumah"),
                      items: _listRumah.map((r) {
                        return DropdownMenuItem(
                          value: r.docId,
                          child: Text("No. ${r.nomor} • ${r.alamat}"),
                        );
                      }).toList(),
                      onChanged: (v) => setState(() => _selectedRumahDocId = v),
                    ),

              const SizedBox(height: 10),

              // ✅ Jenis kelamin aman
              DropdownButtonFormField<String>(
                value: jenisKelamin,
                items: const [
                  DropdownMenuItem(value: "L", child: Text("Laki-laki")),
                  DropdownMenuItem(value: "P", child: Text("Perempuan")),
                ],
                decoration: const InputDecoration(labelText: "Jenis Kelamin"),
                onChanged: (v) => setState(() => jenisKelamin = v),
              ),

              // ✅ Status warga aman
              DropdownButtonFormField<String>(
                value: statusWarga,
                items: const [
                  DropdownMenuItem(value: "Aktif", child: Text("Aktif")),
                  DropdownMenuItem(
                      value: "Nonaktif", child: Text("Tidak Aktif")),
                ],
                decoration: const InputDecoration(labelText: "Status Warga"),
                onChanged: (v) => setState(() => statusWarga = v),
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
            final updated = <String, dynamic>{
              "nama": namaC.text.trim(),
              "nik": nikC.text.trim(),
              "no_hp": noHpC.text.trim(),
              "agama": (agama ?? "").trim(), // kalau null -> simpan ""
              "pekerjaan": (pekerjaan ?? "").trim(),
              "pendidikan": (pendidikan ?? "").trim(),
              "id_rumah": (_selectedRumahDocId ?? "").trim(),
              "jenis_kelamin": (jenisKelamin ?? "").trim(),
              "status_warga": (statusWarga ?? "").trim(),
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
