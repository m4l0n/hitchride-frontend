// Programmer's Name: Ang Ru Xian
// Program Name: login_screen.dart
// Description: This is a file that contains the UI for login screen.
// Last Modified: 22 July 2023

import 'package:hitchride/src/core/logger_config/logger.dart';
import 'package:hitchride/src/features/auth/presentation/forgot_password_screen.dart';
import 'package:hitchride/src/features/auth/presentation/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:hitchride/src/features/auth/state/authentication_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  final _logger = getLogger('Login Screen');

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _isLoading.dispose();
  }

  void onLogin() {
    _isLoading.value = true;
    final auth = ref.watch(authenticationProvider);
    auth.signInWithEmailAndPassword(
      context,
      _emailController.text.trim(),
      _passwordController.text.trim(),
      onSuccess: () async {
        // _isLoading.value = false;
      },
      onError: (errorMessage) {
        _logger.e(errorMessage);
        _isLoading.value = false;
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                      hintStyle: TextStyle(fontSize: 16, color: Colors.white)),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
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
                      hintStyle: TextStyle(fontSize: 16, color: Colors.white)),
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                ),
                // const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const ForgotPasswordScreen()));
                      },
                      child: const Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.yellowAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ValueListenableBuilder<bool>(
                  valueListenable: _isLoading,
                  builder: (context, isLoading, child) => ElevatedButton(
                    onPressed: isLoading ? null : onLogin,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.black,
                            backgroundColor: Colors.transparent,
                          )
                        : const Text('Log in'),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RegistrationScreen()));
                    },
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: 'Sign up',
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
    );
  }
}
