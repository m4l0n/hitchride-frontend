// Programmer's Name: Ang Ru Xian
// Program Name: enlarged_elevated_button.dart
// Description: This is a file that contains a custom elevated button widget.
// Last Modified: 22 July 2023

import 'package:flutter/material.dart';

class EnlargedElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const EnlargedElevatedButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: onPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 13.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
