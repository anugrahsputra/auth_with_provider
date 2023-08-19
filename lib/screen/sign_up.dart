import 'package:auth_with_provider/providers/auth_provider.dart';
import 'package:auth_with_provider/screen/widget/video_player_widge.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widget/custom_formfield_widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  static const routeName = '/sign_up';

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final RegExp emailValidatorRegExp =
      RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  bool passwordVisible = false;
  bool confrimPasswordVisible = false;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    confrimPasswordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SizedBox(
              height: Get.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 30),
                      height: Get.height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create a new account',
                            style: GoogleFonts.lora(
                              fontSize: 50,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Login',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      context.pop();
                                    },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    CustomFormfield(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.name,
                      labelText: 'Name',
                      prefixIcon: const Icon(Icons.person_outlined),
                      hintText: 'Enter your name',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    CustomFormfield(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        } else if (!emailValidatorRegExp.hasMatch(value)) {
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
                    CustomFormfield(
                      controller: _confirmPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      prefixIcon: const Icon(Icons.lock_outlined),
                      labelText: 'Re-Enter Password',
                      hintText: 'Re-Enter your password',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        } else if (_passwordController.text != value) {
                          return 'Password does not match';
                        }
                        return null;
                      },
                      obscureText: confrimPasswordVisible,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            confrimPasswordVisible = !confrimPasswordVisible;
                          });
                        },
                        icon: Icon(
                          confrimPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value!;
                              });
                            }),
                        Text.rich(
                          TextSpan(
                            text: 'I agree to the ',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: 'Terms of Service',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    urlLauncher(Uri.parse(
                                        'https://www.youtube.com/watch?v=dQw4w9WgXcQ'));
                                  },
                              ),
                              const TextSpan(
                                text: ' and ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context)
                                        .restorablePush(_dialogBuilder);
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    FilledButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize: Size(Get.width, 20),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (isChecked) {
                            authProvider.signUpUser(
                              email: _emailController.text,
                              password: _passwordController.text,
                              name: _nameController.text,
                            );
                            authProvider.refreshUser();
                            context.go('/home');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please agree to the terms and conditions',
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        }
                      },
                      child: authProvider.loading
                          ? const CircularProgressIndicator()
                          : const Text('Sign Up'),
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

  urlLauncher(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @pragma('vm:entry-point')
  static Route<Object?> _dialogBuilder(
      BuildContext context, Object? arguments) {
    return DialogRoute(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Really? Twice?'),
          content: const VideoPlayerWidget(),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Oh fuck off'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Very funny'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
