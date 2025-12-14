import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SidebarWarga extends StatefulWidget {
  const SidebarWarga({super.key});

  @override
  State<SidebarWarga> createState() => _SidebarWargaState();
}

class _SidebarWargaState extends State<SidebarWarga> {
  final Map<String, bool> _expanded = {};
  String? _lastRoute;

  final Duration _animationDuration = const Duration(milliseconds: 280);
  bool _isAnimating = false;

  static const _green = Color(0xFF2F6B4F);
  static const _brown = Color(0xFF7A5C3E);

  final Gradient mainGradient = const LinearGradient(
    colors: [_green, _brown],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  void initState() {
    super.initState();
    _expanded.addAll({
      'warga_menu': true, // default kebuka biar gampang
    });
  }

  bool _routeMatches(String menuKey, String route) {
    if (route.isEmpty) return false;

    switch (menuKey) {
      case 'warga_menu':
        return route.startsWith('/warga/dashboard') ||
            route.startsWith('/warga/');
      default:
        return false;
    }
  }

  void _ensureInitialExpansion(String currentRoute) {
    if (_lastRoute == currentRoute) return;
    _lastRoute = currentRoute;

    _expanded.forEach((k, _) {
      _expanded[k] = _routeMatches(k, currentRoute);
    });

    // kalau tidak match apa pun, tetep buka menu warga (biar UX enak)
    _expanded['warga_menu'] ??= true;
  }

  void _expandOnlyAnimated(String key, bool expanded) {
    if (_isAnimating) return;

    _isAnimating = true;
    setState(() {
      _expanded[key] = expanded;
    });

    Future.delayed(_animationDuration, () {
      _isAnimating = false;
    });
  }

  Widget _buildSubMenuItem(
    String label,
    String route,
    BuildContext context,
    String currentRoute, {
    IconData? leadingIcon,
  }) {
    final bool selected = currentRoute == route;

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        if (selected) return;
        Navigator.pushReplacementNamed(context, route);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE3EFE8) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              leadingIcon ?? Icons.circle,
              size: leadingIcon == null ? 8 : 18,
              color: selected ? _green : Colors.grey.shade500,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  color: selected ? _green : _brown,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection({
    required IconData icon,
    required String title,
    required String keyValue,
    required BuildContext context,
    required String currentRoute,
    required List<Widget> children,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        key: ValueKey('${keyValue}_${_expanded[keyValue]}'),
        initiallyExpanded: _expanded[keyValue] ?? false,
        onExpansionChanged: (expanded) =>
            _expandOnlyAnimated(keyValue, expanded),
        leading: ShaderMask(
          shaderCallback: (bounds) => mainGradient.createShader(bounds),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _green,
          ),
        ),
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';
    _ensureInitialExpansion(currentRoute);

    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? '-';

    // Nama bisa diambil dari displayName (kalau belum ada, fallback "Warga")
    final nama = (user?.displayName?.trim().isNotEmpty ?? false)
        ? user!.displayName!.trim()
        : "Warga";

    return Drawer(
      child: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            decoration: BoxDecoration(gradient: mainGradient),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.26),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(.18)),
                  ),
                  child:
                      const Icon(Icons.person, size: 34, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  nama,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  email,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          // BODY
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildMenuSection(
                    icon: Icons.home_rounded,
                    title: "Menu Warga",
                    keyValue: "warga_menu",
                    context: context,
                    currentRoute: currentRoute,
                    children: [
                      _buildSubMenuItem(
                        "Dashboard",
                        "/warga/dashboard",
                        context,
                        currentRoute,
                        leadingIcon: Icons.dashboard_outlined,
                      ),
                      _buildSubMenuItem(
                        "Kegiatan Warga",
                        "/warga/kegiatan",
                        context,
                        currentRoute,
                        leadingIcon: Icons.event_note_outlined,
                      ),
                      _buildSubMenuItem(
                        "Informasi & Aspirasi",
                        "/warga/aspirasi",
                        context,
                        currentRoute,
                        leadingIcon: Icons.chat_outlined,
                      ),
                      _buildSubMenuItem(
                        "Profil Saya",
                        "/warga/profil",
                        context,
                        currentRoute,
                        leadingIcon: Icons.account_circle_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading:
                        const Icon(Icons.logout_rounded, color: Colors.red),
                    title: const Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('logged_out', true);
                      await FirebaseAuth.instance.signOut();

                      if (!context.mounted) return;
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
