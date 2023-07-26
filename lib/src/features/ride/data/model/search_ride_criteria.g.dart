// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_ride_criteria.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchRideCriteria _$SearchRideCriteriaFromJson(Map<String, dynamic> json) =>
    SearchRideCriteria(
      searchRideLocationCriteria: OriginDestination.fromJson(
          json['searchRideLocationCriteria'] as Map<String, dynamic>),
      searchRideTimestampCriteria: json['searchRideTimestampCriteria'] as int,
    );

Map<String, dynamic> _$SearchRideCriteriaToJson(SearchRideCriteria instance) =>
    <String, dynamic>{
      'searchRideLocationCriteria': instance.searchRideLocationCriteria,
      'searchRideTimestampCriteria': instance.searchRideTimestampCriteria,
    };
