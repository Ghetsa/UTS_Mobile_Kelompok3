import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/layout/header_warga.dart';
import '../../../../core/layout/sidebar_warga.dart';

class WargaProfilePage extends StatefulWidget {
  const WargaProfilePage({super.key});

  @override
  State<WargaProfilePage> createState() => _WargaProfilePageState();
}

class _WargaProfilePageState extends State<WargaProfilePage> {
  // Theme warga (samakan dengan UI kamu)
  static const Color _green = Color(0xFF2F6F4E);
  static const Color _brown = Color(0xFF8B6B3E);
  static const Color _bg = Color(0xFFF4F7F3);

  bool _loading = true;
  bool _saving = false;

  // auth data
  String _uid = "";
  String _role = "warga";

  // warga data (read-only)
  String _nama = "-";
  String _nik = "-";
  String _noHp = "-";
  String _jenisKelamin = "-";
  String _statusWarga = "-";
  String _agama = "-";
  String _pendidikan = "-";
  String _pekerjaan = "-";
  String _alamatWarga = "-";

  // rumah data (read-only)
  String _rumahLabel = "-";
  String _rumahDocId = "";

  // editable (email & password)
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _currentPasswordC = TextEditingController();
  final TextEditingController _newPasswordC = TextEditingController();
  final TextEditingController _confirmNewPasswordC = TextEditingController();

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  @override
  void initState() {
    super.initState();
    _loadProfileFromWarga();
  }

  // ---------- Helpers ----------
  String _s(dynamic v, [String fallback = ""]) {
    if (v == null) return fallback;
    final t = v.toString().trim();
    return t.isEmpty ? fallback : t;
  }

