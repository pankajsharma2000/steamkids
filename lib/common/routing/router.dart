import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:steamkids/common/presentation/auth/pages/login_page.dart';
import 'package:steamkids/common/presentation/auth/pages/register_page.dart';
import 'package:steamkids/common/presentation/home/pages/home_page.dart';
import 'package:steamkids/common/presentation/home/pages/profile_page.dart';
import 'package:steamkids/common/presentation/home/pages/clubs_page.dart';
import 'package:steamkids/common/presentation/home/pages/search_page.dart';
import 'package:steamkids/common/presentation/home/pages/teams_page.dart';
import 'package:steamkids/common/presentation/home/pages/sessions_page.dart';
import 'package:steamkids/common/presentation/home/pages/wall_page.dart';
import 'package:steamkids/common/presentation/home/pages/my_team_page.dart';
import 'package:steamkids/common/presentation/home/pages/ai_page.dart';
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
                    leading: const Icon(Icons.person),
                    title: const Text('Profile'),
                    onTap: () {
                      context.go('/profile');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.group),
                    title: const Text('Clubs'),
                    onTap: () {
                      context.go('/clubs');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.search),
                    title: const Text('Search'),
                    onTap: () {
                      context.go('/search');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text('Teams'),
                    onTap: () {
                      context.go('/teams');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.event),
                    title: const Text('Sessions'),
                    onTap: () {
                      context.go('/sessions');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.wallpaper),
                    title: const Text('Wall'),
                    onTap: () {
                      context.go('/wall');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.group_work),
                    title: const Text('My Team'),
                    onTap: () {
                      context.go('/my-team');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.smart_toy),
                    title: const Text('AI'),
                    onTap: () {
                      context.go('/ai');
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
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: '/clubs',
            builder: (context, state) => const ClubsPage(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchPage(),
          ),
          GoRoute(
            path: '/teams',
            builder: (context, state) => const TeamsPage(),
          ),
          GoRoute(
            path: '/sessions',
            builder: (context, state) => const SessionsPage(),
          ),
          GoRoute(
            path: '/wall',
            builder: (context, state) => const WallPage(),
          ),
          GoRoute(
            path: '/my-team',
            builder: (context, state) => const MyTeamPage(),
          ),
          GoRoute(
            path: '/ai',
            builder: (context, state) => const AIPage(),
          ),
        ],
      ),
    ],
  );
}