import 'package:hitchride/src/features/ride/data/model/origin_destination.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_ride_criteria.g.dart';

@JsonSerializable()
class SearchRideCriteria {
  final OriginDestination searchRideLocationCriteria;
  final int searchRideTimestampCriteria;

  SearchRideCriteria({
    required this.searchRideLocationCriteria,
    required this.searchRideTimestampCriteria,
  });

  factory SearchRideCriteria.fromJson(Map<String, dynamic> json) => _$SearchRideCriteriaFromJson(json);

  Map<String, dynamic> toJson() => _$SearchRideCriteriaToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchRideCriteria &&
          runtimeType == other.runtimeType &&
          searchRideLocationCriteria == other.searchRideLocationCriteria &&
          searchRideTimestampCriteria == other.searchRideTimestampCriteria;

  @override
  int get hashCode => searchRideLocationCriteria.hashCode ^ searchRideTimestampCriteria.hashCode;

}