  String _pick(Map<String, dynamic> data, List<String> keys,
      [String fallback = "-"]) {
    for (final k in keys) {
      if (data.containsKey(k) && data[k] != null) {
        final val = data[k].toString().trim();
        if (val.isNotEmpty) return val;
      }
    }
    return fallback;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> _getWargaDoc(
      String uid) async {
    final wargaCol = FirebaseFirestore.instance.collection('warga');

    // 1) docId = uid (paling umum karena register kamu .doc(uid))
    final direct = await wargaCol.doc(uid).get();
    if (direct.exists) return direct;

    // 2) query by user_id
    final q1 = await wargaCol.where('user_id', isEqualTo: uid).limit(1).get();
    if (q1.docs.isNotEmpty) return q1.docs.first;

    // 3) query by uid
    final q2 = await wargaCol.where('uid', isEqualTo: uid).limit(1).get();
    if (q2.docs.isNotEmpty) return q2.docs.first;

    return null;
  }

  Future<void> _loadRumah(String rumahDocId) async {
    try {
      final rdoc = await FirebaseFirestore.instance
          .collection('rumah')
          .doc(rumahDocId)
          .get();
      if (!rdoc.exists) return;

      final r = rdoc.data() ?? {};
      final nomor = _pick(r, ['nomor', 'no', 'no_rumah', 'nomer'], '');
      final alamat = _pick(r, ['alamat', 'address', 'lokasi'], '');

      final label = [
        if (nomor.isNotEmpty) "No. $nomor",
        if (alamat.isNotEmpty) alamat,
      ].join(" • ");

      if (!mounted) return;
      setState(() {
        _rumahLabel = label.isEmpty ? "-" : label;
      });
    } catch (_) {
      // ignore
    }
  }

  // ---------- Load ----------
  Future<void> _loadProfileFromWarga() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _loading = false);
      return;
    }

    _uid = user.uid;
    _emailC.text = user.email ?? "";

    // role dari users/{uid}
    try {
      final udoc =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      final u = udoc.data() ?? {};
      _role = _s(u['role'], 'warga');
    } catch (_) {
      _role = 'warga';
    }

    // warga
    try {
      final wargaDoc = await _getWargaDoc(_uid);
      if (wargaDoc == null || !wargaDoc.exists) {
        if (!mounted) return;
        setState(() => _loading = false);
        return;
      }

      final w = wargaDoc.data() ?? {};

      final nama = _pick(w, ['nama', 'name'], '-');
      final nik = _pick(w, ['nik'], '-');
      final noHp = _pick(w, ['no_hp', 'noHp', 'phone'], '-');
      final jk = _pick(w, ['jenis_kelamin', 'jenisKelamin', 'gender'], '-');
      final statusWarga = _pick(w, ['status_warga', 'statusWarga'], '-');
      final agama = _pick(w, ['agama'], '-');
      final pendidikan = _pick(w, ['pendidikan'], '-');
      final pekerjaan = _pick(w, ['pekerjaan'], '-');
      final alamatWarga = _pick(w, ['alamat', 'address'], '-');

      final rumahDocId = _pick(w, ['id_rumah', 'idRumah', 'rumah_doc_id'], '');

      if (!mounted) return;
      setState(() {
        _nama = nama;
        _nik = nik;
        _noHp = noHp;
        _jenisKelamin = jk;
        _statusWarga = statusWarga;
        _agama = agama;
        _pendidikan = pendidikan;
        _pekerjaan = pekerjaan;
        _alamatWarga = alamatWarga;

        _rumahDocId = rumahDocId;
        _rumahLabel = "-";
      });

      if (_rumahDocId.isNotEmpty) {
        await _loadRumah(_rumahDocId);
      }
    } catch (_) {
      // ignore
    }

    if (!mounted) return;
    setState(() => _loading = false);
  }

  // ---------- Update Auth ----------
  Future<void> _updateEmailAndPassword() async {
    if (_saving) return;

    final newEmail = _emailC.text.trim();
    final currentPw = _currentPasswordC.text.trim();
    final newPw = _newPasswordC.text.trim();
    final confirmPw = _confirmNewPasswordC.text.trim();

    if (newEmail.isEmpty || !newEmail.contains('@')) {
      _snack("Email tidak valid.", isError: true);
      return;
    }

    // current password wajib supaya reauth
    if (currentPw.isEmpty) {
      _snack("Isi Password Saat Ini untuk menyimpan perubahan.", isError: true);
      return;
    }

    // password baru opsional, tapi kalau diisi wajib match confirm
    if (newPw.isNotEmpty || confirmPw.isNotEmpty) {
      if (newPw.length < 8) {
        _snack("Password baru minimal 8 karakter.", isError: true);
        return;
      }
      if (newPw != confirmPw) {
        _snack("Password baru & konfirmasi tidak cocok.", isError: true);
        return;
      }
    }

    setState(() => _saving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User belum login.");

      // ✅ REAUTH
      final cred = EmailAuthProvider.credential(
        email: user.email ?? "",
        password: currentPw,
      );
      await user.reauthenticateWithCredential(cred);

      // ✅ UPDATE EMAIL (verify before update)
      if (newEmail != (user.email ?? "")) {
        await user.verifyBeforeUpdateEmail(newEmail);

        // simpan pending dulu biar tidak mismatch
        await FirebaseFirestore.instance.collection('users').doc(_uid).set({
          'pending_email': newEmail,
          'updated_at': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        _snack(
          "Link verifikasi sudah dikirim ke email baru.\n"
          "Buka email itu untuk menyelesaikan perubahan.",
        );
      }

      // ✅ UPDATE PASSWORD (optional)
      if (newPw.isNotEmpty) {
        await user.updatePassword(newPw);
        _snack("✅ Password berhasil diubah.");
      }

      // clear fields
      _currentPasswordC.clear();
      _newPasswordC.clear();
      _confirmNewPasswordC.clear();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        _snack("Password saat ini salah.", isError: true);
      } else if (e.code == 'requires-recent-login') {
        _snack("Perlu login ulang untuk mengubah email/password.",
            isError: true);
      } else if (e.code == 'email-already-in-use') {
        _snack("Email sudah digunakan akun lain.", isError: true);
      } else if (e.code == 'invalid-email') {
        _snack("Format email tidak valid.", isError: true);
      } else {
        _snack("Gagal: ${e.message ?? e.code}", isError: true);
      }
    } catch (e) {
      _snack("Gagal: $e", isError: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged_out', true);
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void _snack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : _green,
      ),
    );
  }

  InputDecoration _roDec(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: _green.withOpacity(0.10)),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: _green.withOpacity(0.10)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  InputDecoration _editDec(String label, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: _green.withOpacity(0.18)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _green, width: 1.6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      suffixIcon: suffix,
    );
  }

  @override
  void dispose() {
    _emailC.dispose();
    _currentPasswordC.dispose();
    _newPasswordC.dispose();
    _confirmNewPasswordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      drawer: const SidebarWarga(),
      body: SafeArea(
        child: Column(
          children: [
            const MainHeaderWarga(
              title: "Profil Warga",
              showSearchBar: false,
              showFilterButton: false,
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _ProfileHeader(
                            green: _green,
                            brown: _brown,
                            nama: _nama == "-" || _nama.trim().isEmpty
                                ? "Warga"
                                : _nama,
                            email: _emailC.text.trim().isEmpty
                                ? "-"
                                : _emailC.text.trim(),
                            role: _role,
                          ),
                          const SizedBox(height: 14),

                          // ===== READ ONLY: DATA WARGA & RUMAH =====
                          _SectionCard(
                            green: _green,
                            title: "Data Warga (Read-only)",
                            child: Column(
                              children: [
                                TextFormField(
                                  initialValue: _nama,
                                  enabled: false,
                                  decoration: _roDec("Nama"),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  initialValue: _nik,
                                  enabled: false,
                                  decoration: _roDec("NIK"),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  initialValue: _noHp,
                                  enabled: false,
                                  decoration: _roDec("No HP"),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  initialValue: _jenisKelamin,
                                  enabled: false,
                                  decoration: _roDec("Jenis Kelamin"),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  initialValue: _statusWarga,
                                  enabled: false,
                                  decoration: _roDec("Status Warga"),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  initialValue: _agama,
                                  enabled: false,
                                  decoration: _roDec("Agama"),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  initialValue: _pendidikan,
                                  enabled: false,
                                  decoration: _roDec("Pendidikan"),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  initialValue: _pekerjaan,
                                  enabled: false,
                                  decoration: _roDec("Pekerjaan"),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  initialValue: _alamatWarga,
                                  enabled: false,
                                  decoration: _roDec("Alamat (dari warga)"),
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  initialValue: _rumahLabel,
                                  enabled: false,
                                  decoration:
                                      _roDec("Alamat Rumah (dari rumah)"),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          // ===== EDITABLE: EMAIL & PASSWORD =====
                          _SectionCard(
                            green: _green,
                            title: "Ubah Akun (Email & Password)",
                            child: Column(
                              children: [
                                TextField(
                                  controller: _emailC,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: _editDec("Email"),
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _currentPasswordC,
                                  obscureText: !_showCurrent,
                                  decoration: _editDec(
                                    "Password Saat Ini (wajib)",
                                    suffix: IconButton(
                                      onPressed: () => setState(
                                          () => _showCurrent = !_showCurrent),
                                      icon: Icon(_showCurrent
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _newPasswordC,
                                  obscureText: !_showNew,
                                  decoration: _editDec(
                                    "Password Baru (opsional)",
                                    suffix: IconButton(
                                      onPressed: () =>
                                          setState(() => _showNew = !_showNew),
                                      icon: Icon(_showNew
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _confirmNewPasswordC,
                                  obscureText: !_showConfirm,
                                  decoration: _editDec(
                                    "Konfirmasi Password Baru",
                                    suffix: IconButton(
                                      onPressed: () => setState(
                                          () => _showConfirm = !_showConfirm),
                                      icon: Icon(_showConfirm
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: _brown.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                        color: _brown.withOpacity(0.18)),
                                  ),
                                  child: Text(
                                    "Catatan: Ubah email memakai verifikasi (Firebase). "
                                    "Setelah klik link verifikasi di email baru, biasanya user perlu login ulang.",
                                    style: TextStyle(
                                        color: Colors.grey.shade800,
                                        height: 1.25),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  onPressed:
                                      _saving ? null : _updateEmailAndPassword,
                                  icon: _saving
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white),
                                        )
                                      : const Icon(Icons.save),
                                  label:
                                      Text(_saving ? "Menyimpan..." : "Simpan"),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: _brown,
                                    side: BorderSide(
                                        color: _brown.withOpacity(0.5)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  onPressed: _logout,
                                  icon: const Icon(Icons.logout),
                                  label: const Text("Logout"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final Color green;
  final Color brown;
  final String nama;
  final String email;
  final String role;

  const _ProfileHeader({
    required this.green,
    required this.brown,
    required this.nama,
    required this.email,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: green.withOpacity(0.10)),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [green.withOpacity(0.85), brown.withOpacity(0.85)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w900, color: green),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(color: Colors.grey.shade700),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: brown.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: brown.withOpacity(0.25)),
                  ),
                  child: Text(
                    "ROLE: ${role.toUpperCase()}",
                    style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: brown),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Color green;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.green,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: green.withOpacity(0.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: green, fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
