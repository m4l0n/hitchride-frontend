// Programmer's Name: Ang Ru Xian
// Program Name: location_suggestions.dart
// Description: This is a file that contains the widget that displays location suggestions.
// Last Modified: 22 July 2023

import 'package:flutter/material.dart';
import 'package:hitchride/src/features/shared/data/model/place_prediction.dart';

class LocationSuggestions extends StatelessWidget {
  final List<PlacePrediction> locationPredictions;
  final Function onTap;

  const LocationSuggestions(
      {Key? key, required this.locationPredictions, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(color: Colors.grey[200]),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
        shrinkWrap: true,
        itemCount: locationPredictions.length,
        itemBuilder: (context, index) {
          final data = locationPredictions[index];
          final locationName = data.mainText;
          final locationAddress = "${data.mainText}, ${data.secondaryText}";
          return InkWell(
              onTap: () => onTap(locationName, locationAddress, data.placeId),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                const CircleAvatar(
                  radius: 13.0,
                  // backgroundColor: Color.fromRGBO(4, 176, 81, 1),
                  child: Icon(Icons.location_on, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10.0),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        locationName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        locationAddress,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ]));
        });
  }
}
