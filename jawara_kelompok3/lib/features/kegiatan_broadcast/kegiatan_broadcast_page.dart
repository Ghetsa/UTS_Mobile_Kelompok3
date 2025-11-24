import 'package:flutter/material.dart';
import '../../main.dart';
import '../../core/layout/sidebar.dart';

class KegiatanBroadcastPage extends StatelessWidget {
  const KegiatanBroadcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kegiatan & Broadcast")),
      drawer: const AppSidebar(),
      body: const Center(
        child: Text("Halaman Kegiatan & Broadcast (isi nanti)"),
      ),
    );
  }
}
