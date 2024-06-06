import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireFirestore = FirebaseFirestore.instance;

  // Sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
  }) async {
    print(email);
    String res = "success";
    print(email);
    try {
      if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
        // Register the user
        print("Creation started");
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Send email verification
        await cred.user!.sendEmailVerification();

        print(cred.user!.uid + " lol");
        res = "User registered. Please check your email for verification.";
      } else {
        res = "Please fill out all the fields.";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Sign in user
  Future<String> signInUser({
    required String email,
    required String password,
  }) async {
    String res = 's';
    try {
      UserCredential credentials = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if email is verified
      if (credentials.user != null && !credentials.user!.emailVerified) {
        res = "Please verify your email before logging in.";
        await _auth.signOut();
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Log out user
  Future<void> logOut() async {
    await _auth.signOut();
  }
}
