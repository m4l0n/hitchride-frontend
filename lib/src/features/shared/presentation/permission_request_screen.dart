// Programmer's Name: Ang Ru Xian
// Program Name: permission_request_screen.dart
// Description: This is a file that contains the screen for requesting location permission.
// Last Modified: 22 July 2023

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hitchride/src/features/ride/state/location_input_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionRequestScreen extends ConsumerStatefulWidget {
  const PermissionRequestScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PermissionRequestScreen> createState() =>
      _PermissionRequestScreenState();
}

class _PermissionRequestScreenState
    extends ConsumerState<PermissionRequestScreen> with WidgetsBindingObserver {
  PermissionStatus _permissionStatus = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissionandLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Permission Needed'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'This app needs access to your location.',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              child: const Text(
                'Grant Permission',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                await Geolocator.openAppSettings();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _updateStatus(PermissionStatus value) {
    if (value != _permissionStatus) {
      setState(() {
        _permissionStatus = value;
      });
    }
  }

  void _checkPermissionandLocation() {
    final locationInput = ref.watch(locationInputProvider);
    Permission.location.status.then((value) {
      _updateStatus(value);
      if (value == PermissionStatus.granted ||
          locationInput.pickupPlaceId != null) {
        Navigator.of(context).pop();
      }
    });
  }
}
