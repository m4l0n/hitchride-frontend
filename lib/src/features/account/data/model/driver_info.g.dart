// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverInfo _$DriverInfoFromJson(Map<String, dynamic> json) => DriverInfo(
      diCarBrand: json['diCarBrand'] as String?,
      diCarModel: json['diCarModel'] as String?,
      diCarColor: json['diCarColor'] as String?,
      diCarLicensePlate: json['diCarLicensePlate'] as String?,
      diDateJoinedTimestamp: json['diDateJoinedTimestamp'] as int,
      diDateCarBoughtTimestamp: json['diDateCarBoughtTimestamp'] as int?,
      diIsCarSecondHand: json['diIsCarSecondHand'] as bool?,
      diRating: json['diRating'] as int?,
      diNumberOfRatings: json['diNumberOfRatings'] as int?,
    );

Map<String, dynamic> _$DriverInfoToJson(DriverInfo instance) =>
    <String, dynamic>{
      'diCarBrand': instance.diCarBrand,
      'diCarColor': instance.diCarColor,
      'diCarLicensePlate': instance.diCarLicensePlate,
      'diCarModel': instance.diCarModel,
      'diDateCarBoughtTimestamp': instance.diDateCarBoughtTimestamp,
      'diDateJoinedTimestamp': instance.diDateJoinedTimestamp,
      'diIsCarSecondHand': instance.diIsCarSecondHand,
      'diRating': instance.diRating,
      'diNumberOfRatings': instance.diNumberOfRatings,
    };
