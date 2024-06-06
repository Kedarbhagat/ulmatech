import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ulmatech/screens/homeScreen.dart';
import 'package:ulmatech/screens/signupScreen.dart';
import 'package:ulmatech/widgets/text_Field.dart';
import 'package:ulmatech/resources/auth.dart';

String credUID = '';
bool _isLoading = false;

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool hidePassword = true;
  String error = ' ';
  late StreamSubscription<InternetConnectionStatus> connectionSubscription;

  @override
  void initState() {
    super.initState();
    // Start listening for internet connection changes
    connectionSubscription = InternetConnectionChecker().onStatusChange.listen((status) {
      if (status == InternetConnectionStatus.disconnected) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Image.asset(
              "assets/connection.png",
              scale: 2,
            );
          },
        );
      } else if (status == InternetConnectionStatus.connected) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(); // Close the dialog when internet is reconnected
        }
      }
    });
  }

  @override
  void dispose() {
    connectionSubscription.cancel(); // Cancel the subscription when disposing the screen
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 80,
            ),
            // Space for logo
            Center(child: Image.asset("assets/logo.png", scale: 2.2)),
            const SizedBox(
              height: 60,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "Sign In",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45),
              ),
            ),
            const SizedBox(height: 30),

            // Sign in textfield
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 25, 0),
                    child: Text(
                      "@",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Color(0xFF8acbbe),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFieldInput(
                      textEditingController: _emailController,
                      hintText: 'Enter your email',
                      textInputType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(width: 10,)
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
              child: Text(
                error,
                style: const TextStyle(color: Colors.red),
              ),
            ),

            // Text field for password
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
                  child: Icon(
                    Icons.lock_outline_sharp,
                    size: 30,
                    color: Color(0xFF8acbbe),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: hidePassword,
                      obscuringCharacter: "*",
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          child: Icon(
                            hidePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(225, 10, 0, 0),
              child: Text(
                "Forgot Password?",
                style: TextStyle(color: Color(0xFF6F8BEF)),
              ),
            ),

            //button
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 30, 30, 14),
              child: Center(
                child: GestureDetector(
                  // Inside the GestureDetector onTap method
                  // Inside the GestureDetector onTap method
                  onTap: () async {
                    setState(() {
                      _isLoading = true; // Set loading state to true
                    });

                    // Perform sign-in operation
                    String signInError = await AuthMethod().signInUser(
                      email: _emailController.text.toString(),
                      password: _passwordController.text.toString(),
                    );
                    credUID =FirebaseAuth.instance.currentUser!.uid;

                    setState(() {
                      error = signInError; // Set the error message received from sign-in
                      _isLoading = false; // Set loading state to false when operation is complete
                    });

                    // Check if sign-in was successful
                    if (signInError == 's') {
                      // Navigate to home screen if sign-in was successful
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const homeScreen()),
                            (Route<dynamic> route) => false,
                      );
                    }
                  },

                  child: Container(
                    child: (_isLoading)
                        ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ))
                        : const Text(
                      "Sign In",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    width: 300,
                    height: 50,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(26)))),
                  ),
                ),
              ),
            ),

            //Dividing line
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Row(
                children: [
                  Expanded(child: Divider(height: 10)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      "OR",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Expanded(child: Divider(height: 10)),
                ],
              ),
            ),

            //google button
            Center(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  child: Row(
                    children: [
                      const SizedBox(width: 20),
                      Image.network(
                        'https://th.bing.com/th/id/OIP.S3ZsU5iH6e3Z2K7lXlES7AHaFj?w=241&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
                        scale: 0.1,
                      ),
                      const Text(
                        "Continue with Google",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                  width: 300,
                  height: 55,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(26)),
                    border: Border.all(color: Colors.black.withOpacity(0.2), width: 1), // Light black outline
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(88, 30, 0, 0),
              child: Row(
                children: [
                  const Text("New to Adhicine?"),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()));
                    },
                    child: const Text(
                      " Sign Up",
                      style: TextStyle(color: Color(0xFF6f8bef)),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
