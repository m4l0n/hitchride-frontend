import 'package:json_annotation/json_annotation.dart';

part 'driver_info.g.dart';

@JsonSerializable()
class DriverInfo {
  DriverInfo({
    required this.diCarBrand,
    required this.diCarModel,
    required this.diCarColor,
    required this.diCarLicensePlate,
    required this.diDateJoinedTimestamp,
    required this.diDateCarBoughtTimestamp,
    required this.diIsCarSecondHand,
    required this.diRating,
    required this.diNumberOfRatings,
  });

  factory DriverInfo.fromJson(Map<String,dynamic> data) => _$DriverInfoFromJson(data);

  String? diCarBrand;
  String? diCarColor;
  String? diCarLicensePlate;
  String? diCarModel;
  int? diDateCarBoughtTimestamp;
  int diDateJoinedTimestamp; 
  bool? diIsCarSecondHand;
  int? diRating;
  int? diNumberOfRatings;

  Map<String,dynamic> toJson() => _$DriverInfoToJson(this);

  DriverInfo copyWith({
    String? diCarBrand,
    String? diCarModel,
    String? diCarColor,
    String? diCarLicensePlate,
    int? diDateJoined,
    int? diDateCarBought,
    bool? diIsCarSecondHand,
    int? diRating,
    int? diNumberOfRatings,
  }) {
      return DriverInfo(
        diCarBrand: diCarBrand ?? this.diCarBrand,
        diCarModel: diCarModel ?? this.diCarModel,
        diCarColor: diCarColor ?? this.diCarColor,
        diCarLicensePlate: diCarLicensePlate ?? this.diCarLicensePlate,
        diDateJoinedTimestamp: diDateJoined ?? this.diDateJoinedTimestamp,
        diDateCarBoughtTimestamp: diDateCarBought ?? this.diDateCarBoughtTimestamp,
        diIsCarSecondHand: diIsCarSecondHand ?? this.diIsCarSecondHand,
        diRating: diRating ?? this.diRating,
        diNumberOfRatings: diNumberOfRatings ?? this.diNumberOfRatings,
      );
  }
}