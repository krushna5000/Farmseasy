import 'package:flutter/material.dart';

Route animatedRoute(Widget page, {Offset beginOffset = const Offset(1.0, 0.0)}) {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, secondaryAnimation, child) {
      const curve = Curves.easeInOut;
      var tween = Tween(begin: beginOffset, end: Offset.zero)
          .chain(CurveTween(curve: curve));

      var fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeIn),
      );

      return FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(position: animation.drive(tween), child: child),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}
