// Programmer's Name: Ang Ru Xian
// Program Name: reward_provider.dart
// Description: This is a file that contains the provider for the RewardApiClient class.
// Last Modified: 22 July 2023


import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:hitchride/src/features/account/data/api/reward_api.dart';
import 'package:hitchride/src/features/account/data/model/reward_category.dart';
import 'package:hitchride/src/features/account/data/repository/reward_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final rewardApiClientProvider = Provider<RewardApiClient>((ref) {
  final dio = GetIt.instance<Dio>();
  return RewardApiClient(dio);
});

final rewardRepositoryProvider = Provider<RewardRepository>((ref) {
  final rewardApiClient = ref.watch(rewardApiClientProvider);
  return RewardRepository(rewardApiClient: rewardApiClient);
});

final rewardCategoriesProvider = FutureProvider<List<RewardCategory>>((ref) async {
  final rewardRepository = ref.watch(rewardRepositoryProvider);
  final rewardCategories = await rewardRepository.getRewardCategories();
  return rewardCategories;
});