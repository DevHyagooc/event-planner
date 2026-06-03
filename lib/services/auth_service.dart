import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<UserCredential?> entrarComGoogle() async {
    try {
      await _googleSignIn.initialize(
        serverClientId: '641006812551-res10hf6p3iu9fi9dkpu3n327udpp1hk.apps.googleusercontent.com',
      );

      final GoogleSignInAccount googleUser =
          await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e, s) {
      debugPrint('ERRO GOOGLE LOGIN: $e');
      debugPrint('STACK: $s');
      return null;
    }
  }
}