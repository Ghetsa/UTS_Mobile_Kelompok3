import 'package:flutter/material.dart';

class MainHeader extends StatelessWidget {
  final String title;
  final String? searchHint;
  final ValueChanged<String>? onSearch;
  final VoidCallback? onFilter;

  final bool showSearchBar;     // ⬅️ Baru
  final bool showFilterButton;  // ⬅️ Baru

  const MainHeader({
    super.key,
    required this.title,
    this.searchHint,
    this.onSearch,
    this.onFilter,
    this.showSearchBar = false,
    this.showFilterButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF48B0E0), Color(0xFF0C88C2)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ------------------------------------------------------
          /// 🔵 Row: Sidebar Button + Title
          /// ------------------------------------------------------
          Row(
            children: [
              Builder(
                builder: (ctx) => GestureDetector(
                  onTap: () => Scaffold.of(ctx).openDrawer(),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.25),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.menu_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          /// Bila search dan filter tidak digunakan → jangan tampilkan spacing kosong
          if (showSearchBar || showFilterButton) const SizedBox(height: 16),

          /// ------------------------------------------------------
          /// 🔍 Search Bar + Filter Button (Opsional)
          /// ------------------------------------------------------
          if (showSearchBar || showFilterButton)
            Row(
              children: [
                /// SEARCH BAR
                if (showSearchBar)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.2),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        onChanged: onSearch,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          icon: const Icon(Icons.search, color: Colors.white),
                          border: InputBorder.none,
                          hintText: searchHint ?? "Cari...",
                          hintStyle:
                              const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  ),

                if (showSearchBar) const SizedBox(width: 12),

                /// FILTER BUTTON
                if (showFilterButton)
                  GestureDetector(
                    onTap: onFilter,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.25),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.filter_alt_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
