// Programmer's Name: Ang Ru Xian
// Program Name: auth_gate.dart
// Description: This is a file that watches for the user's authentication status and navigates to the appropriate screen, and also checks for permission and location status.
// Last Modified: 22 July 2023

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hitchride/src/core/local_notification.dart';
import 'package:hitchride/src/core/logger_config/logger.dart';
import 'package:hitchride/src/core/utils.dart';
import 'package:hitchride/src/features/auth/presentation/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:hitchride/src/features/auth/state/firebase_auth_provider.dart';
import 'package:hitchride/src/features/ride/state/location_input_provider.dart';
import 'package:hitchride/src/features/shared/presentation/leave_reviews_screen.dart';
import 'package:hitchride/src/features/shared/presentation/permission_request_screen.dart';
import 'package:hitchride/src/home_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();

  static route() => MaterialPageRoute(
        builder: (context) => const ProviderScope(child: AuthGate()),
      );
}

class _AuthGateState extends ConsumerState<AuthGate>
    with WidgetsBindingObserver {
  final _logger = getLogger('Auth Gate');
  PermissionStatus _permissionStatus = PermissionStatus.denied;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissionandLocation();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Permission.location.status.then((value) => _updateStatus(value));
    //Initialise local notification
    LocalNotification.init(onDidReceiveNotificationResponse);
    //Push local notification when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotification.showNotification(message);
    });
    setupInteractedMessage();
  }

  //Handle notification on click when app is in foreground
  void onDidReceiveNotificationResponse(String payload) async {
    final Map<String, dynamic> payloadMap =
        json.decode(payload) as Map<String, dynamic>;
    final Map<String, dynamic> data = {"data": payloadMap};
    // Create a RemoteMessage from the data map
    final RemoteMessage message = RemoteMessage.fromMap(data);
    // Handle the message using the _handleMessage method
    await _handleMessage(message);
  }

  //Handle notification on click when app is in background
  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      await _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    //Navigate to the review screen if the payload contains a type review
    if (message.data['type'] == 'review') {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LeaveReviewsScreen(
                rideId: message.data['payload'],
              )));
    }
  }

  void _updateStatus(PermissionStatus value) {
    if (value != _permissionStatus) {
      setState(() {
        _permissionStatus = value;
        _logger.i('Permission status changed to $_permissionStatus');
      });
    }
  }

  void _askPermission() {
    Navigator.of(context).push(createSlideTransition(
        (context) => const PermissionRequestScreen(),
        enter: false));
  }

  void _checkPermissionandLocation() {
    final locationInput = ref.watch(locationInputProvider);
    Permission.location.status.then((value) {
      _updateStatus(value);
      if (value.isDenied && locationInput.pickupPlaceId == null) {
        _askPermission();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _checkPermissionandLocation();
    return Consumer(
      builder: (context, ref, _) {
        final userStream = ref.watch(firebaseAuthProvider);
        return userStream.when(
            data: (user) {
              return user != null ? const HomePage() : const LoginScreen();
            },
            error: (_, __) => const Text('Error'),
            loading: () => const CircularProgressIndicator());
      },
    );
  }
}
