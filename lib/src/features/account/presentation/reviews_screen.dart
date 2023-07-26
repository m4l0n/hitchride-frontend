// Programmer's Name: Ang Ru Xian
// Program Name: reviews_screen.dart
// Description: This is a file that contains the screen for the reviews page.
// Last Modified: 22 July 2023

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hitchride/src/core/enums/filter_type.dart';
import 'package:hitchride/src/features/account/state/review_provider.dart';
import 'package:hitchride/src/features/account/widgets/review_card.dart';
import 'package:hitchride/src/features/shared/widgets/tab_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class ReviewsScreen extends ConsumerStatefulWidget {
  const ReviewsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends ConsumerState<ReviewsScreen> {
  int _reviewsCount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get the user's reviews and update the reviews count
    ref.read(userReviewsProvider.future).then((userReviews) {
      setState(() {
        _reviewsCount = userReviews.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the filter type and user reviews
    final filterTypeProviderRef = ref.watch(filterProvider);
    final userReviewsAsyncValue = ref.watch(userReviewsProvider);
    // Get the filtered reviews based on the selected filter type
    final filteredReviews = ref.watch(userReviewsFilteredProvider);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(FirebaseAuth.instance.currentUser!.displayName ?? 'User',
              style:
                  const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: CircleAvatar(
                          radius: 30.0,
                          child: Text(
                            FirebaseAuth.instance.currentUser!.displayName
                                        ?.isEmpty ??
                                    true
                                ? 'U'
                                : FirebaseAuth
                                    .instance.currentUser!.displayName![0],
                            style: const TextStyle(fontSize: 24.0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 50),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.comment, size: 25),
                              const SizedBox(width: 8),
                              Text(_reviewsCount.toString(),
                                  style: const TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Text(
                            'Reviews',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(height: 16.0, color: Colors.white),
            Container(
              height: 70,
              color: Colors.white,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      // Tab button for sorting reviews by latest
                      TabButton(
                        text: 'Latest',
                        isSelected: filterTypeProviderRef == FilterType.latest,
                        onTap: () => ref.read(filterProvider.notifier).state =
                            FilterType.latest,
                      ),
                      const SizedBox(width: 16.0),
                      // Tab button for sorting reviews by highest rating
                      TabButton(
                        text: 'Highest Rating',
                        isSelected:
                            filterTypeProviderRef == FilterType.highestRated,
                        onTap: () => ref.read(filterProvider.notifier).state =
                            FilterType.highestRated,
                      ),
                      const SizedBox(width: 16.0),
                      // Tab button for filtering reviews for the user
                      TabButton(
                        text: 'For You',
                        isSelected: filterTypeProviderRef == FilterType.forYou,
                        onTap: () => ref.read(filterProvider.notifier).state =
                            FilterType.forYou,
                      ),
                      const SizedBox(width: 16.0),
                      // Tab button for filtering reviews by the user
                      TabButton(
                        text: 'By You',
                        isSelected: filterTypeProviderRef == FilterType.byYou,
                        onTap: () => ref.read(filterProvider.notifier).state =
                            FilterType.byYou,
                      ),
                    ],
                  )),
            ),
            Flexible(
              child: RefreshIndicator(
                  onRefresh: () async {
                    return await ref.refresh(userReviewsProvider);
                  },
                  child: userReviewsAsyncValue.when(
                      data: (userReviews) {
                        if (filteredReviews.isEmpty) {
                          // Display message when user has no reviews
                          return Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 80),
                              Image.asset(
                                'assets/images/feedback.png',
                                height: 250,
                                width: 250,
                              ),
                              const SizedBox(height: 24),
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'You have no reviews yet. Request your passengers to review you, or review your past rides.',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ));
                        }
                        // Display the user's reviews
                        return ListView.separated(
                            itemCount: filteredReviews.length,
                            padding: const EdgeInsets.all(8.0),
                            itemBuilder: (context, index) {
                              final review = filteredReviews[index];
                              return ReviewCard(
                                driverName: review.reviewRide.rideDriverJourney
                                    .djDriver!.userName,
                                driverCar:
                                    '${review.reviewRide.rideDriverJourney.djDriver!.userDriverInfo!.diCarBrand} ${review.reviewRide.rideDriverJourney.djDriver!.userDriverInfo!.diCarModel}',
                                starRating: review.reviewRating,
                                date: DateTime.fromMillisecondsSinceEpoch(
                                    review.reviewTimestamp),
                                description: review.reviewDescription,
                                pickupAddress: review.reviewRide
                                    .rideOriginDestination.origin.addressName,
                                destinationAddress: review
                                    .reviewRide
                                    .rideOriginDestination
                                    .destination
                                    .addressName,
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 10,
                                ));
                      },
                      error: (e, st) => Text(e.toString()),
                      loading: () => ListView.builder(
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            // Display shimmer effect while loading reviews
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  width: double.infinity,
                                  height: 120.0,
                                ),
                              ),
                            );
                          }))),
            )
          ],
        ));
  }
}