// Programmer's Name: Ang Ru Xian
// Program Name: google_maps_api_client.dart
// Description: This is a file that contains the api client for google maps api.
// Last Modified: 22 July 2023

import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:hitchride/src/constants/api_constants.dart';
import 'package:hitchride/src/core/logger_config/logger.dart';
import 'package:hitchride/src/features/ride/data/model/location_data.dart';
import 'package:hitchride/src/features/shared/data/model/lat_lng.dart';
import 'package:hitchride/src/features/shared/data/model/nearby_place.dart';
import 'package:hitchride/src/features/shared/data/model/place_details.dart';
import 'package:hitchride/src/features/shared/data/model/place_prediction.dart';
import 'package:http/http.dart' as http;

class GoogleMapsApiClient {
  final apiKey = ApiConstants.GOOGLE_API_KEY;
  final googleMapsBaseUrl = ApiConstants.GOOGLE_MAPS_BASE_URL;
  final _logger = getLogger('GoogleMapsApiClient');

  Future<LocationData> getCurrentLocationAddress() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Location service is disabled');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    final locationInput =
        LatLng(lat: position.latitude, lng: position.longitude);
    final addressData = await getLocationDataFromLatLng(locationInput);
    return addressData;
  }

  Future<LocationData> getLocationDataFromLatLng(LatLng latLng) async {
    final addressData = await getAddressFromLatLng(latLng);
    final addressDetails = await getPlaceDetails(addressData['placeId']!);
    return LocationData(
        placeId: addressData['placeId']!,
        addressCoordinates: latLng,
        addressString: addressData['address']!,
        addressName: addressDetails.name);
  }

  Future<Map<String, String>> getAddressFromLatLng(LatLng latLng) async {
    final url =
        '$googleMapsBaseUrl/geocode/json?latlng=${latLng.lat},${latLng.lng}&key=$apiKey&language=en&region=my&location_type=ROOFTOP';
    _logger.i('Getting address from latlng: $latLng with url: $url');

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'];
      if (results.isNotEmpty) {
        final address = results[0]['formatted_address'] as String;
        final placeId = results[0]['place_id'] as String;
        return {'address': address, 'placeId': placeId};
      } else {
        final retryUrl =
            '$googleMapsBaseUrl/geocode/json?latlng=${latLng.lat},${latLng.lng}&key=$apiKey&language=en&region=my';
        _logger.i('Retrying with url: $retryUrl');
        final retryResponse = await http.get(Uri.parse(retryUrl));
        if (retryResponse.statusCode == 200) {
          final data = jsonDecode(retryResponse.body);
          final results = data['results'];
          if (results.isNotEmpty) {
            final address = results[0]['formatted_address'] as String;
            final placeId = results[0]['place_id'] as String;
            return {'address': address, 'placeId': placeId};
          }
        }
      }
    }
    throw Exception(
        'Failed to get address from latlng: $latLng, Exception message: ${response.body}');
  }

  Future<List<PlacePrediction>> getAutocompleteResults(
      String input, LatLng latLng, {String? sessionToken}) async {
    final String baseUrl = '$googleMapsBaseUrl/place/autocomplete/json';
    String url =
        '$baseUrl?input=$input&components=country:my&location=${latLng.lat},${latLng.lng}&radius=100&language=en&region=my&key=$apiKey';
    if (sessionToken != null) {
      url += '&sessiontoken=$sessionToken';
    }
    _logger.i('Getting autocomplete results with url: $url');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<PlacePrediction> predictions = List<PlacePrediction>.from(
          jsonResponse['predictions'].map((prediction) => PlacePrediction(
              placeId: prediction['place_id'],
              mainText: prediction['structured_formatting']['main_text'],
              secondaryText: prediction['structured_formatting']
                  ['secondary_text'])));
      return predictions;
    } else {
      throw Exception('Failed to get autocomplete results');
    }
  }

  Future<PlaceDetails> getPlaceDetails(String placeId,
      {String? sessionToken}) async {
    final String baseUrl = '$googleMapsBaseUrl/place/details/json';
    String url =
        '$baseUrl?place_id=$placeId&fields=formatted_address,geometry,name&key=$apiKey';
    if (sessionToken != null) {
      url += '&sessiontoken=$sessionToken';
    }
    _logger.i('Getting place details with url: $url');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final Map<String, dynamic> result = jsonResponse['result'];
      final String name = result['name'];
      final String formattedAddress = result['formatted_address'];
      final double lat = result['geometry']['location']['lat'];
      final double lng = result['geometry']['location']['lng'];
      return PlaceDetails(
          placeId: placeId,
          name: name,
          formattedAddress: formattedAddress,
          latLng: LatLng(lat: lat, lng: lng));
    } else {
      throw Exception('Failed to get place details');
    }
  }

  Future<List<NearbyPlace>> getNearbyPlaces(
      LatLng latLng, int numResults) async {
    final String baseUrl = '$googleMapsBaseUrl/place/nearbysearch/json';
    final String url =
        '$baseUrl?location=${latLng.lat},${latLng.lng}&radius=100&language=en&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> results = jsonResponse['results'];
      if (results.isEmpty) {
        return [];
      }
      final List<NearbyPlace> places = results
          //filter out the unwanted results
          .where((result) =>
              !result['types'].contains('locality') &&
              !result['types'].contains('political') &&
              !result['types'].contains('administrative_area_level_1') &&
              !result['types'].contains('route'))
          .map((result) => NearbyPlace(
              placeId: result['place_id'],
              name: result['name'],
              formattedAddress: result['vicinity'],
              latLng: LatLng(
                  lat: result['geometry']['location']['lat'],
                  lng: result['geometry']['location']['lng'])))
          .toList();
      return places.length > numResults
          ? places.sublist(0, numResults)
          : places;
    } else {
      throw Exception('Failed to get nearby places');
    }
  }
}
