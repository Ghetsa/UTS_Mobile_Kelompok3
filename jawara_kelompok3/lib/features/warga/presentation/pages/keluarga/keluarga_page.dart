import 'package:flutter/material.dart';
import '../../../data/models/keluarga_model.dart';
import '../../../data/services/keluarga_service.dart';
import '../../../../../core/layout/header.dart';
import '../../../../../core/layout/sidebar.dart';
import '../../widgets/card/keluarga_card.dart';
import '../../widgets/filter/keluarga_filter.dart';

class DaftarKeluargaPage extends StatefulWidget {
  const DaftarKeluargaPage({super.key});

  @override
  State<DaftarKeluargaPage> createState() => _DaftarKeluargaPageState();
}

class _DaftarKeluargaPageState extends State<DaftarKeluargaPage> {
  final KeluargaService _service = KeluargaService();
  List<KeluargaModel> data = [];

  String search = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    data = await _service.getDataKeluarga();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F2F9),
      drawer: const AppSidebar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0C88C2),
        elevation: 4,
        onPressed: () {
          print("TAMBAH KELUARGA DITEKAN");
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

                  /// ------------------------------------
                  /// 🔍 Search berdasarkan kepala_keluarga
                  /// ------------------------------------
                  if (search.isNotEmpty &&
                      !item.kepalaKeluarga
                          .toLowerCase()
                          .contains(search.toLowerCase())) {
                    return const SizedBox();
                  }

                  return KeluargaCard(
                    data: item,
                    onDetail: () {},
                    onEdit: () {},
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
