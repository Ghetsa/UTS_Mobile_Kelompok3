import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../laporan/controller/tagihan_warga_controller.dart';
import '../../../laporan/data/models/tagihan_warga_model.dart';
import '../../../laporan/presentation/widgets/card/tagihan_warga_card.dart';
import '../../../laporan/presentation/widgets/dialog/detail_tagihan_warga_dialog.dart';
import '../../../../core/layout/header_warga.dart';
import '../../../../core/layout/sidebar_warga.dart';

class TagihanWargaPage extends StatefulWidget {
  const TagihanWargaPage({super.key});

  @override
  State<TagihanWargaPage> createState() => _TagihanWargaPageState();
}

class _TagihanWargaPageState extends State<TagihanWargaPage> {
  final TagihanWargaController _tagihanController = TagihanWargaController();
  List<TagihanWargaModel> tagihanList = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTagihanWarga();
  }

  // Load tagihan warga
  Future<void> _loadTagihanWarga() async {
    setState(() => _loading = true);

    // TODO: Replace with actual keluargaId from Firebase Auth
    final keluargaId = "keluarga_id_example";

    final tagihan = await _tagihanController.getTagihanWarga(keluargaId);

    setState(() {
      tagihanList = tagihan;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      drawer: const SidebarWarga(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MainHeaderWarga(
              title: "Tagihan Warga",
              showSearchBar: false,
              showFilterButton: false,
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : tagihanList.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(24),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.receipt_long_outlined,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "Tidak ada tagihan",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadTagihanWarga,
                              child: ListView(
                                padding: const EdgeInsets.all(24),
                                children: [
                                  const Text(
                                    "Tagihan Iuran Anda",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  ...tagihanList.map((tagihan) {
                                    return TagihanCardWarga(
                                      data: tagihan,
                                      onDetail: () {
                                        // Show detail dialog
                                        showDialog(
                                          context: context,
                                          builder: (_) =>
                                              DetailTagihanWargaDialog(
                                            tagihan: tagihan,
                                          ),
                                        );
                                      },
                                      onEdit: () {
                                        // Navigate to payment form page
                                        Navigator.pushNamed(
                                          context,
                                          '/warga/bayarTagihan',
                                          arguments: tagihan,
                                        ).then((result) {
                                          // Refresh list if payment was successful
                                          if (result == true) {
                                            _loadTagihanWarga();
                                          }
                                        });
                                      },
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
