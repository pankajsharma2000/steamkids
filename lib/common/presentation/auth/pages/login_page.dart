import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamkids/common/providers/auth_provider.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    Future<void> signInWithEmailAndPassword() async {
      try {
        final String email = emailController.text.trim();
        final String password = passwordController.text.trim();

        if (email.isEmpty || password.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email and password cannot be empty')),
          );
          return;
        }

        // Sign in with email and password
        await ref.read(authProvider).signInWithEmailAndPassword(email, password);

        // Navigate to HomePage after successful login using GoRouter
        context.go('/home'); // Use the route name defined in your GoRouter configuration
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect password. Please try again.')),
          );
        } else if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No user found with this email.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.message}')),
          );
        }
      } catch (e) {
        debugPrint('Error during email/password sign-in: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred.')),
        );
      }
    }

    Future<void> registerWithEmailAndPassword() async {
      try {
        final String email = emailController.text.trim();
        final String password = passwordController.text.trim();

        if (email.isEmpty || password.isEmpty) {
          debugPrint('Email and password cannot be empty');
          return;
        }

        // Register with email and password
        await ref.read(authProvider).createUserWithEmailAndPassword(email, password);

        debugPrint('User registered successfully');
      } catch (e) {
        debugPrint('Error during registration: $e');
      }
    }

    Future<void> signInWithGoogle(BuildContext context) async {
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

        // Navigate to HomePage after successful login using GoRouter
        context.go('/home'); // Use the route name defined in your GoRouter configuration
      } catch (e) {
        debugPrint('Error during Google Sign-In: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to STEAM.Kids')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Align content to the top
          children: [
            // Add the logo here
            Image.asset(
              'assets/images/logo.png', // Replace with the path to your logo
              height: 100, // Adjust the height as needed
            ),
            const SizedBox(height: 16), // Add spacing after the logo
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: signInWithEmailAndPassword,
                    child: const Text('Sign In'),
                  ),
                  TextButton(
                    onPressed: () {
                      context.push('/register'); // Use the route name defined in your GoRouter configuration
                    },
                    child: const Text('Register'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (kDebugMode) {
                        debugPrint('Development mode: Skipping sign-in');
                        debugPrint('Navigating to HomePage...');
                        context.go('/home'); // Replace '/home' with the route name for HomePage in your GoRouter configuration
                        debugPrint('Navigation to HomePage complete');
                      } else {
                        debugPrint('Production mode: Performing Google Sign-In');
                        await signInWithGoogle(context);
                      }
                    },
                    child: const Text('Login with Google (Dev Mode)'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
