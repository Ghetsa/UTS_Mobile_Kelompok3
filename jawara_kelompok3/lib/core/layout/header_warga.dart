import 'package:flutter/material.dart';

class MainHeaderWarga extends StatelessWidget {
  final String title;
  final String? subtitle;

  final String? searchHint;
  final ValueChanged<String>? onSearch;
  final VoidCallback? onFilter;

  final bool showSearchBar;
  final bool showFilterButton;

  const MainHeaderWarga({
    super.key,
    required this.title,
    this.subtitle,
    this.searchHint,
    this.onSearch,
    this.onFilter,
    this.showSearchBar = false,
    this.showFilterButton = false,
  });

  static const _green = Color(0xFF2F6B4F);
  static const _brown = Color(0xFF7A5C3E);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(47, 107, 79, 1),
            Color.fromRGBO(47, 107, 79, 1)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // row: menu + title
          Row(
            children: [
              Builder(
                builder: (ctx) => GestureDetector(
                  onTap: () => Scaffold.of(ctx).openDrawer(),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.22),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withOpacity(.18),
                      ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(.85),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          if (showSearchBar || showFilterButton) const SizedBox(height: 14),

          if (showSearchBar || showFilterButton)
            Row(
              children: [
                if (showSearchBar)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.16),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: Colors.white.withOpacity(.16),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        onChanged: onSearch,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          icon: const Icon(Icons.search, color: Colors.white),
                          border: InputBorder.none,
                          hintText: searchHint ?? "Cari...",
                          hintStyle: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  ),
                if (showSearchBar) const SizedBox(width: 12),
                if (showFilterButton)
                  GestureDetector(
                    onTap: onFilter,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.22),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withOpacity(.18),
                        ),
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
