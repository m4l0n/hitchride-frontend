import 'package:hitchride/src/features/account/data/model/user.dart';
import 'package:hitchride/src/features/ride/data/model/origin_destination.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_journey.g.dart';

@JsonSerializable()
class DriverJourney {
  DriverJourney({
    this.djId,
    this.djDriver,
    required this.djTimestamp,
    required this.djOriginDestination,
    required this.djDestinationRange,
    required this.djPrice,
  });

  factory DriverJourney.fromJson(Map<String, dynamic> json) => _$DriverJourneyFromJson(json);

  String? djId;
  int djDestinationRange;
  HitchRideUser? djDriver;
  OriginDestination djOriginDestination;
  int djTimestamp;
  String djPrice;

  Map<String, dynamic> toJson() => _$DriverJourneyToJson(this);

  DriverJourney copyWith({
    String? djId,
    HitchRideUser? djDriver,
    int? djTimestamp,
    OriginDestination? djOriginDestination,
    int? djDestinationRange,
    String? djPrice,
  }) {
      return DriverJourney(
        djId: djId ?? this.djId,
        djDriver: djDriver ?? this.djDriver,
        djTimestamp: djTimestamp ?? this.djTimestamp,
        djOriginDestination: djOriginDestination ?? this.djOriginDestination,
        djDestinationRange: djDestinationRange ?? this.djDestinationRange,
        djPrice: djPrice ?? this.djPrice,
      );
  }
}
