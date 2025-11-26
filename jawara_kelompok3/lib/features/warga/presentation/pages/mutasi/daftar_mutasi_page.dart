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

// import 'package:flutter/material.dart';
// import '../../../../../core/theme/app_theme.dart';
// import '../../../../../core/layout/sidebar.dart';
// import 'detail_mutasi_page.dart';
// import 'edit_mutasi_page.dart';

// class MutasiDaftarPage extends StatefulWidget {
//   const MutasiDaftarPage({super.key});

//   @override
//   State<MutasiDaftarPage> createState() => _MutasiDaftarPageState();
// }

// class _MutasiDaftarPageState extends State<MutasiDaftarPage> {
//   late List<Map<String, String>> mutasi;

//   @override
//   void initState() {
//     super.initState();
//     mutasi = [
//       {
//         "no": "1",
//         "nama": "Bapak Ahmad Sutrisno",
//         "jenis": "Masuk",
//         "tanggal": "13 Oktober 2025",
//         "alamat": "Jl. Mawar No. 5, Blok A",
//         "keterangan": "Pindahan dari Surabaya"
//       },
//       {
//         "no": "2",
//         "nama": "Ibu Sinta Dewi",
//         "jenis": "Keluar",
//         "tanggal": "12 Agustus 2025",
//         "alamat": "Jl. Melati No. 7, Blok B",
//         "keterangan": "Pindah ke Bandung"
//       },
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const AppSidebar(),
//       appBar: AppBar(
//         title: const Text("Mutasi Keluarga - Daftar"),
//         backgroundColor: AppTheme.primaryBlue,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Align(
//               alignment: Alignment.centerRight,
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppTheme.yellowDark,
//                   foregroundColor: Colors.white,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                 ),
//                 onPressed: () {},
//                 icon: const Icon(Icons.filter_alt),
//                 label: const Text("Filter"),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Daftar Mutasi
//             Expanded(
//               child: ListView.builder(
//                 itemCount: mutasi.length,
//                 itemBuilder: (context, index) {
//                   final item = mutasi[index];
//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     elevation: 0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       side: BorderSide(
//                         color: Colors.grey.shade300,
//                         width: 1.2,
//                       ),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Header
//                           Row(
//                             children: [
//                               Icon(
//                                 item["jenis"] == "Masuk"
//                                     ? Icons.home_rounded
//                                     : Icons.exit_to_app_rounded,
//                                 color: item["jenis"] == "Masuk"
//                                     ? Colors.green
//                                     : Colors.red,
//                               ),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: Text(
//                                   item["nama"]!,
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ),
//                               PopupMenuButton<String>(
//                                 icon: const Icon(Icons.more_vert,
//                                     color: AppTheme.primaryBlue),
//                                 onSelected: (value) async {
//                                   if (value == 'detail') {
//                                     showDialog(
//                                       context: context,
//                                       barrierColor:
//                                           Colors.black.withOpacity(0.5),
//                                       builder: (_) =>
//                                           DetailMutasiDialog(mutasi: item),
//                                     );
//                                   } else if (value == 'edit') {
//                                     final updated =
//                                         await showDialog<Map<String, String>>(
//                                       context: context,
//                                       barrierColor:
//                                           Colors.black.withOpacity(0.5),
//                                       builder: (_) =>
//                                           EditMutasiDialog(mutasi: item),
//                                     );
//                                     if (updated != null) {
//                                       setState(() {
//                                         final i = mutasi.indexOf(item);
//                                         mutasi[i] = updated;
//                                       });
//                                     }
//                                   }
//                                 },
//                                 itemBuilder: (context) => const [
//                                   PopupMenuItem(
//                                     value: 'detail',
//                                     child: Row(
//                                       children: [
//                                         Icon(Icons.visibility,
//                                             color: Colors.blue),
//                                         SizedBox(width: 8),
//                                         Text("Lihat Detail"),
//                                       ],
//                                     ),
//                                   ),
//                                   PopupMenuItem(
//                                     value: 'edit',
//                                     child: Row(
//                                       children: [
//                                         Icon(Icons.edit, color: Colors.orange),
//                                         SizedBox(width: 8),
//                                         Text("Edit"),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 12),

//                           _buildInfoRow("Jenis Mutasi", item["jenis"]!),
//                           _buildInfoRow("Tanggal", item["tanggal"]!),
//                           _buildInfoRow("Alamat", item["alamat"]!),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Widget _buildInfoRow(String label, String value) {
//   return Padding(
//     padding: const EdgeInsets.only(bottom: 4),
//     child: Text.rich(
//       TextSpan(
//         children: [
//           TextSpan(
//             text: "$label: ",
//             style: const TextStyle(fontWeight: FontWeight.w600),
//           ),
//           TextSpan(text: value),
//         ],
//       ),
//     ),
//   );
// }
