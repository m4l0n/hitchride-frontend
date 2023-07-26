// Programmer's Name: Ang Ru Xian
// Program Name: slide_page_route.dart
// Description: This is a file that contains a custom animation when transitioning between pages.
// Last Modified: 22 July 2023

import 'package:flutter/material.dart';

class SlidePageRoute<T> extends MaterialPageRoute<T> {
  final bool isSlideRight;

  SlidePageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    this.isSlideRight = false,
  }) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    var begin = isSlideRight ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0);
    var end = Offset.zero;
    var tween = Tween(begin: begin, end: end);
    var offsetAnimation = animation.drive(tween);

    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }
}