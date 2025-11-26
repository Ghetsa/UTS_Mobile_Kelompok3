import 'package:flutter/material.dart';
import '../../../data/models/warga_model.dart';
import '../../../data/services/warga_service.dart';
import '../../../../../core/layout/header.dart';
import '../../../../../core/layout/sidebar.dart';
import '../../widgets/card/warga_card.dart';
import '../../widgets/filter/warga_filter.dart';

class DaftarWargaPage extends StatefulWidget {
  const DaftarWargaPage({super.key});

  @override
  State<DaftarWargaPage> createState() => _DaftarWargaPageState();
}

class _DaftarWargaPageState extends State<DaftarWargaPage> {
  final WargaService _service = WargaService();
  List<WargaModel> data = [];

  String search = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    data = await _service.getAllWarga();
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
          print("TAMBAH WARGA DITEKAN");
        },
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔵 Header seperti Keluarga
            MainHeader(
              title: "Data Warga",
              searchHint: "Cari nama warga...",
              showSearchBar: true,
              showFilterButton: true,
              onSearch: (value) {
                setState(() => search = value.trim());
              },
              onFilter: () async {
                await showDialog(
                  context: context,
                  builder: (_) => FilterWargaDialog(
                    onApply: (filterData) {
                      print("HASIL FILTER WARGA: $filterData");
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

                  // 🔍 Filter search nama warga
                  if (search.isNotEmpty &&
                      !item.nama.toLowerCase().contains(search.toLowerCase())) {
                    return const SizedBox();
                  }

                  // return WargaCard(
                  //   data: item,
                  //   onDetail: () {},
                  //   onEdit: () {},
                  // );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
