import 'package:auth_with_provider/main.dart';
import 'package:auth_with_provider/providers/auth_provider.dart';
import 'package:auth_with_provider/screen/home_screen.dart';
import 'package:auth_with_provider/screen/sign_in.dart';
import 'package:auth_with_provider/screen/sign_up.dart';
import 'package:auth_with_provider/screen/widget/auth_loading_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'app',
      path: App.routeName,
      builder: (context, state) => const App(),
    ),
    GoRoute(
      name: 'sign_in',
      path: SignIn.routeName,
      builder: (context, state) => const SignIn(),
    ),
    GoRoute(
      name: 'sign_up',
      path: SignUp.routeName,
      builder: (context, state) => const SignUp(),
    ),
    GoRoute(
      name: 'home',
      path: Homescreen.routeName,
      builder: (context, state) =>
          Homescreen(user: Provider.of<AuthProvider>(context).user),
    ),
    GoRoute(
      name: 'auth_loading',
      path: AuthLoading.routeName,
      builder: (context, state) => const AuthLoading(),
    ),
  ],
);
