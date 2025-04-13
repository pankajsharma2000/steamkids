import 'package:go_router/go_router.dart';
import 'package:steamkids/common/presentation/auth/pages/login_page.dart';
import 'package:steamkids/common/routing/route_names.dart';

class AppRouter {
  static GoRouter config = GoRouter(
    initialLocation: '/auth',
    routes: [
      GoRoute(
        path: '/auth', 
        name: RouteNames.loginPage.name,
        builder: (context, state) => const LoginPage(),
      ),
    ]);
/*   static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String about = '/about';
  static const String contact = '/contact'; */
}