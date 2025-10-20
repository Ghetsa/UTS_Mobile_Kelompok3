import 'package:flutter/material.dart';
import '../../Layout/sidebar.dart';
import '../../Theme/app_theme.dart';

class DetailChannelPage extends StatelessWidget {
  final Map<String, String> channel;

  const DetailChannelPage({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppSidebar(),
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        elevation: 2,
        title: const Text(
          'Detail Channel Transfer',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header dan Gambar
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          channel['thumbnail'] ?? 'assets/images/default.jpg',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Center(
                      child: Text(
                        channel['nama'] ?? '-',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                    const Divider(height: 30, thickness: 1),

                    // Detail Informasi Channel
                    _buildDetailItem('Nomor', channel['no']),
                    _buildDetailItem('Tipe Channel', channel['tipe']),
                    _buildDetailItem('Atas Nama', channel['a/n']),
                    const SizedBox(height: 20),

                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Kembali'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value ?? '-',
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
