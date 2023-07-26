// Programmer's Name: Ang Ru Xian
// Program Name: firebase_auth_provider.dart
// Description: This is a file that contains the provider for the FirebaseAuth class.
// Last Modified: 22 July 2023

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final firebaseAuthProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});