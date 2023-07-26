// Programmer's Name: Ang Ru Xian
// Program Name: user_api.dart
// Description: This is a file that contains the methods to call the API for user related functions.

import 'package:dio/dio.dart';
import 'package:hitchride/src/core/api_response.dart';
import 'package:hitchride/src/features/account/data/model/user.dart';
import 'package:retrofit/http.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserApiClient {
  factory UserApiClient(Dio dio, {String? baseUrl}) = _UserApiClient;

  @GET('/users/me')
  Future<ApiResponse<HitchRideUser>> getProfileDetails();

  @POST('/users/update')
  Future<ApiResponse<HitchRideUser>> updateProfileDetails(@Body() HitchRideUser user);

  @POST('/users/create')
  Future<ApiResponse<HitchRideUser>> createProfile(@Body() HitchRideUser user);

  @POST('/users/updateDriverInfo')
  Future<ApiResponse<HitchRideUser>> updateDriverInfo(@Body() HitchRideUser user);
}
