import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AuthLoading extends StatelessWidget {
  const AuthLoading({super.key});
  static const String routeName = '/auth_loading';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/globeee.json',
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      ),
    );
  }
}
