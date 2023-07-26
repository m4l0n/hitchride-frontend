// Programmer's Name: Ang Ru Xian
// Program Name: circular_back_button.dart
// Description: This is a file that contains the widget for the circular back button that is displayed on top of an existing widget.
// Last Modified: 22 July 2023

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CircularBackButton extends ConsumerWidget {
  final void Function()? onPressed;

  const CircularBackButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white70.withOpacity(0.7),
            ),
            padding: const EdgeInsets.all(8.0),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
