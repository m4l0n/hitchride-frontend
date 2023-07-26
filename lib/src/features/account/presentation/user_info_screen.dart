// Programmer's Name: Ang Ru Xian
// Program Name: user_info_screen.dart
// Description: This is a file that contains the screen that displays the user's information.
// Last Modified: 22 July 2023


import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hitchride/src/auth_gate.dart';
import 'package:hitchride/src/core/logger_config/logger.dart';
import 'package:hitchride/src/features/account/data/model/driver_info.dart';
import 'package:hitchride/src/features/account/data/model/user.dart';
import 'package:hitchride/src/features/account/data/model/user_state.dart';
import 'package:hitchride/src/features/account/presentation/image_confirmation_screen.dart';
import 'package:hitchride/src/features/account/state/user_provider.dart';
import 'package:hitchride/src/features/account/widgets/pageview_dots.dart';
import 'package:hitchride/src/features/account/widgets/user_info_app_bar.dart';
import 'package:hitchride/src/features/account/widgets/user_info_skeleton.dart';
import 'package:hitchride/src/features/auth/state/authentication_provider.dart';
import 'package:hitchride/src/features/shared/widgets/enlarged_elevated_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureNotifier extends StateNotifier<String> {
  ProfilePictureNotifier(String initialState) : super(initialState);

  void updateProfilePicture(String newProfilePictureUrl) {
    state = newProfilePictureUrl;
  }
}

final profilePictureProvider =
    StateNotifierProvider<ProfilePictureNotifier, String>((ref) {
  final userState = ref.watch(cachedUserInfoProvider);
  if (userState is UserData) {
    return ProfilePictureNotifier(userState.user.userPhotoUrl);
  } else {
    return ProfilePictureNotifier('');
  }
});

class BasicInfoSection extends ConsumerStatefulWidget {
  const BasicInfoSection(
      {Key? key, required this.onSaved, required this.userInfo})
      : super(key: key);

  final Function(HitchRideUser, ValueNotifier) onSaved;
  final HitchRideUser userInfo;

  @override
  ConsumerState<BasicInfoSection> createState() => _BasicInfoSectionState();
}

class _BasicInfoSectionState extends ConsumerState<BasicInfoSection> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameFocusNode = FocusNode();
  bool _isEditing = false;
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  bool _isSaveEnabled = false;
  final _mobileNumberFocusNode = FocusNode();
  String? _updatedFullName;

  String? _updatedMobileNumber;

  @override
  void dispose() {
    _fullNameFocusNode.dispose();
    // _emailFocusNode.dispose();
    _mobileNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _fullNameFocusNode.addListener(() {
      setState(() {
        _isEditing = true;
      });
    });
    _mobileNumberFocusNode.addListener(() {
      setState(() {
        _isEditing = true;
      });
    });
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _isEditing = false;
      _isSaveEnabled = false;

      widget.onSaved(
          widget.userInfo.copyWith(
            userName: _updatedFullName!,
            userPhoneNumber: _updatedMobileNumber!,
          ),
          _isLoading);
    }
  }

  @override
  Widget build(BuildContext buildContext) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: TextFormField(
                  onTapOutside: (event) => _fullNameFocusNode.unfocus(),
                  keyboardType: TextInputType.name,
                  onChanged: (value) => setState(() {
                        _isSaveEnabled = true;
                      }),
                  initialValue: widget.userInfo.userName,
                  focusNode: _fullNameFocusNode,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (value) => _updatedFullName = value),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: TextFormField(
                onTapOutside: (event) => _mobileNumberFocusNode.unfocus(),
                keyboardType: TextInputType.phone,
                onChanged: (value) => setState(() {
                  _isSaveEnabled = true;
                }),
                initialValue: widget.userInfo.userPhoneNumber,
                focusNode: _mobileNumberFocusNode,
                // initialValue: userChangeInfo.phone,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number (eg. +60123456789)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mobile number';
                  }
                  RegExp regex =
                      RegExp(r'^\+?([6][0-9]{1}|[0][1-9]{1,2})-?[0-9]{7,9}$');
                  if (!regex.hasMatch(value)) {
                    return 'Please enter a valid mobile number';
                  }
                  return null;
                },
                onSaved: (value) => _updatedMobileNumber = value,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: TextFormField(
                readOnly: true,
                initialValue: widget.userInfo.userEmail,
                // focusNode: _emailFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ValueListenableBuilder(
                valueListenable: _isLoading,
                builder: (context, isLoading, child) {
                  return !_isEditing
                      ? EnlargedElevatedButton(
                          onPressed: () {
                            _fullNameFocusNode.requestFocus();
                            setState(() {
                              _isEditing = true;
                            });
                          },
                          isLoading: isLoading,
                          text: 'Edit')
                      : EnlargedElevatedButton(
                          isLoading: isLoading,
                          onPressed: _isSaveEnabled ? _updateProfile : null,
                          text: 'Save',
                        );
                }),
          ],
        ),
      ),
    );
  }
}

