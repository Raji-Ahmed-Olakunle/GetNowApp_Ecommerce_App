import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getnowshopapp/FeatureMigrated/auth/presentation/views/widgets/Signin.dart';
import 'package:getnowshopapp/FeatureMigrated/auth/presentation/views/widgets/signUp.dart';
import 'package:go_router/go_router.dart';

import '../viewmodels/auth_provider.dart';

class Authscreen extends ConsumerStatefulWidget {
  const Authscreen({super.key});

  @override
  ConsumerState<Authscreen> createState() => _AuthscreenState();
}

class _AuthscreenState extends ConsumerState<Authscreen> {
  bool showSignUp = false;

  void _showSnackbar(BuildContext ctx, String Message, Color) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        backgroundColor: Color,
        content: Text(Message, style: TextStyle(fontSize: 20)),
        duration: Duration(seconds: 3),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.15,
          horizontal: 30,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: <Color>[Color(0xff82A8B), Color(0xff3fA03B)],
            stops: [0.5, 0.5],
          ),
        ),
        child: Card(
          elevation: 5,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(15),
            //     color: Color(0xfffaf5ee),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Color(0xff607ebc),
            //         blurRadius: 1,
            //         spreadRadius: 5,
            //         offset: Offset(1, 2),
            //       ),
            //     ],
            //   ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                showSignUp ? Signup() : Signin(),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                            onPressed: () async {
                              try {
                                setState(() {
                                  _isLoading = true;
                                });
                                await ref
                                    .read(authProvider.notifier)
                                    .signInWithGoogle();

                                print('in');
                                context.goNamed('HomeScreen');
                                //Navigator.of(context).pushNamed("/HomeScreen");
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  _showSnackbar(
                                    context,
                                    "User not found for this Account",
                                    Colors.redAccent,
                                  );
                                } else if (e.code == 'wrong-password') {
                                  _showSnackbar(
                                    context,
                                    "Password incorrect check and try again",
                                    Colors.redAccent,
                                  );
                                }
                              } on PlatformException catch (e) {
                                if (e.code == 'sign_in_failed' &&
                                    e.message?.contains('7:') == true) {
                                  _showSnackbar(
                                    context,
                                    "No internet connectivity",
                                    Colors.redAccent,
                                  );
                                  setState(() {
                                    _isLoading = false;
                                  });
                                } else {}
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  'assets/image/icons8-google-48.png',
                                  width: 20,
                                  height: 20,
                                ),
                                showSignUp
                                    ? Text("Signup using Google ")
                                    : Text("Signin using Google"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      showSignUp
                          ? Text("Already have an account?,SignIn")
                          : Text("Don't  have an account?,SignUp"),
                      TextButton(
                        onPressed: () {
                          if (showSignUp) {
                            setState(() {
                              showSignUp = false;
                            });
                          } else {
                            setState(() {
                              showSignUp = true;
                            });
                          }
                        },
                        child: Text(
                          "Here",
                          style: TextStyle(color: Colors.lightBlue),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: double.infinity,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xffa0430a),
                        Color(0xff278783),
                        Color(0xff321b15),
                        Color(0xFF5E548E),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [0.1, 0.4, 0.6, 0.9],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
