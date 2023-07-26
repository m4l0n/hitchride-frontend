// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reward _$RewardFromJson(Map<String, dynamic> json) => Reward(
      rewardId: json['rewardId'] as String,
      rewardTitle: json['rewardTitle'] as String,
      rewardDescription: json['rewardDescription'] as String,
      rewardPointsRequired: json['rewardPointsRequired'] as int,
      rewardPhotoUrl: json['rewardPhotoUrl'] as String,
      rewardDuration: json['rewardDuration'] as int,
    );

Map<String, dynamic> _$RewardToJson(Reward instance) => <String, dynamic>{
      'rewardDescription': instance.rewardDescription,
      'rewardDuration': instance.rewardDuration,
      'rewardId': instance.rewardId,
      'rewardPhotoUrl': instance.rewardPhotoUrl,
      'rewardPointsRequired': instance.rewardPointsRequired,
      'rewardTitle': instance.rewardTitle,
    };
