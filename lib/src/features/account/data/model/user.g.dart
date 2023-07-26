// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HitchRideUser _$HitchRideUserFromJson(Map<String, dynamic> json) =>
    HitchRideUser(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String,
      userPhoneNumber: json['userPhoneNumber'] as String,
      userPhotoUrl: json['userPhotoUrl'] as String,
      userPoints: json['userPoints'] as int,
      userDriverInfo: json['userDriverInfo'] == null
          ? null
          : DriverInfo.fromJson(json['userDriverInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HitchRideUserToJson(HitchRideUser instance) =>
    <String, dynamic>{
      'userDriverInfo': instance.userDriverInfo,
      'userEmail': instance.userEmail,
      'userId': instance.userId,
      'userName': instance.userName,
      'userPhoneNumber': instance.userPhoneNumber,
      'userPhotoUrl': instance.userPhotoUrl,
      'userPoints': instance.userPoints,
    };
