// Programmer's Name: Ang Ru Xian
// Program Name: home_page.dart
// Description: This is a file that contains the widget for the home page for the navbar and displaying the different pages depending on the navbar index.
// Last Modified: 22 July 2023

import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hitchride/src/features/account/state/fcm_provider.dart';
import 'package:hitchride/src/features/shared/widgets/animated_navbar.dart';
import 'package:hitchride/src/features/shared/widgets/custom_icons.dart';
import 'package:hitchride/src/features/account/presentation/profile_screen.dart';
import 'package:hitchride/src/features/driver/presentation/driver_board.dart';
import 'package:hitchride/src/features/ride/presentation/main_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  double gap = 10;
  // final _logger = getLogger('Home Page');
  final _buildBody = const <Widget>[
    MainScreen(),
    DriverBoard(),
    ProfileScreen()
  ];
  final List<MenuItem> menuItems = [
    const MenuItem(CustomIcons.carAlt, 'Find a Ride'),
    const MenuItem(CustomIcons.steeringWheel, "Driver's Board"),
    const MenuItem(CustomIcons.userCircle, 'Account')
  ];

  @override
  void initState() {
    super.initState();
    registerFCMToken();
  }

  
  void registerFCMToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    User? user = FirebaseAuth.instance.currentUser;
    final fcmApiClient = ref.read(fcmApiClientProvider);

    if (user != null) {
      String? token = await messaging.getToken();
      if (token != null) {
        await fcmApiClient.registerFCMToken(token);
      }
      //register callback for token refresh
      messaging.onTokenRefresh.listen((newToken) async {
        await fcmApiClient.registerFCMToken(newToken);
      });
    }
  }


  void _onItemTapped(int index) {
    ref.read(navbarNotifierProvider).index = index;
  }

  @override
  Widget build(BuildContext context) {
    final navbarNotifier = ref.watch(navbarNotifierProvider);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        appBar: null,
        body: PageTransitionSwitcher(
            transitionBuilder: (
              Widget child,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                child: child
              );
            },
            child: _buildBody[navbarNotifier.index]
        ),
        bottomNavigationBar: AnimatedBuilder(
          animation: navbarNotifier,
          builder: (context, child) {
            return AnimatedNavBar(
              onItemTapped: _onItemTapped,
              menuItems: menuItems,
              model: navbarNotifier,
            );
          },
        ));
  }
}
