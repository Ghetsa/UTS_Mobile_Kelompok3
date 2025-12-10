import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart'; 
import '../../../../../../core/layout/header.dart'; 
import '../../../../../../core/layout/sidebar.dart'; 
import '../../widgets/card/navigation_card.dart'; 

class PemasukanPage extends StatelessWidget {
  const PemasukanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      drawer: const AppSidebar(), 
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Header
            MainHeader(
              title: "Pemasukan", 
              showSearchBar: false, 
              showFilterButton: false, 
            ),
            const SizedBox(height: 18),

            const SizedBox(height: 20),

            _buildNavigationCard(context, "Kategori Iuran", "/pemasukan/pages/kategori"),
            _buildNavigationCard(context, "Tagihan", "/pemasukan/tagihan"),
            _buildNavigationCard(context, "Pemasukan", "/pemasukan/pemasukanLain-daftar"),

          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCard(BuildContext context, String title, String route) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.navigate_next, color: AppTheme.primaryBlue, size: 30),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}
