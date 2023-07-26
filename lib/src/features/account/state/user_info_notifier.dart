// Programmer's Name: Ang Ru Xian
// Program Name: user_info_notifier.dart
// Description: This is a file that contains the StateNotifier for UserState.
// Last Modified: 22 July 2023

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hitchride/src/features/account/data/model/user_state.dart';
import 'package:hitchride/src/features/account/data/repository/user_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserNotifier extends StateNotifier<UserState> {
  final UserRepository userRepository;

  UserNotifier(this.userRepository) : super(UserLoading()) {
    if (FirebaseAuth.instance.currentUser != null) {
      fetchUser();
    }
  }

  Future<void> fetchUser() async {
    try {
      final user = await userRepository.getProfileDetails();
      state = UserData(user);
    } catch (error) {
      state = UserError(error.toString());
    }
  }
}
