// Programmer's Name: Ang Ru Xian
// Program Name: reward_repository.dart
// Description: This is a file that contains the repository class for reward related functions.
// Last Modified: 22 July 2023

import 'package:dio/dio.dart';
import 'package:hitchride/src/core/api_response.dart';
import 'package:hitchride/src/features/account/data/api/reward_api.dart';
import 'package:hitchride/src/features/account/data/model/reward.dart';
import 'package:hitchride/src/features/account/data/model/reward_category.dart';

class RewardRepository {
  final RewardApiClient rewardApiClient;

  RewardRepository({required this.rewardApiClient});

  Future<List<RewardCategory>> getRewardCategories() async {
    try {
      final response = await rewardApiClient.getRewardCategories();
      if (response.statusCode == 'OK') {
        final rewardCategoriesList = response.result;
        if (rewardCategoriesList == null) {
          return [];
        }
        return rewardCategoriesList;
      } else {
        throw Exception(response.message);
      }
    } on DioException catch (e) {
      ApiResponse<dynamic> apiResponse = ApiResponse.fromJson(
        e.response!.data,
        (json) => json,
      );
      throw Exception(apiResponse.message);
    }
  }

  Future<Reward> redeemReward(String rewardId) async {
    try {
      final response = await rewardApiClient.redeemReward(rewardId);
      if (response.statusCode == 'OK') {
        final reward = response.result;
        if (reward == null) {
          throw Exception('Reward not found');
        }
        return reward;
      } else {
        throw Exception(response.message);
      }
    } on DioException catch (e) {
      ApiResponse<dynamic> apiResponse = ApiResponse.fromJson(
        e.response!.data,
        (json) => json,
      );
      throw Exception(apiResponse.message);
    }
  }
}