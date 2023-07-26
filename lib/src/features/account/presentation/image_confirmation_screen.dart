// Programmer's Name: Ang Ru Xian
// Program Name: image_confirmation_screen.dart
// Description: This is a file that contains the screen for image confirmation when user uploads a profile picture.
// Last Modified: 22 July 2023

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hitchride/src/core/api_response.dart';
import 'package:hitchride/src/features/account/data/repository/image_repository.dart';
import 'package:hitchride/src/features/shared/widgets/enlarged_elevated_button.dart';

class ImageConfirmationScreen extends StatelessWidget {
  const ImageConfirmationScreen(
      {super.key,
      required this.selectedImage,
      required ValueNotifier<bool> isLoading,
      required this.imageRepository})
      : _isLoadingNotifier = isLoading;

  final ImageRepository imageRepository;
  final File selectedImage;

  final ValueNotifier<bool> _isLoadingNotifier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Image Confirmation',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Image.file(selectedImage),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
        bottomNavigationBar: ValueListenableBuilder(
            valueListenable: _isLoadingNotifier,
            builder: (context, bool isLoading, child) => EnlargedElevatedButton(
                  isLoading: isLoading,
                  onPressed: () async {
                    _isLoadingNotifier.value = true;
                    ApiResponse<String> response =
                        await imageRepository.uploadImage(selectedImage);
                    _isLoadingNotifier.value = false;
                    // Navigate back to UserInfoScreen and pass the image URL
                    if (context.mounted) {
                      if (response.statusCode == 'OK') {
                        Navigator.pop(context, response.result);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(response.message),
                          ),
                        );
                      }
                    }
                  },
                  text: 'Confirm',
                )));
  }
}
