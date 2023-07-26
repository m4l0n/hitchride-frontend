// Programmer's Name: Ang Ru Xian
// Program Name: authentication_provider.dart
// Description: This is a file that contains the provider for the Authentication class.
// Last Modified: 22 July 2023

import 'package:hitchride/src/features/auth/data/repository/authentication_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authenticationProvider =
    Provider<Authentication>((ref) => Authentication());