import 'package:flutter/material.dart';
import '../../../data/models/keluarga_model.dart';
import '../../../controller/keluarga_controller.dart';
import '../../../data/models/rumah_model.dart';
import '../../../data/services/rumah_service.dart';

import '../../../../../core/layout/header.dart';
import '../../../../../core/layout/sidebar.dart';
import '../../widgets/card/keluarga_card.dart';
import '../../widgets/filter/keluarga_filter.dart';
import '../keluarga/tambah_keluarga_page.dart';
import 'kelola_anggota_keluarga_page.dart';

class DaftarKeluargaPage extends StatefulWidget {
  const DaftarKeluargaPage({super.key});

  @override
  State<DaftarKeluargaPage> createState() => _DaftarKeluargaPageState();
}

class _DaftarKeluargaPageState extends State<DaftarKeluargaPage> {
  final KeluargaController _controller = KeluargaController();
  final RumahService _rumahService = RumahService();

  List<KeluargaModel> data = [];
  List<RumahModel> _listRumah = [];
  bool _loadingRumah = true;

  String search = "";

  /// 🔹 state filter aktif (diisi dari FilterKeluargaDialog)
  Map<String, dynamic> _activeFilter = {};

  @override
  void initState() {
    super.initState();
    loadData();
    _loadRumah();
  }

  Future<void> loadData() async {
    data = await _controller.fetchAll();
    setState(() {});
  }

  Future<void> _loadRumah() async {
    _listRumah = await _rumahService.getAllRumah();
    setState(() => _loadingRumah = false);
  }

