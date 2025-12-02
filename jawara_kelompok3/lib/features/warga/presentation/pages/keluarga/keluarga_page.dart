import 'package:flutter/material.dart';
import '../../../data/models/keluarga_model.dart';
import '../../../controller/keluarga_controller.dart';
import '../../../../../core/layout/header.dart';
import '../../../../../core/layout/sidebar.dart';
import '../../widgets/card/keluarga_card.dart';
import '../../widgets/filter/keluarga_filter.dart';
import '../keluarga/tambah_keluarga_page.dart';

class DaftarKeluargaPage extends StatefulWidget {
  const DaftarKeluargaPage({super.key});

  @override
  State<DaftarKeluargaPage> createState() => _DaftarKeluargaPageState();
}

class _DaftarKeluargaPageState extends State<DaftarKeluargaPage> {
  final KeluargaController _controller = KeluargaController();
  List<KeluargaModel> data = [];

  String search = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    data = await _controller.fetchAll();
    setState(() {});
  }

  // DETAIL
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
            _row("ID Rumah (docId)", item.idRumah),
            _row("Jumlah Anggota", item.jumlahAnggota),
            _row(
              "Dibuat",
              item.createdAt != null
                  ? item.createdAt.toString().substring(0, 16)
                  : "-",
            ),
            _row("docId", item.uid),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  // EDIT
  Future<void> _openEdit(KeluargaModel item) async {
    final kepalaC = TextEditingController(text: item.kepalaKeluarga);
    final idRumahC = TextEditingController(text: item.idRumah);
    final jumlahAnggotaC = TextEditingController(text: item.jumlahAnggota);
    final noKkC = TextEditingController(text: item.noKk);

    final updated = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Keluarga"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: kepalaC,
                decoration:
                    const InputDecoration(labelText: "Kepala Keluarga"),
              ),
              TextField(
                controller: noKkC,
                decoration: const InputDecoration(labelText: "No KK"),
              ),
              TextField(
                controller: idRumahC,
                decoration: const InputDecoration(labelText: "ID Rumah"),
              ),
              TextField(
                controller: jumlahAnggotaC,
                decoration:
                    const InputDecoration(labelText: "Jumlah Anggota"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              final dataUpdate = {
                "kepala_keluarga": kepalaC.text,
                "no_kk": noKkC.text,
                "id_rumah": idRumahC.text,
                "jumlah_anggota": jumlahAnggotaC.text,
              };

              final ok = await _controller.update(item.uid, dataUpdate);
              if (ok) {
                Navigator.pop(context, true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Gagal mengupdate data keluarga"),
                  ),
                );
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );

    if (updated == true) {
      await loadData();
    }
  }

  // HAPUS
  void _confirmDelete(KeluargaModel item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Keluarga?"),
        content: Text(
            "Yakin ingin menghapus keluarga dengan kepala '${item.kepalaKeluarga}' ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              final ok = await _controller.delete(item.uid);
              if (ok) {
                await loadData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Keluarga berhasil dihapus."),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Gagal menghapus keluarga."),
                  ),
                );
              }
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F2F9),
      drawer: const AppSidebar(),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0C88C2),
        elevation: 4,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TambahKeluargaPage(),
            ),
          );
          if (result == true) {
            await loadData();
          }
        },
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainHeader(
              title: "Data Keluarga",
              searchHint: "Cari kepala keluarga...",
              showSearchBar: true,
              showFilterButton: true,
              onSearch: (value) {
                setState(() => search = value.trim());
              },
              onFilter: () async {
                await showDialog(
                  context: context,
                  builder: (_) => FilterKeluargaDialog(
                    onApply: (filterData) {
                      // sementara print saja
                      print("HASIL FILTER: $filterData");
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: data.length,
                itemBuilder: (_, i) {
                  final item = data[i];

                  if (search.isNotEmpty &&
                      !item.kepalaKeluarga
                          .toLowerCase()
                          .contains(search.toLowerCase())) {
                    return const SizedBox();
                  }

                  return GestureDetector(
                    onLongPress: () => _confirmDelete(item),
                    child: KeluargaCard(
                      data: item,
                      onDetail: () => _showDetail(item),
                      onEdit: () => _openEdit(item),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
