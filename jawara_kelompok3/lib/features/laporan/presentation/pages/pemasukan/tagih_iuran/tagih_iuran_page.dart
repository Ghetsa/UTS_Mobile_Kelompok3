import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../controller/tagih_iuran_controller.dart';
import '../../../../data/services/kategori_iuran_service.dart';
import '../../../../data/models/kategori_iuran_model.dart';
import '../../../widgets/card/tagihan_card.dart';
import '../../../../data/models/tagihan_model.dart';
import '../../../../../../core/layout/header.dart';
import '../../../../../../core/layout/sidebar.dart';

class TagihIuranPage extends StatefulWidget {
  const TagihIuranPage({super.key});

  @override
  State<TagihIuranPage> createState() => _TagihIuranPageState();
}

class _TagihIuranPageState extends State<TagihIuranPage> {
  final TagihanController _tagihanController = TagihanController();
  final KategoriIuranService _kategoriIuranService = KategoriIuranService();
  String? selectedIuran;
  List<String> iuranList = [];
  List<KategoriIuranModel> kategoriIuranList = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadKategoriIuran();
  }

  // Load Kategori Iuran from Firestore
  Future<void> _loadKategoriIuran() async {
    setState(() {
      _loading = true;
    });
    final kategoriIuran = await _kategoriIuranService.getAll();
    setState(() {
      kategoriIuranList = kategoriIuran;
      iuranList = kategoriIuran.map((kategori) => kategori.nama).toList();
      _loading = false;
    });
  }

  // Tagih Iuran function
  Future<void> _tagihIuran() async {
    if (selectedIuran == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih jenis iuran terlebih dahulu")),
      );
      return;
    }

    // Fetch only families with status 'aktif'
    final activeFamilies = await _tagihanController.getActiveFamilies();
    if (activeFamilies.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak ada keluarga aktif")),
      );
      return;
    }

    // Get the nominal value from the selected Iuran
    final selectedKategori = kategoriIuranList.firstWhere(
      (kategori) => kategori.nama == selectedIuran,
      orElse: () => KategoriIuranModel(id: '', nama: '', jenis: '', nominal: '0'),
    );
    final nominal = selectedKategori.nominal;

    // Prepare and add data for each active family
    for (var keluarga in activeFamilies) {
      final data = {
        "keluarga": keluarga.kepalaKeluarga,  // Nama kepala keluarga
        "status": keluarga.statusKeluarga,   // Status keluarga
        "iuran": selectedIuran!,             // Jenis iuran dari dropdown
        "kode": "IUR-${DateTime.now().millisecondsSinceEpoch}", // Kode tagihan
        "nominal": nominal,                  // Nominal iuran sesuai kategori
        "tagihanStatus": "Belum Dibayar",    // Status tagihan
      };

      final success = await _tagihanController.addTagihan(data);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tagihan berhasil ditambahkan")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menambahkan tagihan"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      drawer: const AppSidebar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MainHeader(
              title: "Tagih Iuran",
              showSearchBar: false,
              showFilterButton: false,
            ),
            const SizedBox(height: 18),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Tagih Iuran ke Semua Keluarga Aktif",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        _loading
                            ? const Center(child: CircularProgressIndicator())
                            : DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: "Jenis Iuran",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                                value: selectedIuran,
                                hint: const Text("-- Pilih Iuran --"),
                                items: iuranList.map((iuran) {
                                  return DropdownMenuItem(value: iuran, child: Text(iuran));
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedIuran = value;
                                  });
                                },
                              ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:  const Color(0xFF0C88C2),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                              onPressed: _tagihIuran,
                              child: const Text("Tagih Iuran"),
                            ),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.blueSuperDark,
                                side: const BorderSide(color: AppTheme.blueSuperDark),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                              onPressed: () {
                                setState(() => selectedIuran = null);
                              },
                              child: const Text("Reset"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/pemasukan/tagihan');
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                label: const Text(
                  "Kembali",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:  const Color(0xFF0C88C2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
