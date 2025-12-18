import 'package:flutter/material.dart';
import '../../../../data/models/pemasukan_lain_model.dart';
import '../../../../data/services/pemasukan_lain_service.dart';
import '../../../../../../core/layout/header.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../widgets/card/pemasukan_lain_card.dart';
import '../../../widgets/dialog/detail_pemasukan_lain_dialog.dart';
import '../../../widgets/filter/pemasukan_filter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';

class PemasukanLainDaftarPage extends StatefulWidget {
  const PemasukanLainDaftarPage({super.key});

  @override
  _PemasukanLainDaftarPageState createState() =>
      _PemasukanLainDaftarPageState();
}

class _PemasukanLainDaftarPageState extends State<PemasukanLainDaftarPage> {
  List<PemasukanLainModel> pemasukan = [];
  bool _loading = true;
  String search = "";

  Map<String, dynamic> _activeFilter = {};
  final PemasukanLainService _service = PemasukanLainService();

  @override
  void initState() {
    super.initState();
    _fetchPemasukanData();
  }

  Future<void> _fetchPemasukanData() async {
    setState(() => _loading = true);
    try {
      final data = await _service.getAll();
      setState(() {
        pemasukan = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      // ignore: avoid_print
      print("Error fetching pemasukan data: $e");
    }
  }

  void _deleteData(String id) async {
    final success = await _service.delete(id);
    if (success) {
      setState(() {
        pemasukan.removeWhere((item) => item.id == id);
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data berhasil dihapus")),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menghapus data")),
      );
    }
  }

  void _generatePdf() async {
    final filteredList = pemasukan.where((item) {
      if (search.isNotEmpty &&
          !item.nama.toLowerCase().contains(search.toLowerCase())) {
        return false;
      }
      if (_activeFilter.isNotEmpty) {
        if (_activeFilter['jenis'] != null &&
            !item.jenis.contains(_activeFilter['jenis'])) {
          return false;
        }
      }
      return true;
    }).toList();

    if (filteredList.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada data untuk dicetak')),
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
              "Laporan Data Pemasukan Lain",
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
              headers: const ['No', 'Nama', 'Jenis', 'Tanggal', 'Nominal'],
              data: List.generate(filteredList.length, (i) {
                final item = filteredList[i];
                return [
                  (i + 1).toString(),
                  item.nama,
                  item.jenis,
                  item.tanggal,
                  item.nominal,
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
    final filteredList = pemasukan.where((item) {
      if (search.isNotEmpty &&
          !item.nama.toLowerCase().contains(search.toLowerCase())) {
        return false;
      }
      if (_activeFilter.isNotEmpty) {
        if (_activeFilter['jenis'] != null &&
            !item.jenis.contains(_activeFilter['jenis'])) {
          return false;
        }
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      drawer: const AppSidebar(),

      // ✅ biar dua FAB tetap nempel kanan bawah
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'printPemasukan',
            backgroundColor: AppTheme.redDark,
            elevation: 4,
            onPressed: _generatePdf,
            child:
                const Icon(Icons.picture_as_pdf, size: 26, color: Colors.white),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'addPemasukan',
            backgroundColor: const Color(0xFF0C88C2),
            elevation: 4,
            onPressed: () {
              Navigator.pushNamed(context, '/pemasukan/pemasukanLain-tambah');
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
              title: "Daftar Pemasukan",
              searchHint: "Cari pemasukan lain...",
              showSearchBar: true,
              showFilterButton: true,
              onSearch: (v) => setState(() => search = v.trim()),
              onFilter: () => showDialog(
                context: context,
                builder: (_) => FilterPemasukanDialog(
                  onApply: (filter) {
                    setState(() => _activeFilter = filter);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredList.isEmpty
                      ? const Center(child: Text("Belum ada data"))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final item = filteredList[index];
                            return PemasukanCard(
                              data: item,
                              onDetail: () {
                                final dataMap = {
                                  'id': item.id,
                                  'nama': item.nama,
                                  'jenis': item.jenis,
                                  'tanggal': item.tanggal,
                                  'nominal': item.nominal,
                                };
                                showDialog(
                                  context: context,
                                  barrierColor: Colors.black.withOpacity(0.5),
                                  builder: (_) =>
                                      DetailPemasukanDialog(pemasukan: dataMap),
                                );
                              },
                              onDelete: () => _deleteData(item.id),
                            );
                          },
                        ),
            ),

            // ✅ tombol kembali DIHAPUS
          ],
        ),
      ),
    );
  }
}
