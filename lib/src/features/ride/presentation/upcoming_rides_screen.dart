// Programmer's Name: Ang Ru Xian
// Program Name: upcoming_rides_screen.dart
// Description: This is a file that contains the screen that displays the upcoming rides.
// Last Modified: 22 July 2023

import 'package:flutter/material.dart';
import 'package:hitchride/src/features/ride/state/rides_provider.dart';
import 'package:hitchride/src/features/ride/widget/ride_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UpcomingRidesScreen extends ConsumerStatefulWidget {
  const UpcomingRidesScreen({super.key, required this.closeContainer});

  final VoidCallback closeContainer;

  @override
  ConsumerState<UpcomingRidesScreen> createState() =>
      _UpcomingRidesScreenState();
}

class _UpcomingRidesScreenState extends ConsumerState<UpcomingRidesScreen> {
  @override
  Widget build(BuildContext context) {
    final upcomingRidesAsyncValue = ref.watch(userUpcomingRidesProvider);

    return WillPopScope(
      onWillPop: () async {
        widget.closeContainer;
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              "Upcoming Rides",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: widget.closeContainer,
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              return await ref.refresh(userUpcomingRidesProvider);
            },
            child: upcomingRidesAsyncValue.when(
              data: (upcomingRides) {
                if (upcomingRides.isEmpty) {
                  return const Center(
                    child: Text("No upcoming rides",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500)),
                  );
                }
                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: upcomingRides.length,
                  itemBuilder: (context, index) {
                    return RideTile(
                      ride: upcomingRides[index],
                      onDelete: () {
                        setState(() {
                          upcomingRides.removeAt(index);
                        });
                      },
                    );
                  },
                );
              },
              loading: () => const Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.transparent,
              )),
              error: (err, stack) => Center(child: Text(err.toString())),
            ),
          )),
    );
  }
}
