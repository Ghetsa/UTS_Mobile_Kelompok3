import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/layout/header.dart';
import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/pengguna_model.dart';
import '../widgets/card/pengguna_card.dart';
import '../widgets/filter/pengguna_filter.dart';
import 'detail_pengguna_page.dart';
import 'edit_pengguna_page.dart';
import 'tambah_pengguna_page.dart';

class DaftarPenggunaPage extends StatefulWidget {
  const DaftarPenggunaPage({super.key});

  @override
  State<DaftarPenggunaPage> createState() => _DaftarPenggunaPageState();
}

class _DaftarPenggunaPageState extends State<DaftarPenggunaPage> {
  List<User> data = [];
  String search = "";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('pengguna')
        .orderBy('created_at', descending: true)
        .get();

    setState(() {
      data = snapshot.docs
          .map((doc) => User.fromFirestore(doc.id, doc.data()))
          .toList();
    });
  }

  void _confirmDelete(User item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Pengguna"),
        content: Text("Yakin ingin menghapus '${item.nama}' ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: AppTheme.redMedium),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(item.docId)
                  .delete();

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Pengguna berhasil dihapus."),
                  backgroundColor: AppTheme.greenMedium,
                ),
              );
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F2F9),
      drawer: const AppSidebar(),

      // FAB biru cerah
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0C88C2),
        elevation: 4,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahPenggunaPage()),
          ).then((_) => _loadData());
        },
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            MainHeader(
              title: "Data Pengguna",
              searchHint: "Cari nama pengguna...",
              showSearchBar: true,
              showFilterButton: true,
              onSearch: (value) {
                setState(() => search = value.trim());
              },
              onFilter: () async {
                await showDialog(
                  context: context,
                  builder: (_) => FilterPenggunaDialog(
                    onApply: (filterData) {},
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // LIST PENGGUNA
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .orderBy('created_at', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return const Center(child: CircularProgressIndicator());

                  final users = snapshot.data!.docs
                      .map((doc) => User.fromFirestore(doc.id, doc.data()))
                      .toList();

                  // filter search
                  final filteredUsers = search.isEmpty
                      ? users
                      : users
                          .where((u) => u.nama
                              .toLowerCase()
                              .contains(search.toLowerCase()))
                          .toList();

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredUsers.length,
                    itemBuilder: (_, i) {
                      final user = filteredUsers[i];

                      return PenggunaCard(
                        index: i + 1,
                        data: user,
                        onDetail: () {
                          showDialog(
                            context: context,
                            builder: (_) => DetailPenggunaPage(user: user),
                          );
                        },
                        onEdit: () async {
                          final updated = await showDialog(
                            context: context,
                            builder: (_) => EditPenggunaPage(user: user),
                          );
                          if (updated == true) _loadData();
                        },
                        onDelete: () => _confirmDelete(user),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
