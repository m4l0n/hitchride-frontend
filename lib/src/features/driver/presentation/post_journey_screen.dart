// Programmer's Name: Ang Ru Xian
// Program Name: post_journey_screen.dart
// Description: This is a file that contains the screen for the driver to post a journey.
// Last Modified: 22 July 2023

import 'package:flutter/material.dart';
import 'package:hitchride/src/core/utils.dart';
import 'package:hitchride/src/features/driver/data/model/driver_journey.dart';
import 'package:hitchride/src/features/driver/state/driver_journey_provider.dart';
import 'package:hitchride/src/features/ride/data/model/location_data.dart';
import 'package:hitchride/src/features/ride/data/model/origin_destination.dart';
import 'package:hitchride/src/features/ride/presentation/locations_finalise_screen.dart';
import 'package:hitchride/src/features/ride/state/location_input_provider.dart';
import 'package:hitchride/src/features/shared/presentation/loading_screen.dart';
import 'package:hitchride/src/features/shared/widgets/enlarged_elevated_button.dart';
import 'package:hitchride/src/features/shared/widgets/slide_page_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class PostJourneyScreen extends ConsumerStatefulWidget {
  const PostJourneyScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PostJourneyScreen> createState() => _PostJourneyScreenState();
}

class _PostJourneyScreenState extends ConsumerState<PostJourneyScreen> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  DateTime? _pickupDateTime;
  String? _price;
  int? _radius;

  @override
  void dispose() {
    _isLoading.dispose();
    super.dispose();
  }

  Future<void> postNewJourney() async {
    final locationInput = ref.read(locationInputProvider);
    final driverJourneyRepository = ref.read(driverJourneyRepositoryProvider);
    if (locationInput.pickupPlaceId != null &&
        locationInput.destinationPlaceId != null &&
        _pickupDateTime != null) {
      try {
        _isLoading.value = true;
        await driverJourneyRepository.createDriverJourney(DriverJourney(
          djTimestamp: _pickupDateTime!.millisecondsSinceEpoch,
          djOriginDestination: OriginDestination(
              destination: LocationData(
                  placeId: locationInput.destinationPlaceId!,
                  addressString: locationInput.destinationName!,
                  addressName: locationInput.destinationAddress!),
              origin: LocationData(
                  placeId: locationInput.pickupPlaceId!,
                  addressString: locationInput.pickupName!,
                  addressName: locationInput.pickupAddress!)),
          djDestinationRange: _radius!,
          djPrice: _price!,
        ));
        // refresh the driver upcoming journey provider, so that the new journey is displayed
        ref.invalidate(driverUpcomingDriverJourneyProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Journey posted successfully')));
          Navigator.pop(context);
        }
      } on Exception catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        _isLoading.value = false;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error: Please fill in all fields'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Widget _buildCard(
      {required BuildContext context,
      required Function onTap,
      required String title}) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => onTap(),
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(fontSize: 16),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locationInput = ref.watch(locationInputProvider);

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(SlidePageRoute(
            builder: (context) => const LoadingScreen(), isSlideRight: true));
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              Navigator.of(context).pushReplacement(SlidePageRoute(
                  builder: (context) => const LoadingScreen(),
                  isSlideRight: true));
            },
          ),
          title: const Text('Post a Journey',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildCard(
                  context: context,
                  onTap: () async {
                    Navigator.of(context).push(createSlideTransition(
                        (context) => const LocationsFinaliseScreen(
                              isCurrentLocationHighlighted: true,
                              navigateToRideScreen: false,
                            ),
                        enter: true));
                  },
                  title: locationInput.pickupAddress == null
                      ? 'Tap to select pickup location'
                      : 'Pickup: ${locationInput.pickupAddress}',
                ),
                const SizedBox(height: 20.0),
                _buildCard(
                  context: context,
                  onTap: () async {
                    Navigator.of(context).push(createSlideTransition(
                        (context) => const LocationsFinaliseScreen(
                              navigateToRideScreen: false,
                              isCurrentLocationHighlighted: false,
                            ),
                        enter: true));
                  },
                  title: locationInput.destinationAddress == null
                      ? 'Tap to select destination'
                      : 'Destination: ${locationInput.destinationAddress}',
                ),
                const SizedBox(height: 20.0),
                _buildCard(
                  context: context,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _pickupDateTime ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      if (mounted) {
                        final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(date));
                        if (time != null) {
                          setState(() {
                            _pickupDateTime = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      }
                    }
                  },
                  title: _pickupDateTime == null
                      ? 'Tap to select pickup date and time'
                      : 'Pickup Date and Time: ${DateFormat('yyyy-MM-dd – kk:mm').format(_pickupDateTime!)}',
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    labelText: 'Maximum distance from your destination (km)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (newValue) {
                    _radius = newValue != null ? int.parse(newValue) : null;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a distance';
                    }
                    if (value.contains(RegExp(r'[a-zA-Z]'))) {
                      return 'Please enter a valid distance';
                    }
                    if (int.parse(value) < 0) {
                      return 'Please enter a positive value';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    labelText: 'Enter your asking price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (newValue) {
                    _price = newValue;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (value.contains(RegExp(r'[a-zA-Z]'))) {
                      return 'Please enter a valid price';
                    }
                    if (int.parse(value) < 0) {
                      return 'Please enter a positive value';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: ValueListenableBuilder(
            valueListenable: _isLoading,
            builder: (context, bool isLoading, child) {
              return EnlargedElevatedButton(
                isLoading: isLoading,
                onPressed: isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          await postNewJourney();
                        }
                      },
                text: 'Confirm',
              );
            }),
      ),
    );
  }
}
