// Programmer's Name: Ang Ru Xian
// Program Name: forgot_password_screen.dart
// Description: This is a file that contains the UI for the forgot password screen.
// Last Modified: 22 July 2023

import 'package:flutter/material.dart';
import 'package:hitchride/src/features/auth/state/authentication_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _emailController.dispose();
    _isLoading.dispose();
    super.dispose();
  }

  void _resetPassword() {
    final email = _emailController.text.trim();
    if (email.isNotEmpty) {
      _isLoading.value = true;
      final authProvider = ref.read(authenticationProvider);
      authProvider.resetPassword(email, onSuccess: () {
        _isLoading.value = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reset password email sent. Please check your email.'),
          ),
        );
      }, onError: (error) {
        _isLoading.value = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your email';
                      }
                      final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!regex.hasMatch(value!)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
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
                  ),
                  const SizedBox(height: 20.0),
                  ValueListenableBuilder<bool>(
                        valueListenable: _isLoading,
                        builder: (context, isLoading, child) => ElevatedButton(
                          onPressed: isLoading ? null : _resetPassword,
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
                              : const Text('Reset Password'),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
