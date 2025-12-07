import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/layout/header.dart';
import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/channel_transfer_model.dart';
import 'detail_channel_page.dart';
import 'edit_channel_page.dart';

class DaftarChannelPage extends StatefulWidget {
  const DaftarChannelPage({super.key});

  @override
  State<DaftarChannelPage> createState() => _DaftarChannelPageState();
}

class _DaftarChannelPageState extends State<DaftarChannelPage> {
  List<ChannelTransfer> channelData = [];

  String search = "";
  String? selectedFilter;

  @override
  void initState() {
    super.initState();
    _loadChannels();
  }

  // Ambil data Firestore
  void _loadChannels() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('channel_transfer')
        .orderBy('created_at', descending: true)
        .get();

    setState(() {
      channelData = snapshot.docs.map((doc) {
        return ChannelTransfer.fromFirestore(doc.id, doc.data());
      }).toList();
    });
  }

  // FILTER DIALOG
  void _showFilterDialog() {
    String? tempValue = selectedFilter;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text("Filter Tipe Channel"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: ['Semua', 'manual', 'otomatis'].map((tipe) {
                return RadioListTile<String>(
                  value: tipe,
                  title: Text(tipe.toUpperCase()),
                  groupValue: tempValue,
                  onChanged: (v) {
                    setStateDialog(() => tempValue = v);
                  },
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() => selectedFilter = tempValue);
                  Navigator.pop(context);
                },
                child: const Text("Terapkan"),
              )
            ],
          );
        },
      ),
    );
  }

  // DELETE CONFIRMATION
  void _confirmDelete(ChannelTransfer item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Channel?"),
        content: Text("Yakin ingin menghapus '${item.namaChannel}' ?"),
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
                  .collection('channel_transfer')
                  .doc(item.docId)
                  .delete();

              _loadChannels();

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Channel berhasil dihapus."),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0C88C2),
        elevation: 4,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditChannelPage()),
          );
        },
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            MainHeader(
              title: "Daftar Channel Transfer",
              searchHint: "Cari channel...",
              showSearchBar: true,
              showFilterButton: true,
              onSearch: (value) {
                setState(() => search = value.trim());
              },
              onFilter: () => _showFilterDialog(),
            ),

            const SizedBox(height: 12),

            // LIST CHANNEL DARI FIRESTORE
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: channelData.length,
                itemBuilder: (_, i) {
                  final item = channelData[i];

                  // FILTER SEARCH
                  if (search.isNotEmpty &&
                      !item.namaChannel
                          .toLowerCase()
                          .contains(search.toLowerCase())) {
                    return const SizedBox();
                  }

                  // FILTER JENIS
                  if (selectedFilter != null &&
                      selectedFilter != "Semua" &&
                      item.jenis != selectedFilter) {
                    return const SizedBox();
                  }

                  return _buildChannelCard(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CARD
  Widget _buildChannelCard(ChannelTransfer item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/gambar1.jpg',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 14),

          // TEXT CHANNEL
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.namaChannel,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  item.jenis.toUpperCase(),
                  style: const TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  "A/N : ${item.namaPemilik}",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // TOMBOL AKSI
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'detail') {
                showDialog(
                  context: context,
                  builder: (_) => DetailChannelPage(
                    channel: {
                      'nama': item.namaChannel,
                      'tipe': item.jenis,
                      'a/n': item.namaPemilik,
                      'thumbnail': "",
                      'qr': "",
                    },
                  ),
                );
              } else if (value == 'edit') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditChannelPage(
                      channel: {
                        'docId': item.docId,
                        'nama': item.namaChannel,
                        'tipe': item.jenis,
                        'a/n': item.namaPemilik,
                      },
                    ),
                  ),
                );
              } else if (value == 'delete') {
                _confirmDelete(item);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'detail',
                child: Row(
                  children: [
                    Icon(Icons.info),
                    SizedBox(width: 10),
                    Text("Detail"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 10),
                    Text("Edit"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 10),
                    Text("Hapus", style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
