import 'package:hitchride/src/features/account/data/model/driver_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class HitchRideUser {
  HitchRideUser({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhoneNumber,
    required this.userPhotoUrl,
    required this.userPoints,
    this.userDriverInfo,
  });

  HitchRideUser.initial() : this(userId: '', userName: '', userEmail: '', userPhoneNumber: '', userPhotoUrl: '', userPoints: 0);

  factory HitchRideUser.fromJson(Map<String, dynamic> data) =>
      _$HitchRideUserFromJson(data);

  DriverInfo? userDriverInfo;
  String userEmail;
  String userId;
  String userName;
  String userPhoneNumber;
  String userPhotoUrl;
  int userPoints;

  Map<String, dynamic> toJson() => _$HitchRideUserToJson(this);

  HitchRideUser copyWith({
    String? userId,
    String? userName,
    String? userEmail,
    String? userPhoneNumber,
    String? userPhotoUrl,
    int? userPoints,
    DriverInfo? userDriverInfo,
  }) {
    return HitchRideUser(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPhoneNumber: userPhoneNumber ?? this.userPhoneNumber,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
      userPoints: userPoints ?? this.userPoints,
      userDriverInfo: userDriverInfo ?? this.userDriverInfo,
    );
  }
}
