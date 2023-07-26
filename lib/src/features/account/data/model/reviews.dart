import 'package:hitchride/src/features/ride/data/model/ride.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reviews.g.dart';

@JsonSerializable()
class Review {
  Review({
    required this.reviewId,
    required this.reviewRating,
    required this.reviewTimestamp,
    required this.reviewDescription,
    required this.reviewRide,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  String reviewDescription;
  String reviewId;
  double reviewRating;
  Ride reviewRide;
  int reviewTimestamp;

  Map<String, dynamic> toJson() => _$ReviewToJson(this);

  Review copyWith({
    String? reviewId,
    double? reviewRating,
    int? reviewTimestamp,
    String? reviewDescription,
    Ride? reviewRide,
  }) {
      return Review(
        reviewId: reviewId ?? this.reviewId,
        reviewRating: reviewRating ?? this.reviewRating,
        reviewTimestamp: reviewTimestamp ?? this.reviewTimestamp,
        reviewDescription: reviewDescription ?? this.reviewDescription,
        reviewRide: reviewRide ?? this.reviewRide,
      );
  }
}
