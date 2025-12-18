import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../laporan/presentation/widgets/card/tagihan_warga_card.dart';
import '../../../laporan/data/models/tagihan_warga_model.dart';
import '../../../laporan/controller/tagihan_warga_controller.dart';
import '../../../../../../core/layout/header_warga.dart';
import '../../../../../../core/layout/sidebar_warga.dart';

class TagihanWargaPage extends StatefulWidget {
  const TagihanWargaPage({super.key});

  @override
  State<TagihanWargaPage> createState() => _TagihanWargaPageState();
}

class _TagihanWargaPageState extends State<TagihanWargaPage> {
  final TagihanController _controller = TagihanController();
  List<TagihanWargaModel> dataTagihan = [];
  bool _loading = true;
  String search = "";
  String kepalaKeluargaId = "id_anda";

  @override
  void initState() {
    super.initState();
    _loadTagihan();
  }

  Future<void> _loadTagihan() async {
    setState(() => _loading = true);
    final tagihanList = await _controller.fetchByKepalaKeluargaId(kepalaKeluargaId);
    setState(() {
      dataTagihan = List<TagihanWargaModel>.from(tagihanList);
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
              title: "Tagihan",
              searchHint: "Cari tagihan...",
              showSearchBar: true,
              onSearch: null,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: dataTagihan.length,
                      itemBuilder: (context, index) {
                        final tagihan = dataTagihan[index];
                        return TagihanCardWarga(data: tagihan);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
