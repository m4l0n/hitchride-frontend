import 'package:json_annotation/json_annotation.dart';

part 'reward.g.dart';

@JsonSerializable()
class Reward {
  Reward({
    required this.rewardId,
    required this.rewardTitle,
    required this.rewardDescription,
    required this.rewardPointsRequired,
    required this.rewardPhotoUrl,
    required this.rewardDuration,
  });

  factory Reward.fromJson(Map<String, dynamic> json) => _$RewardFromJson(json);

  final String rewardDescription;
  final int rewardDuration;
  final String rewardId;
  final String rewardPhotoUrl;
  final int rewardPointsRequired;
  final String rewardTitle;
}