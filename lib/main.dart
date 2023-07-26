// Programmer's Name: Ang Ru Xian
// Program Name: main.dart
// Description: This is a file that contains the main function of the application. entry point of the application.
// Last Modified: 22 July 2023

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:hitchride/firebase_options.dart';
import 'package:hitchride/src/core/retrofit_config/dio_client.dart';
import 'package:hitchride/src/core/logger_config/logger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'src/app.dart';

class Logger extends ProviderObserver {
  final _logger = getLogger("Provider Observer");

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    _logger.d('''
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$newValue"
}''');
  }
}


void checkGoogleApiAvailability() async {
  // Check for a compatible version of Google Play services
  GoogleApiAvailability apiAvailability = GoogleApiAvailability.instance;
  var googlePlayServicesAvailability =
      await apiAvailability.checkGooglePlayServicesAvailability();
  if (googlePlayServicesAvailability !=
      GooglePlayServicesAvailability.success) {
    // If the version of Google Play services installed on this device
    // is not compatible with the version required by the app, the
    // user should be prompted to update the app.
    if (await apiAvailability.isUserResolvable()) {
      apiAvailability.makeGooglePlayServicesAvailable();
    }
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initLocator();

  runApp(ProviderScope(observers: [Logger()], child: const MyApp()));
}
