// import 'package:flutter/material.dart';

// class RouteTracker extends RouteObserver<ModalRoute<dynamic>> {
//   ModalRoute<dynamic>? _current;

//   ModalRoute<dynamic>? get currentRoute => _current;

//   @override
//   void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
//     super.didPush(route, previousRoute);
//     if (route is ModalRoute) _current = route;
//   }

//   @override
//   void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
//     super.didPop(route, previousRoute);
//     if (previousRoute is ModalRoute) _current = previousRoute;
//   }

//   @override
//   void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
//     super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
//     if (newRoute is ModalRoute) _current = newRoute;
//   }
// }
