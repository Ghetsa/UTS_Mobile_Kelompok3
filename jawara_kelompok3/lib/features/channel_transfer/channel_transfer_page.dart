import 'package:flutter/material.dart';
import '../../main.dart';
import '../../core/layout/sidebar.dart';

class ChannelTransferPage extends StatelessWidget {
  const ChannelTransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Channel Transfer")),
      drawer: const AppSidebar(),
      body: const Center(
        child: Text("Halaman Channel Transfer (isi nanti)"),
      ),
    );
  }
}
