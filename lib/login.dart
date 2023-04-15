import 'auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'Animation/FadeAnimation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = false;
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> handleSubmit() async {
  if (!_formKey.currentState!.validate()) return;
  final email = _emailController.value.text;
  final password = _passwordController.value.text;

  setState(() => _loading = true);

  try {
    if (_isLogin) {
      await Auth().signInWithEmailAndPassword(email, password);
    } else {
      await Auth().registerWithEmailAndPassword(email, password);
    }
  } on FirebaseAuthException catch (e) {
    String message;
    if (e.code == 'user-not-found') {
      message = 'There is no user with this email address.';
    } else if (e.code == 'wrong-password') {
      message = 'The password is incorrect.';
    } else if (e.code == 'email-already-in-use') {
      message = 'This email address is already in use.';
    } else {
      message = 'An error occurred, please try again later.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  } finally {
    setState(() => _loading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, colors: [
        Colors.green[500]!,
        Colors.green[800]!,
        Colors.green[400]!
      ])),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(
                      1,
                      Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  FadeAnimation(
                      1.3,
                      Text(
                        "Welcome to Alejandro's App",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 60,
                        ),
                        FadeAnimation(
                            1.4,
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.green,
                                        blurRadius: 20,
                                        offset: Offset(0, 10))
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200]!))),
                                    child: TextFormField(
                                      controller: _emailController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter your email";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          hintText: "Email",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200]!))),
                                    child: TextFormField(
                                      controller: _passwordController,
                                      obscureText: true,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter your password";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: "Password",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 40,
                        ),
                        FadeAnimation(
                          1.5,
                          _isLogin
                              ? PressableText(
                                  text: "Not registered yet? Register",
                                  onPressed: () {
                                    setState(() {
                                      _isLogin = false;
                                      _loading = false;
                                    });
                                  },
                                )
                              : PressableText(
                                  text: "Already registered? Login",
                                  onPressed: () {
                                    setState(() {
                                      _isLogin = true;
                                      _loading = false;
                                    });
                                  },
                                ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        FadeAnimation(
                          1.6,
                          Container(
                            child: Center(
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(horizontal: 50),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.lightGreen,
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50))),
                                    onPressed: () => handleSubmit(),
                                    child: _loading
                                        ? const SizedBox(
                                            height: 50,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            _isLogin ? "Login" : "Register")),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PressableText extends StatefulWidget {
  final String text;
  final Function onPressed;

  const PressableText({required this.text, required this.onPressed});

  @override
  State<PressableText> createState() => _PressableTextState();
}

class _PressableTextState extends State<PressableText> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed();
      },
      child: Text(
        widget.text,
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
