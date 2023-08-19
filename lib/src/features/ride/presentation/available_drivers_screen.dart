// Programmer's Name: Ang Ru Xian
// Program Name: available_drivers_screen.dart
// Description: This is a file that contains the screen that displays the available drivers.
// Last Modified: 22 July 2023

import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:hitchride/src/features/ride/data/model/location_input.dart';
import 'package:hitchride/src/features/ride/state/location_input_provider.dart';
import 'package:hitchride/src/features/ride/data/model/location_data.dart';
import 'package:hitchride/src/features/ride/data/model/ride.dart';
import 'package:hitchride/src/features/driver/data/model/driver_journey.dart';
import 'package:hitchride/src/features/ride/state/rides_provider.dart';
import 'package:hitchride/src/features/ride/data/model/origin_destination.dart';
import 'package:hitchride/src/features/ride/data/model/search_ride_criteria.dart';
import 'package:hitchride/src/features/ride/widget/driver_journey_bottomsheet.dart';
import 'package:hitchride/src/features/ride/widget/driver_journey_card.dart';
import 'package:hitchride/src/features/shared/presentation/loading_screen.dart';
import 'package:hitchride/src/features/shared/widgets/slide_page_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class AvailableDriversScreen extends ConsumerStatefulWidget {
  const AvailableDriversScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AvailableDriversScreen> createState() =>
      _AvailableDriversScreenState();
}

TimeOfDay getClosestIntervalTime({int interval = 15}) {
  final now = DateTime.now();
  int minutes = ((now.minute + interval - 1) ~/ interval) * interval;

  if (minutes == 60) {
    return TimeOfDay(
      hour: now.hour + 1,
      minute: 0,
    );
  } else {
    return TimeOfDay(
      hour: now.hour,
      minute: minutes,
    );
  }
}

void refreshLocationInput(WidgetRef ref) {
  //manually refreshing location input provider, instead of calling refresh(), since
  //data is populated via init()
  ref.invalidate(locationInputProvider);
  ref.read(locationInputProvider.notifier).init();
}

class _AvailableDriversScreenState
    extends ConsumerState<AvailableDriversScreen> {
  //For comparison purposes
  final closestTime = getClosestIntervalTime();

  final TextEditingController _dateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  //Initialise value to current closest time
  TimeOfDay _selectedTime = getClosestIntervalTime();

  final TextEditingController _timeController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat.yMMMEd().format(_selectedDate);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timeController.text = _selectedTime.format(context);
    });
  }

  Widget _buildDateTimeFilter(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 8.0, top: 20.0, bottom: 20.0),
            child: TextField(
              readOnly: true,
              controller: _dateController,
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.calendar_today),
                labelStyle: const TextStyle(fontSize: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onTap: () async {
                final pickedDate =
                    await DatePicker.showSimpleDatePicker(context,
                        initialDate: DateTime(
                          _selectedDate.year,
                          _selectedDate.month,
                          _selectedDate.day,
                        ),
                        firstDate: DateTime(
                          _selectedDate.year,
                          _selectedDate.month,
                          _selectedDate.day,
                        ),
                        lastDate: DateTime.now().add(const Duration(days: 7)),
                        locale: DateTimePickerLocale.en_us,
                        dateFormat: "dd-MMMM-yyyy",
                        looping: true);
                if (pickedDate != null) {
                  final newDate = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                  );
                  if (newDate != _selectedDate) {
                    setState(() {
                      _selectedDate = newDate;
                      _dateController.text =
                          DateFormat.yMMMEd().format(_selectedDate);
                    });
                  }
                }
              },
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding:
                const EdgeInsets.only(right: 16.0, top: 20.0, bottom: 20.0),
            child: TextField(
              readOnly: true,
              controller: _timeController,
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.access_time),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onTap: () async {
                Navigator.of(context).push(
                  showPicker(
                    context: context,
                    value: Time(
                      hour: _selectedTime.hour,
                      minute: _selectedTime.minute,
                    ),
                    minHour: 0,
                    minuteInterval: TimePickerInterval.FIFTEEN,
                    focusMinutePicker: true,
                    onChange: (value) {
                      final time =
                          TimeOfDay(hour: value.hour, minute: value.minute);
                      //If selected time is before current closest time, set to current closest time
                      if (time.hour < closestTime.hour) {
                        if (time.minute < closestTime.minute) {
                          time.replacing(
                            hour: closestTime.hour,
                            minute: closestTime.minute,
                          );
                        }
                      }
                      setState(() {
                        _selectedTime = time;
                        _timeController.text = _selectedTime.format(context);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }

  void _showDriverJourneyDetails(
      BuildContext context, DriverJourney driverJourney) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      context: context,
      builder: (context) {
        return DriverJourneyBottomSheet(
          driverJourney: driverJourney,
          onAcceptRide: (DriverJourney driverJourney) {
            _acceptRide(
              driverJourney.djOriginDestination.origin.placeId,
              driverJourney.djOriginDestination.destination.placeId,
              driverJourney,
            );
          },
        );
      },
    );
  }

  void _acceptRide(
      String origin, String destination, DriverJourney driverJourney) async {
    LocationInput locationInput = ref.read(locationInputProvider);
    final ride = Ride(
        rideOriginDestination: OriginDestination(
          origin: LocationData(
            placeId: locationInput.pickupPlaceId!,
            addressName: '',
            addressString: '',
          ),
          destination: LocationData(
            placeId: locationInput.destinationPlaceId!,
            addressName: '',
            addressString: '',
          ),
        ),
        rideDriverJourney: driverJourney);
    try {
      final rideRepository = ref.read(rideRepositoryProvider);
      await rideRepository.bookRide(ride);
      // Refresh user upcoming rides
      ref.invalidate(userUpcomingRidesProvider);
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have booked a ride!'),
          ),
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationInput = ref.watch(locationInputProvider);
    final selectedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    final availableDriversAsyncValue = ref.watch(availableRidesProvider(
        SearchRideCriteria(
            searchRideLocationCriteria: OriginDestination(
                destination: LocationData(
                    placeId: locationInput.destinationPlaceId!,
                    addressName: '',
                    addressString: ''),
                origin: LocationData(
                    placeId: locationInput.pickupPlaceId!,
                    addressName: '',
                    addressString: '')),
            searchRideTimestampCriteria:
                selectedDateTime.millisecondsSinceEpoch)));

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(SlidePageRoute(
            builder: (context) => const LoadingScreen(), isSlideRight: true));
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              // Reset location input
              Navigator.of(context).pushReplacement(SlidePageRoute(
                  builder: (context) => const LoadingScreen(),
                  isSlideRight: true));
            },
          ),
          automaticallyImplyLeading: false,
          title: const Text(
            'Available Drivers',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateTimeFilter(context),
            const SizedBox(height: 16.0),
            Expanded(
              child: availableDriversAsyncValue.when(
                data: (driverJourneys) {
                  return driverJourneys.isEmpty
                      ? Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 80),
                            Image.asset(
                              'assets/images/marginalia.png',
                              height: 250,
                              width: 250,
                            ),
                            const SizedBox(height: 24),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "There are no available rides at the moment. Try changing your search criteria, or try again later.",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ))
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: driverJourneys.length,
                            itemBuilder: (context, index) {
                              return DriverJourneyCard(
                                driverJourney: driverJourneys[index],
                                onTap: () => _showDriverJourneyDetails(
                                  context,
                                  driverJourneys[index],
                                ),
                              );
                            },
                          ),
                        );
                },
                error: (error, stackTrace) {
                  return Center(child: Text('Error: $error'));
                },
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
