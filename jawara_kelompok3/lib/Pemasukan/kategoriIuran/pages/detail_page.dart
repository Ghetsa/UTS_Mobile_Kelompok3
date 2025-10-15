import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../../Layout/sidebar.dart';
import '../../../theme/app_theme.dart'; // pastikan path sesuai lokasi AppTheme

class DetailKategoriPage extends StatelessWidget {
  const DetailKategoriPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Kategori Iuran"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const AppSidebar(),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Halaman detail / filter kategori iuran",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
