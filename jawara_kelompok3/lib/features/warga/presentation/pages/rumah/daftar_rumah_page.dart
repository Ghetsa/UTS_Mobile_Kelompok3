import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/layout/sidebar.dart';
import '../../../../../core/layout/header.dart';
import '../../../data/models/rumah_model.dart';
import '../../../data/services/rumah_service.dart';
import '../../widgets/card/rumah_card.dart';
import '../../widgets/filter/rumah_filter.dart';
import 'detail_rumah_page.dart';
import 'edit_rumah_page.dart';
import 'tambah_rumah_page.dart';

class DaftarRumahPage extends StatefulWidget {
  const DaftarRumahPage({super.key});

  @override
  State<DaftarRumahPage> createState() => _DaftarRumahPageState();
}

class _DaftarRumahPageState extends State<DaftarRumahPage> {
  final RumahService _service = RumahService();
  List<RumahModel> data = [];

  String search = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    data = await _service.getAllRumah();
    setState(() {});
  }

  void _openAdd() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TambahRumahPage()),
    );

    if (result == true) loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      drawer: const AppSidebar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryBlue,
        elevation: 4,
        onPressed: _openAdd,
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER MIRIP WARGA
            MainHeader(
              title: "Data Rumah",
              searchHint: "Cari alamat atau penghuni...",
              showSearchBar: true,
              showFilterButton: true,
              onSearch: (value) {
                setState(() => search = value.trim());
              },
              onFilter: () async {
                await showDialog(
                  context: context,
                  builder: (_) => FilterRumahDialog(
                    onApply: (filterData) {
                      print("HASIL FILTER RUMAH: $filterData");
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

                  // FILTER SEARCH
                  if (search.isNotEmpty &&
                      !("${item.alamat} ${item.penghuni}")
                          .toLowerCase()
                          .contains(search.toLowerCase())) {
                    return const SizedBox();
                  }

                  return RumahCard(
                    data: item,
                    onDetail: () async {
                      await showDialog(
                        context: context,
                        builder: (_) => DetailRumahDialog(rumah: item),
                      );
                    },
                    onEdit: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (_) => EditRumahDialog(rumah: item),
                      );
                      if (result == true) loadData();
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
