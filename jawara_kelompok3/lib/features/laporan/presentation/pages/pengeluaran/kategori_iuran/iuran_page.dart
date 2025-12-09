import 'package:flutter/material.dart';
import '../../../../../../../core/layout/sidebar.dart';
import '../../../../../../../core/theme/app_theme.dart';
import 'tambah_iuran_page.dart';

class IuranPage extends StatefulWidget {
  const IuranPage({super.key});

  @override
  State<IuranPage> createState() => _IuranPageState();
}

class _IuranPageState extends State<IuranPage> {
  // Dummy data (nanti diganti dari Firestore)
  List<Map<String, dynamic>> kategori = [
    {"id": "1", "nama": "Operasional Kantor"},
    {"id": "2", "nama": "Maintenance Mesin"},
    {"id": "3", "nama": "Kebersihan"},
  ];

  void _hapusKategori(String id) {
    setState(() {
      kategori.removeWhere((item) => item["id"] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Kategori berhasil dihapus.")),
    );
  }

  void _editKategori(Map<String, dynamic> data) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (_) => TambahIuranPage(
        isEdit: true,
        dataEdit: data,
      ),
    );

    if (result != null) {
      setState(() {
        final index = kategori.indexWhere((e) => e["id"] == data["id"]);
        kategori[index] = result;
      });
    }
  }

  void _tambahKategori() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TambahIuranPage(),
      ),
    );

    if (result != null) {
      setState(() => kategori.add(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kategori Iuran - Pengeluaran")),
      drawer: const AppSidebar(),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahKategori,
        backgroundColor: AppTheme.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: kategori.length,
          itemBuilder: (context, index) {
            final item = kategori[index];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.category, color: Colors.blue),
                title: Text(item["nama"],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == "edit") {
                      _editKategori(item);
                    } else if (value == "hapus") {
                      _hapusKategori(item["id"]);
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: "edit",
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.orange),
                          SizedBox(width: 8),
                          Text("Edit"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: "hapus",
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text("Hapus"),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
