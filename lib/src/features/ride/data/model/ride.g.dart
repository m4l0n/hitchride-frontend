// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ride _$RideFromJson(Map<String, dynamic> json) => Ride(
      rideId: json['rideId'] as String?,
      ridePassenger: json['ridePassenger'] == null
          ? null
          : HitchRideUser.fromJson(
              json['ridePassenger'] as Map<String, dynamic>),
      rideOriginDestination: OriginDestination.fromJson(
          json['rideOriginDestination'] as Map<String, dynamic>),
      rideDriverJourney: DriverJourney.fromJson(
          json['rideDriverJourney'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RideToJson(Ride instance) => <String, dynamic>{
      'rideDriverJourney': instance.rideDriverJourney,
      'rideId': instance.rideId,
      'rideOriginDestination': instance.rideOriginDestination,
      'ridePassenger': instance.ridePassenger,
    };
