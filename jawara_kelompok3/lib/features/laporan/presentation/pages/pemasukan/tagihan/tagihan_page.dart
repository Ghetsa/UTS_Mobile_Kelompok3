import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../widgets/filter/tagihan_filter.dart';
import '../../../widgets/card/tagihan_card.dart';
import '../../../../data/models/tagihan_model.dart';
import '../../../../controller/tagihan_controller.dart';
import '../../../../../../core/layout/header.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../widgets/dialog/edit_tagihan_dialog.dart';
import '../../../widgets/dialog/detail_tagihan_dialog.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class TagihanPage extends StatefulWidget {
  const TagihanPage({super.key});

  @override
  State<TagihanPage> createState() => _TagihanPageState();
}

class _TagihanPageState extends State<TagihanPage> {
  final TagihanController _controller = TagihanController();
  List<TagihanModel> dataTagihan = [];
  bool _loading = true;
  String search = "";

  Map<String, dynamic> _activeFilter = {};

  @override
  void initState() {
    super.initState();
    _loadTagihan();
  }

  Future<void> _loadTagihan() async {
    setState(() => _loading = true);
    final tagihanList = await _controller.fetchAll();
    setState(() {
      dataTagihan = tagihanList;
      _loading = false;
    });
  }

  void _generatePdf() async {
    final filteredList = dataTagihan.where((item) {
      if (search.isNotEmpty &&
          !item.keluarga.toLowerCase().contains(search.toLowerCase())) {
        return false;
      }
      if (_activeFilter.isNotEmpty) {
        if (_activeFilter['periode'] != null &&
            !item.periode.contains(_activeFilter['periode'])) {
          return false;
        }
      }
      return true;
    }).toList();

    if (filteredList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada data tagihan untuk dicetak')),
      );
      return;
    }

    try {
      final pdf = pw.Document();

      final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
      final ttf = pw.Font.ttf(fontData);

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          build: (pw.Context context) => [
            pw.Text(
              "Laporan Data Tagihan",
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                font: ttf,
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
                'No',
                'Nama KK',
                'Periode',
                'Nominal',
                'Status Tagihan',
              ],
              data: List.generate(filteredList.length, (i) {
                final tagihan = filteredList[i];
                return [
                  (i + 1).toString(),
                  tagihan.keluarga,
                  tagihan.periode,
                  tagihan.nominal,
                  tagihan.tagihanStatus,
                ];
              }),
            ),
          ],
        ),
      );

      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
      );
    } on MissingPluginException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Fitur cetak PDF belum tersedia di platform ini.\n'
            'Coba jalankan di emulator/device Android atau iOS.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mencetak PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = dataTagihan.where((item) {
      if (search.isNotEmpty &&
          !item.keluarga.toLowerCase().contains(search.toLowerCase())) {
        return false;
      }
      if (_activeFilter.isNotEmpty) {
        if (_activeFilter['periode'] != null &&
            !item.periode.contains(_activeFilter['periode'])) {
          return false;
        }
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      drawer: const AppSidebar(),

      // ✅ RAPINYA DI SINI: 2 FAB (PDF + Tagih Iuran) seperti DaftarWargaPage
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'printTagihan',
            backgroundColor: Colors.red,
            elevation: 4,
            onPressed: _generatePdf,
            child: const Icon(
              Icons.picture_as_pdf,
              size: 26,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'tagihIuran',
            backgroundColor: const Color(0xFF0C88C2),
            elevation: 4,
            onPressed: () {
              Navigator.pushNamed(context, '/pemasukan/tagihIuran');
            },
            child: const Icon(
              Icons.add_task, // boleh ganti Icons.payment / Icons.receipt_long
              size: 26,
              color: Colors.white,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainHeader(
              title: "Tagihan",
              searchHint: "Cari tagihan...",
              showSearchBar: true,
              showFilterButton: true,
              onSearch: (v) => setState(() => search = v.trim()),
              onFilter: () => showDialog(
                context: context,
                builder: (_) => const FilterTagihanDialog(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredList.isEmpty
                      ? const Center(child: Text("Belum ada tagihan"))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final row = filteredList[index];
                            return TagihanCard(
                              data: row,
                              onDetail: () {
                                showDialog(
                                  context: context,
                                  builder: (_) =>
                                      DetailTagihanDialog(tagihan: row),
                                );
                              },
                              onEdit: () async {
                                final updatedTagihan =
                                    await showDialog<TagihanModel>(
                                  context: context,
                                  builder: (_) =>
                                      EditTagihanDialog(tagihan: row),
                                );
                                if (updatedTagihan != null) {
                                  await _controller.updateTagihan(
                                    updatedTagihan.id,
                                    updatedTagihan.toMap(),
                                  );
                                  setState(() {
                                    final idx = dataTagihan.indexWhere(
                                        (item) => item.id == updatedTagihan.id);
                                    if (idx != -1) {
                                      dataTagihan[idx] = updatedTagihan;
                                    }
                                  });
                                }
                              },
                              onDelete: () {
                                _controller.deleteTagihan(row.id);
                                setState(() {
                                  dataTagihan.removeAt(index);
                                });
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
