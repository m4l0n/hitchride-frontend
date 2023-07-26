// Programmer's Name: Ang Ru Xian
// Program Name: authentication.dart
// Description: This is a file that contains the repository class for authentication related functions.
// Last Modified: 22 July 2023

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hitchride/src/core/api_response.dart';
import 'package:hitchride/src/core/logger_config/logger.dart';


class Authentication {
  final _auth = FirebaseAuth.instance;
  final _logger = getLogger('Authentication');

  Future<User?> signInWithEmailAndPassword(
    BuildContext context,
    String email,
    String password, {
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _logger.i('Login success, current user: ${_auth.currentUser!.uid}');

      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e.message ?? 'An error occurred. Please try again.');
    }
    return null;
  }

  Future<void> signUp(
    String email,
    String username,
    String password, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    try {
      // Create a new user with the provided email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save the username to the user's Firestore document
      await userCredential.user!.updateDisplayName(username);
      onSuccess(userCredential.user!.uid);
    } on Exception catch (e) {
      // Handle Firebase Authentication exceptions
      String errorMessage = 'An error occurred. Please try again.';
      if (e is FirebaseAuthException) {
        if (e.code == 'weak-password') {
          errorMessage = 'The password is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'The email address is already in use.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is invalid.';
        }
      } else if (e is DioException) {
        ApiResponse response =
            ApiResponse.fromJson(e.response!.data, (json) => json);
        errorMessage = response.message;
      }
      onError(errorMessage);
    } catch (e) {
      onError('An error occurred. Please try again.');
    }
  }

  Future<void> resetPassword(String email, {
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      
      onSuccess();
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred. Please try again.';
      if (e.code == 'invalid-email') {
        errorMessage = 'The email address is invalid.';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email.';
      } 
      onError(errorMessage);
    } catch (e) {
      onError('An error occurred. Please try again.');
    }
  }

  void signOut({required Function onSuccess}) async {
    await _auth.signOut();
    onSuccess();
  }

}
