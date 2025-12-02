import 'package:flutter/material.dart';
import '../../../data/models/mutasi_model.dart';
import '../../../data/services/mutasi_service.dart';
import '../../../../../core/layout/header.dart';
import '../../../../../core/layout/sidebar.dart';
import '../../widgets/card/mutasi_card.dart';
import '../../widgets/filter/mutasi_filter.dart';

class MutasiDaftarPage extends StatefulWidget {
  const MutasiDaftarPage({super.key});

  @override
  State<MutasiDaftarPage> createState() => _MutasiDaftarPageState();
}

class _MutasiDaftarPageState extends State<MutasiDaftarPage> {
  final MutasiService _service = MutasiService();
  List<MutasiModel> data = [];

  String search = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  /// Ambil semua data mutasi dari Firestore
  void loadData() async {
    data = await _service.getAllMutasi();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F2F9),
      drawer: const AppSidebar(),

      /// Tombol Tambah
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0C88C2),
        elevation: 4,
        onPressed: () {
          print("TAMBAH MUTASI DITEKAN");
        },
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header dengan search + filter
            MainHeader(
              title: "Data Mutasi",
              searchHint: "Cari nama warga...",
              showSearchBar: true,
              showFilterButton: true,
              onSearch: (value) {
                setState(() => search = value.trim());
              },
              onFilter: () async {
                await showDialog(
                  context: context,
                  builder: (_) => FilterMutasiDialog(
                    onApply: (filterData) {
                      print("HASIL FILTER: $filterData");
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            /// LIST DATA
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: data.length,
                itemBuilder: (_, i) {
                  final item = data[i];

                  // ------------------------------------
                  // 🔍 Search berdasarkan nama (id_warga nanti kamu mapping)
                  // ------------------------------------
                  if (search.isNotEmpty &&
                      !item.idWarga
                          .toLowerCase()
                          .contains(search.toLowerCase())) {
                    return const SizedBox();
                  }

                  return MutasiCard(
                    data: item,
                    onDetail: () {
                      print("DETAIL MUTASI: ${item.uid}");
                    },
                    onEdit: () {
                      print("EDIT MUTASI: ${item.uid}");
                    },
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
