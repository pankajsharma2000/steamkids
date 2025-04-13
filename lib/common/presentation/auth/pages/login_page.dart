import 'package:flutter/material.dart';
import 'package:steamkids/common/widgets/page_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

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
    } catch (e) {
      // Handle errors here
      debugPrint('Error during Google Sign-In: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonPageScaffold(
      title: 'Login',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
            const Text('Login Page'),
            ElevatedButton(
              onPressed: () async {
              await _signInWithGoogle();
              },
              child: const Text('Login with Google'),
            ),
          ],
        ),
      ),
    );
  }
}