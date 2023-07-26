// Programmer's Name: Ang Ru Xian
// Program Name: pageview_dots.dart
// Description: This is a file that contains the widget to indicate the current page of the pageview.
// Last Modified: 22 July 2023

import 'package:flutter/material.dart';

class PageViewDots extends StatelessWidget {
  final int _currentPageIndex;
  final int position;
  final VoidCallback onTap;

  const PageViewDots({Key? key, required int currentPageIndex, required this.onTap, required this.position})
      : _currentPageIndex = currentPageIndex,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final focusColor = theme.colorScheme.primary;
    final unfocusColor = theme.colorScheme.primary.withOpacity(0.3);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: position == 0 ? _currentPageIndex == 0 ? focusColor : unfocusColor : _currentPageIndex == 1 ? focusColor : unfocusColor,
        ),
      ),
    );
  }
}