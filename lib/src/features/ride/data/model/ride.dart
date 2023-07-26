import 'package:hitchride/src/features/account/data/model/user.dart';
import 'package:hitchride/src/features/driver/data/model/driver_journey.dart';
import 'package:hitchride/src/features/ride/data/model/origin_destination.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ride.g.dart';

@JsonSerializable()
class Ride {
  Ride({
    this.rideId,
    this.ridePassenger,
    required this.rideOriginDestination,
    required this.rideDriverJourney,
  });

  factory Ride.fromJson(Map<String, dynamic> json) => _$RideFromJson(json);

  DriverJourney rideDriverJourney;
  String? rideId;
  OriginDestination rideOriginDestination;
  HitchRideUser? ridePassenger;

  Map<String, dynamic> toJson() => _$RideToJson(this);

  Ride copyWith({
    String? rideId,
    HitchRideUser? ridePassenger,
    OriginDestination? rideOriginDestination,
    DriverJourney? rideDriverJourney,
  }) {
      return Ride(
        rideId: rideId ?? this.rideId,
        ridePassenger: ridePassenger ?? this.ridePassenger,
        rideOriginDestination: rideOriginDestination ?? this.rideOriginDestination,
        rideDriverJourney: rideDriverJourney ?? this.rideDriverJourney,
      );
  }
}
