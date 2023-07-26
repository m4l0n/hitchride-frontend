// Programmer's Name: Ang Ru Xian
// Program Name: registration_screen.dart
// Description: This is a file that contains the UI for registration screen.
// Last Modified: 22 July 2023

import 'package:hitchride/src/core/logger_config/logger.dart';
import 'package:hitchride/src/features/account/data/model/user.dart';
import 'package:hitchride/src/features/account/state/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:hitchride/src/features/auth/state/authentication_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();

  static route() => MaterialPageRoute(
        builder: (context) => const RegistrationScreen(),
      );
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  final _logger = getLogger('Registration Screen');
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _isLoading.dispose();
  }

  bool isEmailValid(String email) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> onSignUp() async {
    _isLoading.value = true;
    try {
      _logger.i('Value of _isLoading: ${_isLoading.value}');
      if (_formKey.currentState!.validate()) {
        final auth = ref.read(authenticationProvider);
        final userRepository = ref.read(userRepositoryProvider);
        auth.signUp(
          _emailController.text.trim(),
          _usernameController.text.trim(),
          _passwordController.text.trim(),
          onSuccess: (String uid) async {
            // Show a success message
            final user = HitchRideUser(
                userId: uid,
                userName: _usernameController.text.trim(),
                userEmail: _emailController.text.trim(),
                userPhoneNumber: '',
                userPhotoUrl: '',
                userPoints: 0,
                userDriverInfo: null);
            await userRepository.createProfile(user);
            _isLoading.value = false;
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Registration successful'),
                  duration: Duration(seconds: 1),
                ),
              );
              Navigator.of(context).pop();
            }
          },
          onError: (String errorMessage) {
            _isLoading.value = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(errorMessage), backgroundColor: Colors.red),
            );
          },
        );
      }
    } on Exception catch (e) {
      _isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/hitchride_logo.png',
                      height: 100,
                      width: 100,
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                          filled: false,
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          border: OutlineInputBorder(),
                          hintStyle:
                              TextStyle(fontSize: 16, color: Colors.white)),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!isEmailValid(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _usernameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                          filled: false,
                          labelText: 'Full Name',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          border: OutlineInputBorder(),
                          hintStyle:
                              TextStyle(fontSize: 16, color: Colors.white)),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                          filled: false,
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          border: OutlineInputBorder(),
                          hintStyle:
                              TextStyle(fontSize: 16, color: Colors.white)),
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ValueListenableBuilder<bool>(
                      valueListenable: _isLoading,
                      builder: (context, isLoading, child) => ElevatedButton(
                        onPressed: () async {
                          if (!isLoading) {
                            await onSignUp();
                          } else {
                            null;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.black)
                            : const Text('Sign up'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "Already have an account? ",
                                style: TextStyle(color: Colors.white),
                              ),
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                  color: Colors.yellowAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
