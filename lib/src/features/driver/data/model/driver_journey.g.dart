// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_journey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverJourney _$DriverJourneyFromJson(Map<String, dynamic> json) =>
    DriverJourney(
      djId: json['djId'] as String?,
      djDriver: json['djDriver'] == null
          ? null
          : HitchRideUser.fromJson(json['djDriver'] as Map<String, dynamic>),
      djTimestamp: json['djTimestamp'] as int,
      djOriginDestination: OriginDestination.fromJson(
          json['djOriginDestination'] as Map<String, dynamic>),
      djDestinationRange: json['djDestinationRange'] as int,
      djPrice: json['djPrice'] as String,
    );

Map<String, dynamic> _$DriverJourneyToJson(DriverJourney instance) =>
    <String, dynamic>{
      'djId': instance.djId,
      'djDestinationRange': instance.djDestinationRange,
      'djDriver': instance.djDriver,
      'djOriginDestination': instance.djOriginDestination,
      'djTimestamp': instance.djTimestamp,
      'djPrice': instance.djPrice,
    };
