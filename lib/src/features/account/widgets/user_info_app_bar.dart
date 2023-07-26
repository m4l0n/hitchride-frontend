// Programmer's Name: Ang Ru Xian
// Program Name: user_info_app_bar.dart
// Description: This is a file that contains a custom app bar for the user info screen.
// Last Modified: 22 July 2023

import 'package:flutter/material.dart';
import 'package:hitchride/src/features/shared/widgets/custom_icons.dart';

class UserInfoScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const UserInfoScreenAppBar(
      {super.key,
      required this.height,
      required this.width,
      required this.backgroundColor,
      required this.selectedImage,
      required this.selectProfilePicture, required this.points});

  final Color backgroundColor;
  final double height;
  final VoidCallback selectProfilePicture;
  final String? selectedImage;
  final double width;
  final int points;

  @override
  Size get preferredSize => Size.fromHeight(height / 4);

  @override
  Widget build(BuildContext context) {
    const profileIconSize = 70.0;

    return AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: SafeArea(
          child: Stack(
            children: [
              Container(
                height: preferredSize.height / 2,
                color: Colors.grey,
              ),
              Positioned(
                //Position at the centre of the app bar, both horizontally and vertically
                top: preferredSize.height / 2 - profileIconSize / 2,
                left: width / 2 - profileIconSize / 2,
                child: InkWell(
                  onTap: selectProfilePicture,
                  child: CircleAvatar(
                    radius: profileIconSize / 2,
                    backgroundImage:
                        selectedImage != null && selectedImage != ''
                            ? NetworkImage(selectedImage!)
                            : null,
                    child: selectedImage == null
                        ? const Icon(
                            CustomIcons.userCircle,
                            size: profileIconSize - 8,
                          ) // Show default icon
                        : null, //to show the borders of the icon itself
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: preferredSize.height / 2),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$points Points',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13.0,
                          ),
                        ),
                        const Icon(Icons.navigate_next, size: 13.0),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
