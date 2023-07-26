// Programmer's Name: Ang Ru Xian
// Program Name: animated_navbar.dart
// Description: This is a file that contains the widget for the animated navbar.
// Last Modified: 22 July 2023

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Create a ChangeNotifierProvider for the navbar
final navbarNotifierProvider = ChangeNotifierProvider.autoDispose<NavbarNotifier>((ref) {
  return NavbarNotifier();
});

// Create a class to manage the navbar state
class NavbarNotifier extends ChangeNotifier {
  int _index = 0;
  int get index => _index;
  bool _hideBottomNavBar = false;

  set index(int x) {
    _index = x;
    notifyListeners();
  }

  bool get hideBottomNavBar => _hideBottomNavBar;
  set hideBottomNavBar(bool x) {
    _hideBottomNavBar = x;
    notifyListeners();
  }
}

// Define a class for the menu items
class MenuItem {
  const MenuItem(this.iconData, this.label);
  final IconData iconData;
  final String label;
}

// Create the AnimatedNavBar widget
class AnimatedNavBar extends ConsumerStatefulWidget {
  const AnimatedNavBar(
      {Key? key,
      required this.model,
      required this.menuItems,
      required this.onItemTapped})
      : super(key: key);
  final List<MenuItem> menuItems;
  final NavbarNotifier model;
  final Function(int) onItemTapped;

  @override
  ConsumerState<AnimatedNavBar> createState() => _AnimatedNavBarState();
}

// Define the state for the AnimatedNavBar widget
class _AnimatedNavBarState extends ConsumerState<AnimatedNavBar>
    with SingleTickerProviderStateMixin {
  // Update the widget when the navbar visibility changes
  @override
  void didUpdateWidget(covariant AnimatedNavBar oldWidget) {
    if (widget.model.hideBottomNavBar != isHidden) {
      if (!isHidden) {
        _showBottomNavBar();
      } else {
        _hideBottomNavBar();
      }
      isHidden = !isHidden;
    }
    super.didUpdateWidget(oldWidget);
  }

  // Hide the navbar
  void _hideBottomNavBar() {
    _controller.reverse();
    return;
  }

  // Show the navbar
  void _showBottomNavBar() {
    _controller.forward();
    return;
  }

  @override
  void initState() {
    super.initState();
    // Create an animation controller
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this)
      ..addListener(() => setState(() {}));
    animation = Tween(begin: 0.0, end: 100.0).animate(_controller);
  }

  late AnimationController _controller;
  late Animation<double> animation;
  bool isHidden = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          return Transform.translate(
              offset: Offset(0, animation.value),
              child: SafeArea(
                  child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: -10,
                      blurRadius: 60,
                      color: Colors.black.withOpacity(.4),
                      offset: const Offset(0, 25),
                    )
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: GNav(
                    rippleColor: Colors.grey[300]!,
                    hoverColor: Colors.grey[100]!,
                    gap: 8,
                    activeColor: Colors.black,
                    iconSize: 24,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    duration: const Duration(milliseconds: 400),
                    tabBackgroundColor: Colors.grey[100]!,
                    tabActiveBorder: Border.all(color: Colors.black, width: 1),
                    color: Colors.black,
                    tabs: widget.menuItems
                        .map((MenuItem menuItem) => GButton(
                            icon: menuItem.iconData, text: menuItem.label))
                        .toList(),
                    selectedIndex: widget.model.index,
                    onTabChange: (x) {
                      widget.onItemTapped(x);
                    },
                  ),
                ),
              )));
        });
  }
}