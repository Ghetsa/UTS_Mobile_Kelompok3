import 'package:flutter/material.dart';
import '../../../../data/models/pemasukan_lain_model.dart';
import '../../../../data/services/pemasukan_lain_service.dart';
import '../../../../../../core/layout/header.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../widgets/card/pemasukan_lain_card.dart'; 
import '../../../widgets/dialog/detail_pemasukan_lain_dialog.dart';  
import '../../../widgets/dialog/edit_pemasukan_lain_dialog.dart';  
import '../../../widgets/filter/pemasukan_filter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';

class PemasukanLainDaftarPage extends StatefulWidget {
  const PemasukanLainDaftarPage({super.key});

  @override
  _PemasukanLainDaftarPageState createState() => _PemasukanLainDaftarPageState();
}

class _PemasukanLainDaftarPageState extends State<PemasukanLainDaftarPage> {
  List<PemasukanLainModel> pemasukan = [];
  bool _loading = true;
  String search = "";  // Define search variable

  // Filter variables
  Map<String, dynamic> _activeFilter = {};

  final PemasukanLainService _service = PemasukanLainService();

  @override
  void initState() {
    super.initState();
    _fetchPemasukanData();
  }

  Future<void> _fetchPemasukanData() async {
    setState(() {
      _loading = true;
    });

    try {
      final data = await _service.getAll();
      setState(() {
        pemasukan = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print("Error fetching pemasukan data: $e");
    }
  }

  void _deleteData(String id) async {
    final success = await _service.delete(id); // Directly calling delete from the service
    if (success) {
      setState(() {
        pemasukan.removeWhere((item) => item.id == id);  // Remove item from the list
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data berhasil dihapus")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal menghapus data")));
    }
  }

  // Function to generate PDF
  void _generatePdf() async {
    if (pemasukan.isEmpty) {
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

            // Table for pemasukan data
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
                'Nama',
                'Jenis',
                'Tanggal',
                'Nominal',
              ],
              data: List.generate(pemasukan.length, (i) {
                final item = pemasukan[i];
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mencetak PDF: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter data based on search term and active filter
    final filteredList = pemasukan.where((item) {
      if (search.isNotEmpty &&
          !item.nama.toLowerCase().contains(search.toLowerCase())) {
        return false;
      }
      // Apply active filter logic (if any)
      if (_activeFilter.isNotEmpty) {
        if (_activeFilter['jenis'] != null &&
            !item.jenis.contains(_activeFilter['jenis'])) {
          return false;
        }
        // Add other filters as needed
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      drawer: const AppSidebar(),
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
                    setState(() {
                      _activeFilter = filter;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 18),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: _generatePdf,
                icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                label: const Text("Cetak PDF"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.redDark,
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
                                  'nominal': item.nominal
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

            // Back Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/pemasukan');
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    label: const Text("Kembali", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/pemasukan/pemasukanLain-tambah');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Tambah Pemasukan", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
