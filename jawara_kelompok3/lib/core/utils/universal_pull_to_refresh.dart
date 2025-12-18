// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'route_tracker.dart';

// class UniversalPullToRefresh extends StatefulWidget {
//   const UniversalPullToRefresh({
//     super.key,
//     required this.child,
//     required this.navigatorKey,
//     required this.routeTracker,
//     this.topEdgePx = 92, // tinggi header (posisi indikator)
//     this.triggerDistance = 110, // jarak pull untuk refresh
//     this.maxPull = 140, // batas visual pull
//   });

//   final Widget child;
//   final GlobalKey<NavigatorState> navigatorKey;
//   final RouteTracker routeTracker;

//   final double topEdgePx;
//   final double triggerDistance;
//   final double maxPull;

//   @override
//   State<UniversalPullToRefresh> createState() => _UniversalPullToRefreshState();
// }

// class _UniversalPullToRefreshState extends State<UniversalPullToRefresh>
//     with SingleTickerProviderStateMixin {
//   double _pull = 0;
//   bool _refreshing = false;

//   late final AnimationController _spinC;

//   @override
//   void initState() {
//     super.initState();
//     _spinC = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     );
//   }

//   @override
//   void dispose() {
//     _spinC.dispose();
//     super.dispose();
//   }

//   Future<void> _refreshCurrentRoute() async {
//     if (_refreshing) return;

//     setState(() => _refreshing = true);
//     _spinC.repeat();

//     try {
//       final nav = widget.navigatorKey.currentState;
//       final current = widget.routeTracker.currentRoute;

//       final name = current?.settings.name;
//       final args = current?.settings.arguments;

//       // refresh dengan replace route yang sama
//       if (nav != null && name != null && name.isNotEmpty) {
//         await nav.pushReplacementNamed(name, arguments: args);
//       }
//     } finally {
//       if (!mounted) return;
//       _spinC.stop();
//       setState(() {
//         _refreshing = false;
//         _pull = 0;
//       });
//     }
//   }

//   void _setPull(double value) {
//     final v = value.clamp(0.0, widget.maxPull);
//     if (v == _pull) return;
//     setState(() => _pull = v);
//   }

//   bool _onScroll(ScrollNotification n) {
//     if (_refreshing) return false;

//     // kita cuma peduli jika posisi scroll ada di TOP
//     final atTop = n.metrics.pixels <= 0;

//     // iOS bounce / Android glow -> overscroll di atas
//     if (n is OverscrollNotification && atTop) {
//       // overscroll untuk pull-down biasanya NEGATIF, jadi dibalik
//       final delta = -n.overscroll;
//       if (delta > 0) {
//         _setPull(_pull + delta);
//       } else {
//         _setPull(_pull + delta); // kalau balik ke atas
//       }
//     }

//     // kalau scroll update bikin pixels jadi negatif (bounce), ikut hitung juga
//     if (n is ScrollUpdateNotification && atTop) {
//       // pixels bisa negatif saat bounce, ambil kebalikannya
//       final p = (-n.metrics.pixels);
//       if (p > 0) _setPull(math.max(_pull, p));
//     }

//     // saat lepas (scroll end), cek trigger
//     if (n is ScrollEndNotification) {
//       final shouldRefresh = _pull >= widget.triggerDistance;
//       if (shouldRefresh) {
//         _refreshCurrentRoute();
//       } else {
//         _setPull(0);
//       }
//     }

//     return false; // jangan stop notifikasi scroll lain
//   }

//   @override
//   Widget build(BuildContext context) {
//     // konten ikut turun sedikit saat pull (sesuai request kamu)
//     final pullVisual = _refreshing
//         ? math.min(widget.maxPull, widget.triggerDistance * 0.55)
//         : _pull;

//     // indikator tinggi 0..48
//     final indicatorH =
//         (_refreshing ? 48.0 : (pullVisual / 2.4).clamp(0.0, 48.0));

//     final t = (pullVisual / widget.triggerDistance).clamp(0.0, 1.0);
//     final dragAngle = t * math.pi * 2;

//     return NotificationListener<ScrollNotification>(
//       onNotification: _onScroll,
//       child: Stack(
//         children: [
//           // ✅ BODY ikut turun (di bawah header)
//           Transform.translate(
//             offset: Offset(0, pullVisual),
//             child: widget.child,
//           ),

//           // ✅ indikator icon refresh DI BAWAH header
//           Positioned(
//             top: widget.topEdgePx,
//             left: 0,
//             right: 0,
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 80),
//               height: indicatorH,
//               alignment: Alignment.center,
//               child: _refreshing
//                   ? RotationTransition(
//                       turns: _spinC,
//                       child: const Icon(Icons.refresh, size: 22),
//                     )
//                   : Transform.rotate(
//                       angle: dragAngle,
//                       child: Icon(
//                         Icons.refresh,
//                         size: 22,
//                         color: t >= 1 ? Colors.black : Colors.black54,
//                       ),
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
