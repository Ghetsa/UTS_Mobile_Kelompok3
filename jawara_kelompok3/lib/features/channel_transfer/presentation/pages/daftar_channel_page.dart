import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/layout/header.dart';
import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/channel_transfer_model.dart';
import '../widgets/card/channel_transfer_card.dart';
import 'detail_channel_page.dart';
import 'edit_channel_page.dart';
import 'tambah_channel_page.dart';

class DaftarChannelPage extends StatefulWidget {
  const DaftarChannelPage({super.key});

  @override
  State<DaftarChannelPage> createState() => _DaftarChannelPageState();
}

class _DaftarChannelPageState extends State<DaftarChannelPage> {
  List<ChannelTransfer> channelData = [];
  String search = "";
  String selectedFilter = 'Semua';

  final List<String> filterOptions = ['Semua', 'manual', 'otomatis'];

  @override
  void initState() {
    super.initState();
    _loadChannels();
  }

  Future<void> _loadChannels() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('channel_transfer')
        .orderBy('created_at', descending: true)
        .get();

    setState(() {
      channelData = snapshot.docs
          .map((doc) => ChannelTransfer.fromFirestore(doc.id, doc.data()))
          .toList();
    });
  }

  void _showFilterDialog() {
    String tempValue = selectedFilter;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text("Filter Tipe Channel"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: filterOptions.map((tipe) {
                return RadioListTile<String>(
                  value: tipe,
                  title: Text(tipe.toUpperCase()),
                  groupValue: tempValue,
                  onChanged: (v) => setStateDialog(() => tempValue = v!),
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal")),
              ElevatedButton(
                onPressed: () {
                  setState(() => selectedFilter = tempValue);
                  Navigator.pop(context);
                },
                child: const Text("Terapkan"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmDelete(ChannelTransfer item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Channel?"),
        content: Text("Yakin ingin menghapus '${item.namaChannel}' ?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal")),
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
          Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const TambahChannelPage()))
              .then((_) => _loadChannels());
        },
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainHeader(
              title: "Daftar Channel Transfer",
              searchHint: "Cari channel...",
              showSearchBar: true,
              showFilterButton: true,
              onSearch: (value) => setState(() => search = value.trim()),
              onFilter: _showFilterDialog,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: channelData.length,
                itemBuilder: (_, i) {
                  final item = channelData[i];

                  // Filter search
                  if (search.isNotEmpty &&
                      !item.namaChannel
                          .toLowerCase()
                          .contains(search.toLowerCase())) {
                    return const SizedBox();
                  }

                  // Filter tipe
                  if (selectedFilter != 'Semua' &&
                      item.jenis != selectedFilter) {
                    return const SizedBox();
                  }

                  return ChannelTransferCard(
                    index: i + 1,
                    data: item,
                    onDetail: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailChannelPage(
                            channel: {
                              'namaChannel': item.namaChannel,
                              'tipe': item.jenis,
                              'pemilik': item.namaPemilik,
                              'catatan': item.catatan ?? '-',
                              'thumbnail': item.thumbnail ?? '',
                              'qr': item.qr ?? '',
                            },
                          ),
                        ),
                      );
                    },
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditChannelPage(
                            channel: {
                              'docId': item.docId,
                              'nama': item.namaChannel,
                              'tipe': item.jenis,
                              'pemilik': item.namaPemilik,
                              'catatan': item.catatan ?? '',
                              'thumbnail': item.thumbnail ?? '',
                              'qr': item.qr ?? '',
                            },
                          ),
                        ),
                      ).then((_) => _loadChannels());
                    },
                    onDelete: () => _confirmDelete(item),
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
