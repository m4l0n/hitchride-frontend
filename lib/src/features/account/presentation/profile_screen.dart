// Programmer's Name: Ang Ru Xian
// Program Name: profile_screen.dart
// Description: This is a file that contains the ProfileScreen widget that displays a list of screens that users can navigate to.
// Last Modified: 22 July 2023


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hitchride/src/features/shared/widgets/animated_navbar.dart';
import 'package:hitchride/src/core/utils.dart';
import 'package:hitchride/src/features/account/presentation/activity_screen.dart';
import 'package:hitchride/src/features/account/presentation/reviews_screen.dart';
import 'package:hitchride/src/features/account/presentation/rewards_screen.dart';
import 'package:hitchride/src/features/account/presentation/user_info_screen.dart';
import 'package:hitchride/src/features/shared/widgets/custom_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _scrollController = ScrollController();
  // A map of account navigation actions that will be displayed in the profile screen
  final accountNavActions = {
    "Reviews": const ReviewsScreen(),
    "Your Information": const UserInfoScreen(),
    "Activity History": const ActivityHistoryScreen(),
  };

  void _addScrollListener() {
    final navBarNotifier = ref.watch(navbarNotifierProvider);
    _scrollController.addListener(() {
      // Hide the bottom navigation bar when scrolling down
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (navBarNotifier.hideBottomNavBar) {
          navBarNotifier.hideBottomNavBar = false;
        }
      } else {
        // Show the bottom navigation bar when scrolling up
        if (!navBarNotifier.hideBottomNavBar) {
          navBarNotifier.hideBottomNavBar = true;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Add a scroll listener to the scroll controller after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) => _addScrollListener());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    final userName = FirebaseAuth.instance.currentUser!.displayName ?? 'User';
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Theme.of(context).canvasColor,
                      child: const Icon(CustomIcons.userCircle, size: 80),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      userName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'For more value',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.card_giftcard),
                title: const Text('Rewards'),
                onTap: () {
                  Navigator.of(context).push(createSlideTransition(
                      (context) => const RewardsScreen(),
                      enter: true));
                },
              ),
              const SizedBox(height: 25),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'My Account',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              // Display the account navigation actions
              ...accountNavActions.entries.map((entry) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey.shade200)),
                      ),
                      child: ListTile(
                        minLeadingWidth: 0,
                        title: Text(entry.key),
                        onTap: () {
                          Navigator.of(context).push(createSlideTransition(
                              (context) => entry.value,
                              enter: true));
                        },
                      ),
                    ),
                  )),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'General',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              const ListTile(
                leading: Icon(Icons.feedback),
                title: Text('Share Feedback (Coming soon!)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}