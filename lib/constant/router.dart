import 'package:auth_with_provider/main.dart';
import 'package:auth_with_provider/models/user/user.dart';
import 'package:auth_with_provider/providers/auth_provider.dart';
import 'package:auth_with_provider/screen/create_memo_screen.dart';
import 'package:auth_with_provider/screen/detail_user_screen.dart';
import 'package:auth_with_provider/screen/home_screen.dart';
import 'package:auth_with_provider/screen/sign_in.dart';
import 'package:auth_with_provider/screen/sign_up.dart';
import 'package:auth_with_provider/screen/splash_screen.dart';
import 'package:auth_with_provider/screen/widget/auth_loading_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final router = GoRouter(
  initialLocation: SplashScreen.routeName,
  routes: [
    GoRoute(
      name: 'app',
      path: '/app',
      builder: (context, state) => const App(),
    ),
    GoRoute(
      name: 'sign_in',
      path: '/sign_in',
      builder: (context, state) => const SignIn(),
    ),
    GoRoute(
      name: 'sign_up',
      path: '/sign_up',
      builder: (context, state) => const SignUp(),
    ),
    GoRoute(
        name: 'home',
        path: '/home',
        builder: (context, state) {
          final user = Provider.of<AuthProvider>(context).user;
          return Homescreen(user: user);
        }),
    GoRoute(
      name: 'auth_loading',
      path: '/auth_loading',
      builder: (context, state) => const AuthLoading(),
    ),
    GoRoute(
      name: 'splash',
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      name: 'detail',
      path: '/detail/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final UserModel? user = state.extra as UserModel?;
        return Detail(id: id, user: user);
      },
    ),
    GoRoute(
      name: 'create-memo',
      path: '/create-memo',
      builder: (context, state) => CreateMemoScreen(),
    ),
  ],
);
