// Programmer's Name: Ang Ru Xian
// Program Name: user_provider.dart
// Description: This is a file that contains the provider for the UserApiClient class.
// Last Modified: 22 July 2023

import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:hitchride/src/features/account/data/api/user_api.dart';
import 'package:hitchride/src/features/account/data/model/user.dart';
import 'package:hitchride/src/features/account/data/model/user_state.dart';
import 'package:hitchride/src/features/account/data/repository/image_repository.dart';
import 'package:hitchride/src/features/account/data/repository/user_repository.dart';
import 'package:hitchride/src/features/account/state/user_info_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userApiClientProvider = Provider<UserApiClient>((ref) {
  final dio = GetIt.instance<Dio>();
  return UserApiClient(dio);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final userApiClient = ref.watch(userApiClientProvider);
  return UserRepository(userApiClient: userApiClient);
});

final userInfoProvider = FutureProvider.autoDispose<HitchRideUser>((ref) async {
  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.getProfileDetails();
});

final cachedUserInfoProvider = StateNotifierProvider<UserNotifier, UserState>(
    (ref) => UserNotifier(ref.watch(userRepositoryProvider)));

final imageRepositoryProvider =
    Provider<ImageRepository>((ref) => ImageRepository());
