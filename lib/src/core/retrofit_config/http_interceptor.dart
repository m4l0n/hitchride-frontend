// Programmer's Name: Ang Ru Xian
// Program Name: http_interceptor.dart
// Description: This is a file that contains the HTTPInterceptor class that is used to intercept HTTP requests and add the Firebase ID token to the header.
// Last Modified: 22 July 2023

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HTTPInterceptor extends Interceptor {

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Get the idToken from Firebase.
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final idToken = await user.getIdToken();
      // Add the Authorization header with the idToken.
      options.headers['Authorization'] = 'Bearer $idToken';
    }
    options.headers['Content-Type'] = 'application/json';

    super.onRequest(options, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    return handler.next(err);
  }

}
