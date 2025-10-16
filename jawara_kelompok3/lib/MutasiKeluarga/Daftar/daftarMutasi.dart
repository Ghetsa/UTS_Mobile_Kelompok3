import 'package:flutter/material.dart';
import '../../Layout/sidebar.dart';
import '../mutasi_model.dart';
import 'detailMutasi.dart';

/// ─────────────────────────────
/// Halaman utama daftar mutasi
/// ─────────────────────────────
class DaftarMutasiPage extends StatefulWidget {
  const DaftarMutasiPage({super.key});

  @override
  State<DaftarMutasiPage> createState() => _DaftarMutasiPageState();
}

class _DaftarMutasiPageState extends State<DaftarMutasiPage> {
  String? filterJenis;
  String? filterKeluarga;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Mutasi> getFilteredMutasi() {
    var daftar = MutasiStorage.daftar;
    if (filterJenis != null) {
      daftar = daftar.where((m) => m.jenis == filterJenis).toList();
    }
    if (filterKeluarga != null) {
      daftar = daftar.where((m) => m.keluarga == filterKeluarga).toList();
    }
    return daftar;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutasiList = getFilteredMutasi();

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppSidebar(),
      appBar: AppBar(
        title: const Text("Daftar Mutasi Keluarga"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: "Filter Mutasi",
            onPressed: () async {
              final result = await showDialog(
                context: context,
                builder: (context) => FilterMutasiDialog(
                  initialJenis: filterJenis,
                  initialKeluarga: filterKeluarga,
                ),
              );

              if (result != null) {
                setState(() {
                  filterJenis = result['jenis'];
                  filterKeluarga = result['keluarga'];
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (filterJenis != null || filterKeluarga != null) ...[
                  Text(
                    "Filter Aktif:",
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  if (filterJenis != null) Text("Jenis Mutasi: $filterJenis"),
                  if (filterKeluarga != null) Text("Keluarga: $filterKeluarga"),
                ],
                const Divider(height: 24),

                // Header tabel
                Row(
                  children: const [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "No",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Tanggal",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "Keluarga",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Jenis",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Aksi",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const Divider(),

                // Daftar isi tabel
                Expanded(
                  child: mutasiList.isEmpty
                      ? const Center(
                          child: Text('Belum ada data mutasi'),
                        )
                      : ListView.builder(
                          itemCount: mutasiList.length,
                          itemBuilder: (context, index) {
                            final item = mutasiList[index];
                            return Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "${index + 1}",
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "${item.tanggal.day}/${item.tanggal.month}/${item.tanggal.year}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      item.keluarga,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        Container(
                                          constraints: const BoxConstraints(
                                            minWidth: 80,
                                            maxWidth: 100,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                            horizontal: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: item.jenis == 'Keluar'
                                                ? Colors.red.withOpacity(0.1)
                                                : Colors.green.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            item.jenis,
                                            style: TextStyle(
                                              color: item.jenis == 'Keluar'
                                                  ? Colors.red
                                                  : Colors.green,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      icon: const Icon(Icons.more_horiz),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailMutasiPage(mutasi: item),
                                          ),
                                        );
                                      },
                                      tooltip: 'Lihat Detail',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ─────────────────────────────
/// Dialog filter mutasi keluarga
/// ─────────────────────────────
class FilterMutasiDialog extends StatefulWidget {
  final String? initialJenis;
  final String? initialKeluarga;

  const FilterMutasiDialog(
      {super.key, this.initialJenis, this.initialKeluarga});

  @override
  State<FilterMutasiDialog> createState() => _FilterMutasiDialogState();
}

class _FilterMutasiDialogState extends State<FilterMutasiDialog> {
  String? _selectedJenis;
  String? _selectedKeluarga;

  final List<String> jenisList = [
    '-- Pilih Jenis Mutasi --',
    'Masuk',
    'Keluar',
  ];

  @override
  void initState() {
    super.initState();
    _selectedJenis = widget.initialJenis;
    _selectedKeluarga = widget.initialKeluarga;
  }

  List<String> get keluargaList {
    final uniqueKeluarga =
        MutasiStorage.daftar.map((m) => m.keluarga).toSet().toList()..sort();
    return ['-- Pilih Keluarga --', ...uniqueKeluarga];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dialog
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Filter Mutasi Keluarga",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Dropdown Jenis Mutasi
              DropdownButtonFormField<String>(
                value: _selectedJenis,
                decoration: const InputDecoration(
                  labelText: "Jenis Mutasi",
                  border: OutlineInputBorder(),
                ),
                items: jenisList
                    .map((e) => DropdownMenuItem(
                        value: e == '-- Pilih Jenis Mutasi --' ? null : e,
                        child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedJenis = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Dropdown Keluarga
              DropdownButtonFormField<String>(
                value: _selectedKeluarga,
                decoration: const InputDecoration(
                  labelText: "Keluarga",
                  border: OutlineInputBorder(),
                ),
                items: keluargaList
                    .map((e) => DropdownMenuItem(
                        value: e == '-- Pilih Keluarga --' ? null : e,
                        child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedKeluarga = value;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Tombol Reset & Terapkan
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedJenis = null;
                        _selectedKeluarga = null;
                      });
                      // Return null values to clear filters
                      Navigator.pop(context, {
                        'jenis': null,
                        'keluarga': null,
                      });
                    },
                    child: const Text("Reset Filter"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.pop(context, {
                        'jenis': _selectedJenis,
                        'keluarga': _selectedKeluarga,
                      });
                    },
                    child: const Text("Terapkan"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
