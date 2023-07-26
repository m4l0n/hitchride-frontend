// Programmer's Name: Ang Ru Xian
// Program Name: utils.dart
// Description: This is a file that contains the utility functions.
// Last Modified: 22 July 2023

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hitchride/src/core/logger_config/logger.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

final _logger = getLogger("Utils");
String getNewSessionToken() {
  return const Uuid().v4();
}

/// Creates a [PageRouteBuilder] that slides the new page in from the left or right.
PageRouteBuilder createSlideTransition(WidgetBuilder builder,
    {required bool enter, RouteSettings? settings}) {
  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final begin = enter ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      final tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

void openWhatsapp(
    {required BuildContext context, required String number}) async {
  var whatsapp = number; //+92xx enter like this
  var whatsappURlAndroid = "whatsapp://send?phone=$whatsapp";
  var whatsappURLIos = "https://wa.me/$whatsapp";
  if (Platform.isIOS) {
    // for iOS phone only
    if (await canLaunchUrl(Uri.parse(whatsappURLIos))) {
      await launchUrl(Uri.parse(
        whatsappURLIos,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Whatsapp not installed")));
    }
  } else {
    // android , web
    if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
      await launchUrl(Uri.parse(whatsappURlAndroid));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Whatsapp not installed")));
    }
  }
}

String formatTimestamp(int timestamp) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return DateFormat('dd MMM yyyy, hh:mm a').format(date);
}
