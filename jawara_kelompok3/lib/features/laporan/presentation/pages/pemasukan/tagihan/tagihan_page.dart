import 'package:flutter/material.dart';
import '../../../../../../core/layout/header.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../widgets/filter/tagihan_filter.dart';
import '../../../widgets/dialog/detail_tagihan_dialog.dart';
import '../../../widgets/dialog/edit_tagihan_dialog.dart';
import '../../../widgets/card/tagihan_card.dart';
import '../../../../data/models/tagihan_model.dart';
import '../../../../data/services/tagihan_service.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'dart:io'; 

class TagihanPage extends StatefulWidget {
  const TagihanPage({super.key});

  @override
  State<TagihanPage> createState() => _TagihanPageState();
}

class _TagihanPageState extends State<TagihanPage> {
  final TagihanService _service = TagihanService();
  List<TagihanModel> dataTagihan = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await _service.getAll();
    setState(() {
      dataTagihan = list;
      _loading = false;
    });
  }
  void _showDetailDialog(TagihanModel tagihan) {
    showDialog(
      context: context,
      builder: (context) => DetailTagihanDialog(tagihan: tagihan),
    );
  }

  void _showEditDialog(TagihanModel tagihan) async {
    final updatedTagihan = await showDialog<TagihanModel>(
      context: context,
      builder: (context) => EditTagihanDialog(tagihan: tagihan),
    );

    if (updatedTagihan != null) {
      final success = await _service.update(updatedTagihan.id, updatedTagihan.toMap());
      if (success) {
        setState(() {
          final index = dataTagihan.indexWhere((item) => item.id == updatedTagihan.id);
          if (index != -1) {
            dataTagihan[index] = updatedTagihan;
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui data')),
        );
      }
    }
  }

  void _deleteTagihan(String id) async {
    final result = await _service.delete(id); 
    if (result) {
      setState(() {
        dataTagihan.removeWhere((item) => item.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data berhasil dihapus")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menghapus data"), backgroundColor: Colors.red),
      );
    }
  }

  void _generatePdf() async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Text("Tagihan Report", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            ...dataTagihan.map((tagihan) {
              return pw.Table(
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(tagihan.keluarga),
                      pw.Text(tagihan.nominal),
                      pw.Text(tagihan.periode),
                      pw.Text(tagihan.tagihanStatus),
                    ],
                  ),
                ],
              );
            }).toList(),
          ],
        );
      },
    ));

    final output = await pdf.save();
    final path = '/storage/emulated/0/Download/tagihan_report.pdf';
    final file = File(path);
    await file.writeAsBytes(output);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF berhasil disimpan di $path')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      drawer: const AppSidebar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainHeader(title: "Tagihan", showSearchBar: false, showFilterButton: false),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (_) => const FilterTagihanDialog(),
                      );
                      if (result != null) debugPrint("Filter dipilih: $result");
                    },
                    icon: const Icon(Icons.filter_alt, color: Colors.white),
                    label: const Text("Filter"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.yellowMediumDark,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _generatePdf,
                    icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                    label: const Text("Cetak PDF"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.redDark),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : dataTagihan.isEmpty
                      ? const Center(child: Text("Belum ada tagihan"))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: dataTagihan.length,
                          itemBuilder: (context, index) {
                            final row = dataTagihan[index];
                            return TagihanCard(
                              data: row,
                              onDetail: () => _showDetailDialog(row),
                              onEdit: () => _showEditDialog(row),
                              onDelete: () => _deleteTagihan(row.id),
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
