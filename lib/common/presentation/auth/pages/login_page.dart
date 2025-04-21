import 'package:flutter/material.dart';
import 'package:steamkids/common/widgets/page_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _signInWithGoogle() async {
    try {
      // Initialize GoogleSignIn with the clientId
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: '41141891810-98tia2rgu16q298tt1sncac6dk5s4ftv.apps.googleusercontent.com',
      );

      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Print the signed-in user's details
      final user = FirebaseAuth.instance.currentUser;
      debugPrint('Signed in as: ${user?.displayName}');
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
                  const Text('Currently we support only Google Sign-In'),
                  ElevatedButton(
                    onPressed: _signInWithGoogle,
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