class DriverInfoSection extends ConsumerStatefulWidget {
  const DriverInfoSection(
      {Key? key, required this.onSaved, required this.userDriverInfo})
      : super(key: key);

  final Function(DriverInfo, ValueNotifier) onSaved;
  final DriverInfo userDriverInfo;

  @override
  ConsumerState<DriverInfoSection> createState() => _DriverInfoSectionState();
}

class _DriverInfoSectionState extends ConsumerState<DriverInfoSection> {
  final _carBrandFocusNode = FocusNode();
  final _carColorFocusNode = FocusNode();
  final _carModelFocusNode = FocusNode();
  final _carPlateNumberFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _isCarSecondHand = ValueNotifier<bool?>(null);
  bool _isEditing = false;
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  bool _isSaveEnabled = false;
  final _selectedDate = ValueNotifier<DateTime?>(null);
  String? _updatedCarBrand;
  String? _updatedCarColor;
  String? _updatedCarModel;
  String? _updatedCarPlateNumber;
  DateTime? _updatedDateCarBought;
  bool? _updatedIsCarSecondHand;

  @override
  void dispose() {
    _carBrandFocusNode.dispose();
    _carColorFocusNode.dispose();
    _carModelFocusNode.dispose();
    _carPlateNumberFocusNode.dispose();
    _isCarSecondHand.dispose();
    _selectedDate.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _isCarSecondHand.value = widget.userDriverInfo.diIsCarSecondHand;
    _selectedDate.value = widget.userDriverInfo.diDateCarBoughtTimestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(
            widget.userDriverInfo.diDateCarBoughtTimestamp!)
        : null;

    _carBrandFocusNode.addListener(() {
      setState(() {
        _isEditing = true;
      });
    });
    _carColorFocusNode.addListener(() {
      setState(() {
        _isEditing = true;
      });
    });
    _carModelFocusNode.addListener(() {
      setState(() {
        _isEditing = true;
      });
    });
    _carPlateNumberFocusNode.addListener(() {
      setState(() {
        _isEditing = true;
      });
    });
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _isEditing = false;
      _isSaveEnabled = false;
      widget.onSaved(
          widget.userDriverInfo.copyWith(
            diCarBrand: _updatedCarBrand!,
            diCarModel: _updatedCarModel!,
            diCarColor: _updatedCarColor!,
            diCarLicensePlate: _updatedCarPlateNumber!,
            diIsCarSecondHand: _updatedIsCarSecondHand!,
            diDateCarBought: _updatedDateCarBought!.millisecondsSinceEpoch,
          ),
          _isLoading);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: TextFormField(
              onTapOutside: (event) => _carBrandFocusNode.unfocus(),
              keyboardType: TextInputType.name,
              onChanged: (value) => setState(() {
                _isSaveEnabled = true;
              }),
              initialValue: widget.userDriverInfo.diCarBrand,
              focusNode: _carBrandFocusNode,
              decoration: const InputDecoration(
                labelText: 'Car Brand',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your car brand';
                }
                return null;
              },
              onSaved: (value) => _updatedCarBrand = value,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: TextFormField(
              onTapOutside: (event) => _carModelFocusNode.unfocus(),
              keyboardType: TextInputType.name,
              onChanged: (value) => setState(() {
                _isSaveEnabled = true;
              }),
              initialValue: widget.userDriverInfo.diCarModel,
              focusNode: _carModelFocusNode,
              decoration: const InputDecoration(
                labelText: 'Car Model',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your car model';
                }
                return null;
              },
              onSaved: (value) => _updatedCarModel = value,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: TextFormField(
              onTapOutside: (event) => _carColorFocusNode.unfocus(),
              keyboardType: TextInputType.name,
              onChanged: (value) => setState(() {
                _isSaveEnabled = true;
              }),
              initialValue: widget.userDriverInfo.diCarColor,
              focusNode: _carColorFocusNode,
              decoration: const InputDecoration(
                labelText: 'Car Colour',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your car colour';
                }
                return null;
              },
              onSaved: (value) => _updatedCarColor = value,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: TextFormField(
              onTapOutside: (event) => _carPlateNumberFocusNode.unfocus(),
              keyboardType: TextInputType.name,
              onChanged: (value) => setState(() {
                _isSaveEnabled = true;
              }),
              initialValue: widget.userDriverInfo.diCarLicensePlate,
              focusNode: _carPlateNumberFocusNode,
              decoration: const InputDecoration(
                labelText: 'Car Plate Number',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your car plate number';
                }
                return null;
              },
              onSaved: (value) => _updatedCarPlateNumber = value,
            ),
          ),
          Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<bool>(
                      value: _isCarSecondHand.value,
                      items: const [
                        DropdownMenuItem<bool>(
                          value: true,
                          child: Text('Yes'),
                        ),
                        DropdownMenuItem<bool>(
                          value: false,
                          child: Text('No'),
                        ),
                      ],
                      onChanged: (value) {
                        _isCarSecondHand.value = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Second Hand Car?',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select an option';
                        }
                        return null;
                      },
                      onSaved: (value) => _updatedIsCarSecondHand = value,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ValueListenableBuilder<DateTime?>(
                      valueListenable: _selectedDate,
                      builder: (context, selectedDate, child) => TextFormField(
                        readOnly: true,
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            _selectedDate.value = pickedDate;
                          }
                        },
                        controller: TextEditingController(
                          text: selectedDate != null
                              ? '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}'
                              : '',
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a date';
                          }
                          return null;
                        },
                        onSaved: (value) =>
                            _updatedDateCarBought = _selectedDate.value,
                      ),
                    ),
                  ),
                ],
              )),
          const SizedBox(height: 16.0),
          ValueListenableBuilder(
              valueListenable: _isLoading,
              builder: (context, isLoading, child) {
                return !_isEditing
                    ? EnlargedElevatedButton(
                        isLoading: isLoading,
                        onPressed: () {
                          _carBrandFocusNode.requestFocus();
                          setState(() {
                            _isEditing = true;
                          });
                        },
                        text: 'Edit')
                    : EnlargedElevatedButton(
                        isLoading: isLoading,
                        onPressed: _isSaveEnabled ? _updateProfile : null,
                        text: 'Save',
                      );
              }),
        ]),
      ),
    );
  }
}

