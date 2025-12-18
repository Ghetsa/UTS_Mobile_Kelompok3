import 'package:flutter/material.dart';
import '../../../../core/layout/header.dart';
import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';

class DetailChannelPage extends StatelessWidget {
  final Map<String, dynamic> channel;

  const DetailChannelPage({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F2F9),
      drawer: const AppSidebar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainHeader(
              title: "Detail Channel",
              showSearchBar: false,
              showFilterButton: false,
              onSearch: (_) {},
              onFilter: () {},
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Detail Channel Transfer",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Color(0xFF48B0E0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildReadOnlyField("Nama Channel",
                            channel['nama_channel']?.toString() ?? "-"),
                        _buildReadOnlyField(
                            "Tipe Channel", channel['tipe']?.toString() ?? "-"),
                        _buildReadOnlyField("Nomor Rekening / Akun",
                            channel['no_rekening']?.toString() ?? "-"),
                        _buildReadOnlyField("Nama Pemilik",
                            channel['nama_pemilik']?.toString() ?? "-"),
                        _buildReadOnlyField(
                            "Catatan", channel['catatan']?.toString() ?? "-"),
                        const SizedBox(height: 24),
                        const Text(
                          "Thumbnail Channel:",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        _imageBox(channel['thumbnail_url']?.toString()),
                        const SizedBox(height: 24),
                        const Text(
                          "QR Code:",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        _imageBox(channel['qr_url']?.toString()),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF48B0E0),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            child: const Text(
                              "Kembali",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white, width: 2)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ]),
    );
  }

  Widget _imageBox(String? path) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          height: 250,
          color: Colors.grey.shade200,
          child: path == null || path.isEmpty
              ? const Center(child: Text("Tidak ada gambar"))
              : Image.network(
                  path,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Text("Gagal memuat gambar")),
                ),
        ),
      ),
    );
  }
}
