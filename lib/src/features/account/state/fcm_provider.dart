// Programmer's Name: Ang Ru Xian
// Program Name: fcm_provider.dart
// Description: This is a file that contains the provider for the FcmApiClient class.
// Last Modified: 22 July 2023


import 'package:hitchride/src/features/account/data/api/fcm_api.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final fcmApiClientProvider = Provider<FcmApiClient>((ref) {
  return FcmApiClient();
});