class UserInfoScreen extends ConsumerStatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  late final userRepository = ref.watch(userRepositoryProvider);

  int _currentPageIndex = 0;
  final _logger = getLogger("UserInfoScreen");
  late PageController _pageController;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _currentPageIndex);
  }

  void onLogout() {
    final auth = ref.watch(authenticationProvider);
    auth.signOut(onSuccess: () {
      // ProviderScope.containerOf(context)
      //     .getAllProviderElements()
      //     .forEach((element) {
      //   if (element.provider is FutureProvider || element.provider is StateNotifierProvider) {
      //     ProviderScope.containerOf(context).invalidate(element.provider);
      //     ProviderScope.containerOf(context).invalidate(element.origin);
      //     _logger.i('Invalidated ${element.provider.toString()}');
      //   }
      // });
      Navigator.of(context)
          .pushAndRemoveUntil(AuthGate.route(), (route) => false);
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  void _navigateToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<String?> _selectProfilePicture() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    final imageRepository = ref.read(imageRepositoryProvider);

    if (pickedImage != null) {
      final selectedImage = File(pickedImage.path);
      final ValueNotifier<bool> isLoading = ValueNotifier(false);
      if (context.mounted) {
        // Navigate to the image confirmation screen and wait for the result
        final imageUrl = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageConfirmationScreen(
                selectedImage: selectedImage,
                isLoading: isLoading,
                imageRepository: imageRepository),
          ),
        );
        isLoading.dispose();
        _logger.d('Image URL: $imageUrl');
        if (imageUrl != null) {
          return imageUrl;
        }
      }
    }
    return null;
  }

  void _updateProfile(HitchRideUser userInfo, ValueNotifier isLoading) async {
    isLoading.value = true;
    try {
      await userRepository.updateProfileDetails(userInfo);
      // Update the cached user info
      ref.watch(cachedUserInfoProvider.notifier).fetchUser();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Update successful')),
        );
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _updateDriverInfo(
      HitchRideUser userDriverInfo, ValueNotifier isLoading) async {
    isLoading.value = true;
    try {
      await userRepository.updateDriverInfo(userDriverInfo);
      // Update the cached user info
      ref.watch(cachedUserInfoProvider.notifier).fetchUser();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Update successful')),
        );
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    UserState userState = ref.watch(cachedUserInfoProvider);
    final selectedImage = ref.watch(profilePictureProvider);

    if (userState is UserError) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text(userState.message),
        ),
      );
    }

    if (userState is UserLoading) {
      return UserInfoScreenSkeleton(
        height: screenHeight,
      );
    }

    HitchRideUser userInfo = (userState as UserData).user;

    return Scaffold(
      appBar: UserInfoScreenAppBar(
        height: screenHeight,
        width: screenWidth,
        backgroundColor: scaffoldBackgroundColor,
        selectedImage: selectedImage,
        points: userInfo.userPoints,
        selectProfilePicture: () async {
          final imageUrl = await _selectProfilePicture();
          if (imageUrl != null) {
            setState(() {
              ref
                  .read(profilePictureProvider.notifier)
                  .updateProfilePicture(imageUrl);
            });
          }
        },
      ),
      body: Container(
        margin: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: PageView(
                    onPageChanged: _onPageChanged,
                    controller: _pageController,
                    children: [
                      BasicInfoSection(
                        onSaved: (updatedUser, isLoading) async {
                          userInfo = updatedUser;
                          _updateProfile(userInfo, isLoading);
                        },
                        userInfo: userInfo,
                      ),
                      DriverInfoSection(
                          onSaved: (updatedUserDriverInfo, isLoading) async {
                            userInfo = userInfo.copyWith(
                                userDriverInfo: updatedUserDriverInfo);
                            _updateDriverInfo(userInfo, isLoading);
                          },
                          userDriverInfo: userInfo.userDriverInfo!),
                    ]),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PageViewDots(
                    currentPageIndex: _currentPageIndex,
                    position: 0,
                    onTap: () {
                      _navigateToPage(0);
                    }),
                PageViewDots(
                    currentPageIndex: _currentPageIndex,
                    position: 1,
                    onTap: () {
                      _navigateToPage(1);
                    }),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: TextButton(
          onPressed: onLogout,
          child: const Text('Log Out',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
