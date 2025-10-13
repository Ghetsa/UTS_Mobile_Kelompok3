import 'package:flutter/material.dart';
import '../main.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      drawer: const AppSidebar(),
      body: const Center(
        child: Text("Halaman Dashboard (isi nanti)"),
      ),
    );
  }
}
