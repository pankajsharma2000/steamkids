import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:steamkids/common/presentation/home/pages/home_page.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:go_router/go_router.dart'; // Import GoRouter

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: '41141891810-98tia2rgu16q298tt1sncac6dk5s4ftv.apps.googleusercontent.com',
      );

      // Attempt to sign in silently
      final GoogleSignInAccount? googleUser = await googleSignIn.signInSilently();

      if (googleUser == null) {
        // If silent sign-in fails, fall back to interactive sign-in
        final GoogleSignInAccount? interactiveUser = await googleSignIn.signIn();
        if (interactiveUser == null) {
          // The user canceled the sign-in
          debugPrint('Sign-in canceled by user');
          return;
        }
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Navigate to the HomePage after successful login using GoRouter
      debugPrint('Navigating to HomePage...');
      context.go('/home'); // Replace '/home' with the route name for HomePage in your GoRouter configuration
      debugPrint('Navigation to HomePage complete');
    } catch (e) {
      debugPrint('Error during Google Sign-In: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to STEAM.Kids')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              'assets/images/logo.png', // Replace with your logo's path
              height: 100,
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (kDebugMode) {
                        // Skip sign-in and navigate directly to HomePage in development mode
                        debugPrint('Development mode: Skipping sign-in');
                        debugPrint('Navigating to HomePage...');
                        context.go('/home'); // Replace '/home' with the route name for HomePage in your GoRouter configuration
                        debugPrint('Navigation to HomePage complete');
                      } else {
                        // Perform Google Sign-In in production mode
                        debugPrint('Production mode: Performing Google Sign-In');
                        await _signInWithGoogle(context);
                      }
                    },
                    child: const Text('Login with Google'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}