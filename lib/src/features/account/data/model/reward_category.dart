import 'package:hitchride/src/features/account/data/model/reward.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reward_category.g.dart';

@JsonSerializable()
class RewardCategory {
  RewardCategory({
    required this.rcId,
    required this.rcName,
    required this.rcRewardsList,
  });

  factory RewardCategory.fromJson(Map<String, dynamic> json) =>
      _$RewardCategoryFromJson(json);

  final String rcId;
  final String rcName;
  final List<Reward> rcRewardsList;
}