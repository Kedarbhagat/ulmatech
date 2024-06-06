  import 'dart:async';
  import 'dart:typed_data';

  import 'package:connectivity/connectivity.dart';
  import 'package:flutter/material.dart';
  import 'package:internet_connection_checker/internet_connection_checker.dart';
  import 'package:ulmatech/screens/signinScreen.dart';

  import '../resources/auth.dart';
  import '../widgets/text_Field.dart';
  bool _isLoading = false;
  String _passwordHint = 'Enter your password';

  var userdata;
  var UserName = ' ';
  class SignUpScreen extends StatefulWidget {
    const SignUpScreen({Key? key}) : super(key: key);

    @override
    State<SignUpScreen> createState() => _LoginScreenState();
  }

  class _LoginScreenState extends State<SignUpScreen> {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    final TextEditingController _usernameController = TextEditingController();
    Uint8List? _image;
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
              return Image.asset("assets/connection.png",  scale: 2,) ;
            },
          );
        } else if (status == InternetConnectionStatus.connected) {
          Navigator.of(context).pop(); // Close the dialog when internet is reconnected
        }
      });


    }


    @override
    void dispose() {

      _emailController.dispose();
      _passwordController.dispose();
      _usernameController.dispose();
      super.dispose();
    }

    void selectImage() async {}



    @override
    Widget build(BuildContext context) {
      return
        SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(),
                    flex: 2,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!))
                          : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://th.bing.com/th?id=OIP.SAcV4rjQCseubnk32USHigHaHx&w=244&h=256&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2')),
                      Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                              onPressed: selectImage,
                              icon: const Icon(Icons.add_a_photo)))
                    ],
                  ),
                  const SizedBox(height: 45),
                  TextFieldInput(
                      textEditingController: _usernameController,
                      hintText: 'Enter your username',
                      textInputType: TextInputType.text),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFieldInput(
                      textEditingController: _emailController,
                      hintText: 'Enter you email',
                      textInputType: TextInputType.emailAddress),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFieldInput(
                      textEditingController: _passwordController,
                      hintText: _passwordHint,
                      isPass: true,
                      textInputType: TextInputType.visiblePassword),
                  const SizedBox(
                    height: 24,
                  ),
                  GestureDetector(
                    onTap: () async {
                      // Check if password meets the length requirement
                      if (_passwordController.text.length < 8) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Password Error"),
                              content: const Text("Password must be at least 8 characters long."),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                        return; // Exit the function if password length is less than 8
                      }

                      setState(() {
                        _isLoading = true; // Set loading state to true
                      });

                      UserName = _usernameController.text;
                      print(_emailController);
                      print("ehle");
                      userdata = await AuthMethod().signUpUser(
                        email: _emailController.text.toString(),
                        password: _passwordController.text.toString(),
                        username: _usernameController.text.toString(),
                      );

                      if (userdata != null) {
                        // Show email verification dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Verify Your Email"),
                              content: const Text(
                                  "A verification link has been sent to your email. Please verify your email before signing in."),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => const SigninScreen()),
                                          (Route<dynamic> route) => false,
                                    );
                                  },
                                  child: const Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      }

                      setState(() {
                        _isLoading = false; // Set loading state to false when operation is complete
                      });
                    },

                    child: Container(
                      height: 50,
                      child: (_isLoading)?const SizedBox(
                        height: 20 ,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white,)):const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(26)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Flexible(
                    child: Container(),
                    flex: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: const Text("Already have an account?"),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      GestureDetector(
                        onTap: () async {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SigninScreen()),
                                (Route<dynamic> route) => false,
                          );
                        },
                        child: Container(
                          child: const Text(
                            " Sign In",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
