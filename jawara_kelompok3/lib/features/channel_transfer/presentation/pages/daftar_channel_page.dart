import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

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

  // CETAK PDF DATA CHANNEL
  Future<void> _cetakPdf(List<ChannelTransfer> list) async {
    if (list.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tidak ada data channel untuk dicetak."),
        ),
      );
      return;
    }

    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          build: (context) => [
            pw.Text(
              "Laporan Daftar Channel Transfer",
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              "Dicetak: ${DateTime.now()}",
              style: const pw.TextStyle(fontSize: 10),
            ),
            pw.SizedBox(height: 16),
            pw.Table.fromTextArray(
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
              cellStyle: const pw.TextStyle(fontSize: 9),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
              headers: const [
                'Nama Channel',
                'Tipe',
                'Nomor Rekening',
                'Pemilik',
                'Catatan',
              ],
              data: List.generate(list.length, (i) {
                final c = list[i];
                return [
                  (i + 1).toString(),
                  c.namaChannel,
                  c.jenis,
                  c.namaPemilik,
                  c.catatan ?? '-',
                ];
              }),
            ),
          ],
        ),
      );

      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mencetak PDF: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter search + filter tipe
    final filteredList = channelData.where((item) {
      if (search.isNotEmpty &&
          !item.namaChannel.toLowerCase().contains(search.toLowerCase())) {
        return false;
      }
      if (selectedFilter != 'Semua' && item.jenis != selectedFilter) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE9F2F9),
      drawer: const AppSidebar(),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'printChannel',
            backgroundColor: Colors.red,
            elevation: 4,
            onPressed: () => _cetakPdf(filteredList),
            child:
                const Icon(Icons.picture_as_pdf, size: 26, color: Colors.white),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'addChannel',
            backgroundColor: const Color(0xFF0C88C2),
            elevation: 4,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TambahChannelPage()),
              ).then((_) => _loadChannels());
            },
            child: const Icon(Icons.add, size: 32, color: Colors.white),
          ),
        ],
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
                itemCount: filteredList.length,
                itemBuilder: (_, i) {
                  final item = filteredList[i];

                  return ChannelTransferCard(
                    index: i + 1,
                    data: item,
                    onDetail: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailChannelPage(
                            channel: {
                              'nama_channel': item.namaChannel,
                              'tipe': item.jenis,
                              'nama_pemilik': item.namaPemilik,
                              'no_rekening': item.nomorRekening,
                              'catatan': item.catatan ?? '-',
                              'thumbnail_url': item.thumbnail ?? '',
                              'qr_url': item.qr ?? '',
                            },
                          ),
                        ),
                      );
                    },
                    onEdit: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditChannelPage(
                            channel: {
                              'docId': item.docId,
                              'nama_channel': item.namaChannel,
                              'tipe': item.jenis,
                              'nama_pemilik': item.namaPemilik,
                              'no_rekening': item.nomorRekening,
                              'catatan': item.catatan ?? '',
                              'thumbnail_url': item.thumbnail ?? '',
                              'qr_url': item.qr ?? '',
                            },
                          ),
                        ),
                      );

                      // Refresh daftar
                      _loadChannels();

                      // Tampilkan feedback dari halaman edit jika ada
                      if (result != null && result is Map<String, dynamic>) {
                        final status = result['status'] as String?;
                        final message = result['message'] as String?;
                        if (status != null && message != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message),
                              backgroundColor: status == "success"
                                  ? AppTheme.greenMedium
                                  : AppTheme.redMedium,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      }
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
