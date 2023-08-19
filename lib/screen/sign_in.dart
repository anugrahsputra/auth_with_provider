import 'package:auth_with_provider/providers/auth_provider.dart';
import 'package:auth_with_provider/screen/widget/auth_loading_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'widget/custom_formfield_widget.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);
  static const String routeName = '/sign_in';

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RegExp emailValidatorRegExp =
      RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SizedBox(
              height: Get.height,
              child: authProvider.loading
                  ? const AuthLoading()
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: Get.height * 0.4,
                            padding: const EdgeInsets.only(bottom: 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Login to your account',
                                  style: GoogleFonts.lora(
                                    fontSize: 50,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Or ',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'create a new account ',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: Colors.teal,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            context.goNamed('sign_up');
                                          },
                                      ),
                                      TextSpan(
                                        text: 'if you don\'t have one',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomFormfield(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(Icons.email_outlined),
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your email';
                              } else if (!emailValidatorRegExp
                                  .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          CustomFormfield(
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            prefixIcon: const Icon(Icons.lock_outlined),
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            obscureText: passwordVisible,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your password';
                              } else if (value.length < 6) {
                                return 'Password should be at least 6 characters';
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                              icon: Icon(
                                passwordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                authProvider.loginUser(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );
                              }
                            },
                            child: authProvider.loading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Lottie.asset(
                                      'assets/lottie/loading.json',
                                      height: 20,
                                      width: 20,
                                    ),
                                  )
                                : const Text('Login'),
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
