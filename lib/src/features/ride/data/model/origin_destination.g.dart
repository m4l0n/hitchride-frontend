// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'origin_destination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OriginDestination _$OriginDestinationFromJson(Map<String, dynamic> json) =>
    OriginDestination(
      origin: LocationData.fromJson(json['origin'] as Map<String, dynamic>),
      destination:
          LocationData.fromJson(json['destination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OriginDestinationToJson(OriginDestination instance) =>
    <String, dynamic>{
      'destination': instance.destination,
      'origin': instance.origin,
    };