  // ============================
  // DETAIL KELUARGA
  // ============================
  void _showDetail(KeluargaModel item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Detail ${item.kepalaKeluarga}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row("Kepala Keluarga", item.kepalaKeluarga),
            _row("No KK", item.noKk),
            _row("Rumah (docId)", item.idRumah),
            _row("Jumlah Anggota", item.jumlahAnggota),
            _row("Status", item.statusKeluarga),
            _row("docId", item.uid),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Tutup"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Kelola Anggota"),
            onPressed: () async {
              Navigator.pop(context);
              final res = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => KelolaAnggotaKeluargaPage(keluarga: item),
                ),
              );
              if (res == true) loadData();
            },
          ),
        ],
      ),
    );
  }

  // ============================
  // EDIT KELUARGA → POPUP DIALOG
  // ============================
  Future<void> _openEditDialog(KeluargaModel item) async {
    final kepalaC = TextEditingController(text: item.kepalaKeluarga);
    final noKkC = TextEditingController(text: item.noKk);
    final jumlahC = TextEditingController(text: item.jumlahAnggota);

    String status = item.statusKeluarga.isEmpty
        ? "aktif"
        : item.statusKeluarga.toLowerCase();
    if (!['aktif', 'pindah', 'sementara'].contains(status)) {
      status = 'aktif';
    }

    String? rumahId = item.idRumah.isEmpty ? null : item.idRumah;

    final updated = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return Dialog(
            insetPadding: const EdgeInsets.all(20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Edit Keluarga",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 16),
                    TextField(
                      controller: kepalaC,
                      decoration:
                          const InputDecoration(labelText: "Kepala Keluarga"),
                    ),
                    TextField(
                      controller: noKkC,
                      decoration: const InputDecoration(labelText: "No KK"),
                    ),
                    const SizedBox(height: 10),

                    // STATUS KELUARGA
                    DropdownButtonFormField<String>(
                      value: status,
                      decoration:
                          const InputDecoration(labelText: "Status Keluarga"),
                      items: const [
                        DropdownMenuItem(value: "aktif", child: Text("Aktif")),
                        DropdownMenuItem(
                            value: "pindah", child: Text("Pindah")),
                        DropdownMenuItem(
                            value: "sementara", child: Text("Sementara")),
                      ],
                      onChanged: (v) =>
                          setStateDialog(() => status = v ?? "aktif"),
                    ),

                    const SizedBox(height: 10),

                    // DROPDOWN RUMAH
                    _loadingRumah
                        ? const LinearProgressIndicator()
                        : DropdownButtonFormField<String>(
                            value: rumahId,
                            decoration:
                                const InputDecoration(labelText: "Pilih Rumah"),
                            isExpanded: true,
                            items: _listRumah.map((r) {
                              return DropdownMenuItem(
                                value: r.docId,
                                child: Text("No. ${r.nomor} • ${r.alamat}"),
                              );
                            }).toList(),
                            onChanged: (v) => setStateDialog(() => rumahId = v),
                          ),

                    const SizedBox(height: 10),
                    TextField(
                      controller: jumlahC,
                      decoration:
                          const InputDecoration(labelText: "Jumlah Anggota"),
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
                              "kepala_keluarga": kepalaC.text.trim(),
                              "no_kk": noKkC.text.trim(),
                              "jumlah_anggota": jumlahC.text.trim(),
                              "status_keluarga": status,
                              "id_rumah": rumahId ?? "",
                            };

                            final ok =
                                await _controller.update(item.uid, dataUpdate);

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
        },
      ),
    );

    if (updated == true) {
      loadData();
    }
  }

  // ============================
  // HAPUS KELUARGA
  // ============================
  void _confirmDelete(KeluargaModel item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Keluarga?"),
        content:
            Text("Yakin ingin menghapus keluarga '${item.kepalaKeluarga}'?"),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus"),
            onPressed: () async {
              Navigator.pop(context);
              final ok = await _controller.delete(item.uid);
              if (ok) loadData();
            },
          ),
        ],
      ),
    );
  }

  Widget _row(String l, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text("$l: $v"),
    );
  }

  /// 🔍 Helper: cek apakah 1 keluarga lolos filter
  bool _matchFilter(KeluargaModel k) {
    final fNama =
        (_activeFilter['nama_kepala'] ?? '').toString().trim().toLowerCase();
    final fStatus = (_activeFilter['status_keluarga'] ?? '')
        .toString()
        .trim()
        .toLowerCase();
    final fRumah =
        (_activeFilter['id_rumah'] ?? '').toString().trim().toLowerCase();

    // nama kepala keluarga
    if (fNama.isNotEmpty && !k.kepalaKeluarga.toLowerCase().contains(fNama)) {
      return false;
    }

    // status keluarga (abaikan jika kosong / "semua")
    if (fStatus.isNotEmpty &&
        fStatus != 'semua' &&
        k.statusKeluarga.toLowerCase() != fStatus) {
      return false;
    }

    // id_rumah (docId) mengandung teks (kalau user copy paste docId sebagian)
    if (fRumah.isNotEmpty && !k.idRumah.toLowerCase().contains(fRumah)) {
      return false;
    }

    return true;
  }

  // ============================
  // BUILD UI
  // ============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F2F9),
      drawer: const AppSidebar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0C88C2),
        onPressed: () async {
          final res = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahKeluargaPage()),
          );
          if (res == true) loadData();
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: SafeArea(
        child: Column(
          children: [
            MainHeader(
              title: "Data Keluarga",
              searchHint: "Cari kepala keluarga...",
              showSearchBar: true,
              showFilterButton: true,
              onSearch: (v) => setState(() => search = v.trim()),
              onFilter: () => showDialog(
                context: context,
                builder: (_) => FilterKeluargaDialog(
                  onApply: (f) {
                    setState(() {
                      _activeFilter = f;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: data.length,
                itemBuilder: (_, i) {
                  final item = data[i];

                  // 🔍 text search utama
                  if (search.isNotEmpty &&
                      !item.kepalaKeluarga
                          .toLowerCase()
                          .contains(search.toLowerCase())) {
                    return const SizedBox();
                  }

                  // 🎯 filter dari dialog
                  if (!_matchFilter(item)) {
                    return const SizedBox();
                  }

                  return KeluargaCard(
                    data: item,
                    onDetail: () => _showDetail(item),
                    onEdit: () => _openEditDialog(item),
                    onDelete: () => _confirmDelete(item),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
