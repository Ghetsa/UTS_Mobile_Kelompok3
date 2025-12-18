import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SidebarWarga extends StatefulWidget {
  const SidebarWarga({super.key});

  @override
  State<SidebarWarga> createState() => _SidebarWargaState();
}

class _SidebarWargaState extends State<SidebarWarga> {
  static const _green = Color(0xFF2F6B4F);
  static const _brown = Color(0xFF7A5C3E);

  final Gradient mainGradient = const LinearGradient(
    colors: [_green, _brown],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';

    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? '-';

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
                  _buildMenuItem(
                    title: "Dashboard",
                    route: "/warga/dashboard",
                    currentRoute: currentRoute,
                    icon: Icons.dashboard_outlined,
                  ),
                  _buildMenuItem(
                    title: "Kegiatan Warga",
                    route: "/warga/kegiatan",
                    currentRoute: currentRoute,
                    icon: Icons.event_note_outlined,
                  ),
                  _buildMenuItem(
                    title: "Informasi & Aspirasi",
                    route: "/warga/aspirasi",
                    currentRoute: currentRoute,
                    icon: Icons.chat_outlined,
                  ),
                  _buildMenuItem(
                    title: "Profil Saya",
                    route: "/warga/profil",
                    currentRoute: currentRoute,
                    icon: Icons.account_circle_outlined,
                  ),
                  _buildMenuItem(
                    title: "Tagihan",
                    route: "/warga/tagihan",
                    currentRoute: currentRoute,
                    icon: Icons.receipt_long_outlined,
                  ),
                  _buildLogoutItem(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutItem(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE), // merah muda lembut
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.logout_rounded,
          color: Colors.red,
        ),
        title: const Text(
          "Logout",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.red,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Colors.redAccent,
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
    );
  }

  Widget _buildMenuItem({
    required String title,
    required String route,
    required String currentRoute,
    required IconData icon,
  }) {
    final selected = currentRoute == route;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFE3EFE8) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: selected ? _green : Colors.grey.shade600,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            color: selected ? _green : _brown,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: selected ? _green : Colors.grey.shade400,
        ),
        onTap: () {
          Navigator.pop(context);
          if (selected) return;
          Navigator.pushReplacementNamed(context, route);
        },
      ),
    );
  }
}
