// Programmer's Name: Ang Ru Xian
// Program Name: driver_board.dart
// Description: This is a file that contains the UI for driver board screen.
// Last Modified: 22 July 2023

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hitchride/src/core/logger_config/logger.dart';
import 'package:hitchride/src/features/driver/data/model/faq_item.dart';
import 'package:hitchride/src/features/driver/presentation/driver_upcoming_journey_screen.dart';
import 'package:hitchride/src/features/driver/presentation/post_journey_screen.dart';
import 'package:hitchride/src/features/driver/state/faq_provider.dart';
import 'package:hitchride/src/features/shared/widgets/animated_navbar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// This widget is used to create a card that can be opened to reveal more information.
class OpenContainerCard extends StatelessWidget {
  final String text;
  final String imagePath;
  final Widget destinationScreen;

  const OpenContainerCard({
    super.key,
    required this.text,
    required this.imagePath,
    required this.destinationScreen,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).colorScheme.inverseSurface;
    final foregroundColor = Theme.of(context).colorScheme.onInverseSurface;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: OpenContainer(
          closedElevation: 0,
          closedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          closedBuilder: (context, action) {
            return Container(
              height: 160,
              color: backgroundColor,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        text,
                        style: TextStyle(
                            fontSize: 20,
                            color: foregroundColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0),
                    ),
                    child: Image.asset(
                      imagePath,
                      width: 150,
                      height: 150,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ],
              ),
            );
          },
          openBuilder: (context, action) {
            return destinationScreen;
          },
        ),
      ),
    );
  }
}

// This widget is the main driver board screen.
class DriverBoard extends ConsumerStatefulWidget {
  const DriverBoard({super.key});

  @override
  ConsumerState<DriverBoard> createState() => _DriverBoardState();
}

class _DriverBoardState extends ConsumerState<DriverBoard>{
  final _logger = getLogger('DriverBoard');
  final _scrollController = ScrollController();

  // This function adds a scroll listener to the screen.
  void _addScrollListener() {
    final navbarNotifier = ref.watch(navbarNotifierProvider);
    _logger.i('hideBottomNavBar: ${navbarNotifier.hideBottomNavBar}');
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (navbarNotifier.hideBottomNavBar) {
          navbarNotifier.hideBottomNavBar = false;
        }
      } else {
        if (!navbarNotifier.hideBottomNavBar) {
          navbarNotifier.hideBottomNavBar = true;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _addScrollListener();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Driver's Board",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(8.0),
        children: [
          const SizedBox(height: 16.0),
          const OpenContainerCard(
            text: 'View Upcoming Journeys',
            imagePath: 'assets/images/view_upcoming_journey.png',
            destinationScreen: DriverUpcomingJourneyScreen(),
          ),
          const SizedBox(height: 16.0),
          const OpenContainerCard(
            text: 'Post a Journey',
            imagePath: 'assets/images/post_journey.png',
            destinationScreen: PostJourneyScreen(),
          ),
          const SizedBox(height: 30.0),
          _buildFaqSection(ref),
        ],
      ),
    );
  }

  // This function builds the FAQ section of the screen.
  Widget _buildFaqSection(WidgetRef ref) {
    return Consumer(builder: (context, watch, child) {
      AsyncValue<List<FaqItem>> faqData = ref.watch(faqDataProvider);

      return faqData.when(
        data: (List<FaqItem> faqItems) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ListTile(
                title: Text(
                  'Frequently Asked Questions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ...faqItems.map((faqItem) => ExpansionTile(
                    leading: const Icon(Icons.question_answer_rounded),
                    title: Text(faqItem.question,
                        style: const TextStyle(fontSize: 13)),
                    children: [
                      ListTile(
                        title: Text(
                          faqItem.answer,
                          style: const TextStyle(fontSize: 13),
                        ),
                        leading: const Icon(Icons.check_circle_outline_rounded),
                      ),
                    ],
                  )),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Text('Error loading FAQ data'),
      );
    });
  }
}