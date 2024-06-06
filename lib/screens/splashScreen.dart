import 'package:flutter/material.dart';
import 'package:ulmatech/screens/signinScreen.dart';


class splashScreen extends StatefulWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startFadeInEffect();
    _navigateToLogin();
  }

  void _startFadeInEffect() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        opacity = 1.0;
      });
    });
  }

  void _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SigninScreen()), // Adjust this to your login screen widget
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("This is splashScreen" , style: TextStyle(
          fontWeight: FontWeight.bold ,
          fontSize: 50 ,
        ),),
      ),
    );
  }
}
