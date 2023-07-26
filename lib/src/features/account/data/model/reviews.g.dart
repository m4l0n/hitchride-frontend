// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reviews.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      reviewId: json['reviewId'] as String,
      reviewRating: (json['reviewRating'] as num).toDouble(),
      reviewTimestamp: json['reviewTimestamp'] as int,
      reviewDescription: json['reviewDescription'] as String,
      reviewRide: Ride.fromJson(json['reviewRide'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'reviewDescription': instance.reviewDescription,
      'reviewId': instance.reviewId,
      'reviewRating': instance.reviewRating,
      'reviewRide': instance.reviewRide,
      'reviewTimestamp': instance.reviewTimestamp,
    };
