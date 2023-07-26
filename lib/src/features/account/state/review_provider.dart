// Programmer's Name: Ang Ru Xian
// Program Name: review_provider.dart
// Description: This is a file that contains the provider for the review related functions.
// Last Modified: 22 July 2023


import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:hitchride/src/core/enums/filter_type.dart';
import 'package:hitchride/src/features/account/data/api/review_api.dart';
import 'package:hitchride/src/features/account/data/model/reviews.dart';
import 'package:hitchride/src/features/account/data/repository/review_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


final reviewApiClientProvider = Provider<ReviewApiClient>((ref) {
  final dio = GetIt.instance<Dio>();
  return ReviewApiClient(dio);
});

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  final reviewApiClient = ref.watch(reviewApiClientProvider);
  return ReviewRepository(reviewApiClient: reviewApiClient);
});

final userReviewsProvider = FutureProvider<List<Review>>((ref) async {
  final reviewRepository = ref.watch(reviewRepositoryProvider);
  return reviewRepository.getUserReviews();
});

final userReviewsFilteredProvider = Provider<List<Review>>((ref) {
  final filter = ref.watch(filterProvider);
  final reviewsListAsyncValue = ref.watch(userReviewsProvider);

  return reviewsListAsyncValue.when(
    data: (List<Review> reviewsList) {
      switch (filter) {
        case FilterType.highestRated:
          return reviewsList
            ..sort((a, b) => b.reviewRating.compareTo(a.reviewRating));
        case FilterType.latest:
          return reviewsList
            ..sort((a, b) => b.reviewTimestamp.compareTo(a.reviewTimestamp));
        case FilterType.byYou:
          return reviewsList
              .where((review) =>
                  review.reviewRide.ridePassenger!.userId ==
                  FirebaseAuth.instance.currentUser!.uid)
              .toList();
        case FilterType.forYou:
          return reviewsList
              .where((review) =>
                  review.reviewRide.rideDriverJourney.djDriver!.userName ==
                  FirebaseAuth.instance.currentUser!.uid)
              .toList();
        default:
          return reviewsList;
      }
    },
    loading: () => [], // Return an empty list while loading
    error: (error, stack) => [], // Return an empty list on error
  );
});