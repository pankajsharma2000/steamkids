import 'package:go_router/go_router.dart';
import 'package:steamkids/common/presentation/home/pages/home_page.dart';
import 'package:steamkids/common/presentation/auth/pages/login_page.dart';
import 'package:steamkids/common/routing/route_names.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login', // Set the initial route
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}