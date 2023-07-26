// Programmer's Name: Ang Ru Xian
// Program Name: loading_screen.dart
// Description: This is a file that contains the widget that displays the loading screen, which is shown when the user clicks on back button from certain screens
// Last Modified: 22 July 2023

import 'package:flutter/material.dart';
import 'package:hitchride/src/features/ride/state/location_input_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoadingScreen extends ConsumerStatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Clears the location input state before returning to home screen
    Future.delayed(const Duration(seconds: 1), () {
      ref.read(locationInputProvider.notifier).reset();
      Navigator.of(context).popUntil(((route) => route.isFirst));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/car_loading.gif",
          height: 250,
          width: 250,
        ),
      ),
    );
  }
}
