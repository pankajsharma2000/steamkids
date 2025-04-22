import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:steamkids/common/presentation/auth/pages/login_page.dart';
import 'package:steamkids/common/presentation/auth/pages/register_page.dart';
import 'package:steamkids/common/presentation/home/pages/home_page.dart';
import 'package:steamkids/common/routing/route_names.dart';
import 'package:steamkids/common/presentation/settings/pages/settings_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login', // Set the initial route
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('STEAM Kids'),
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: const Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                    onTap: () {
                      context.go('/home');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                      context.go('/settings');
                    },
                  ),
                ],
              ),
            ),
            body: child, // The child widget for the current route
          );
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
}