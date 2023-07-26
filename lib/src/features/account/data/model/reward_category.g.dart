// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RewardCategory _$RewardCategoryFromJson(Map<String, dynamic> json) =>
    RewardCategory(
      rcId: json['rcId'] as String,
      rcName: json['rcName'] as String,
      rcRewardsList: (json['rcRewardsList'] as List<dynamic>)
          .map((e) => Reward.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RewardCategoryToJson(RewardCategory instance) =>
    <String, dynamic>{
      'rcId': instance.rcId,
      'rcName': instance.rcName,
      'rcRewardsList': instance.rcRewardsList,
    };
