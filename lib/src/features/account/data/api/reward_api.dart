// Programmer's Name: Ang Ru Xian
// Program Name: reward_api.dart
// Description: This is a file that contains the methods to call the API for reward related functions.
// Last Modified: 22 July 2023

import 'package:dio/dio.dart';
import 'package:hitchride/src/core/api_response.dart';
import 'package:hitchride/src/features/account/data/model/reward.dart';
import 'package:hitchride/src/features/account/data/model/reward_category.dart';
import 'package:retrofit/retrofit.dart';

part 'reward_api.g.dart';

@RestApi()
abstract class RewardApiClient {
  factory RewardApiClient(Dio dio, {String baseUrl}) = _RewardApiClient;

  @GET('/reward/getRewardsCategories')
  Future<ApiResponse<List<RewardCategory>>> getRewardCategories();
  
  @GET('/reward/redeem')
  Future<ApiResponse<Reward>> redeemReward(@Query('rewardId') String rewardId);
}
  