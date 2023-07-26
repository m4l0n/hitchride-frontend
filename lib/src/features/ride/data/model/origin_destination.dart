import 'package:hitchride/src/features/ride/data/model/location_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'origin_destination.g.dart';

@JsonSerializable()
class OriginDestination {
  OriginDestination({
    required this.origin,
    required this.destination,
  });

  factory OriginDestination.fromJson(Map<String, dynamic> json) =>
      _$OriginDestinationFromJson(json);

  final LocationData destination;
  final LocationData origin;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OriginDestination &&
          runtimeType == other.runtimeType &&
          origin == other.origin &&
          destination == other.destination;

  @override
  int get hashCode => origin.hashCode ^ destination.hashCode;

  Map<String, dynamic> toJson() => _$OriginDestinationToJson(this);

  OriginDestination copyWith({
    LocationData? origin,
    LocationData? destination,
  }) {
    return OriginDestination(
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
    );
  }
}
