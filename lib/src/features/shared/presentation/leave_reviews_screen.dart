// Programmer's Name: Ang Ru Xian
// Program Name: leave_reviews_screen.dart
// Description: This is a file that contains the widget that displays the screen for leaving reviews.
// Last Modified: 22 July 2023

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hitchride/src/features/account/data/repository/review_repository.dart';
import 'package:hitchride/src/features/account/state/review_provider.dart';
import 'package:hitchride/src/features/shared/widgets/enlarged_elevated_button.dart';
import 'package:hitchride/src/features/shared/widgets/fade_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LeaveReviewsScreen extends ConsumerStatefulWidget {
  const LeaveReviewsScreen({super.key, required this.rideId});

  final String rideId;

  @override
  ConsumerState<LeaveReviewsScreen> createState() => _LeaveReviewsScreenState();
}

class _LeaveReviewsScreenState extends ConsumerState<LeaveReviewsScreen> {
  double rating = 0;
  TextEditingController reviewController = TextEditingController();
  FocusNode reviewFocusNode = FocusNode();

  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _isLoading.dispose();
    reviewController.dispose();
    reviewFocusNode.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ratings cannot be 0'),
        ),
      );
      return;
    }
    showFadeDialog(
        context: context,
        title: 'Submit Review',
        content: const Text('Are you sure of this review?'),
        actions: [
          TextButton(
            onPressed: _onConfirmReview,
            child: const Text('Yes'),
          ),
        ]);
  }

  void _onConfirmReview() async {
    _isLoading.value = true;
    final ReviewRepository reviewRepository =
        ref.read(reviewRepositoryProvider);
    Navigator.of(context).pop();
    try {
      Map<String, dynamic> reviewData = {
        'reviewRide': {
          'rideId': widget.rideId,
        },
        'reviewRating': rating,
        'reviewDescription': reviewController.text,
        'reviewTimestamp': DateTime.now().millisecondsSinceEpoch,
      };
      await reviewRepository.createReview(reviewData);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Review submitted successfully'),
          ),
        );
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to submit review. Error: ${e.toString()}'),
            backgroundColor: Colors.red),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Leave a Review',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Rating',
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 40.0,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                onRatingUpdate: (value) {
                  setState(() {
                    rating = value;
                  });
                },
              ),
              const SizedBox(height: 30),
              const Text('Review',
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
              Expanded(
                child: TextField(
                  controller: reviewController,
                  focusNode: reviewFocusNode,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: 200,
                  decoration: const InputDecoration(
                    hintText: 'Write your review here',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: ValueListenableBuilder<bool>(
            valueListenable: _isLoading,
            builder: (context, isLoading, child) => EnlargedElevatedButton(
                text: 'Submit Review',
                onPressed: () {
                  reviewFocusNode.unfocus();
                  _submitReview();
                },
                isLoading: isLoading)));
  }
}
