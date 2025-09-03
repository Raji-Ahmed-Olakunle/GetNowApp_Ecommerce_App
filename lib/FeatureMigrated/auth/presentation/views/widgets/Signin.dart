import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getnowshopapp/FeatureMigrated/auth/presentation/viewmodels/auth_provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/http_exception.dart';

// import '../Models/http_exception.dart';
// import '../Providers/auth.dart';
class Signin extends ConsumerStatefulWidget {
  const Signin({super.key});

  @override
  ConsumerState<Signin> createState() => _SigninState();
}

class _SigninState extends ConsumerState<Signin> {
  bool isLoading = false;
  bool isobscure = false;
  String Email = '';
  String Password = '';

  void _showSnackbar(BuildContext ctx, String Message, Color) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        backgroundColor: Color,
        content: Text(Message, style: TextStyle(fontSize: 20)),
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        duration: Duration(seconds: 3),
      ),
    );
  }

  TextEditingController PasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text("Sign In", style: TextStyle(fontSize: 25)),
          ),
          Container(
            width: double.infinity,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors:
                    [
                      Color(0xffa0430a),
                      Color(0xff278783),
                      Color(0xff321b15),
                      Color(0xFF5E548E),
                    ].reversed.toList(),
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.1, 0.4, 0.6, 0.9],
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 10,
                      ),
                      child: Text("Email", style: TextStyle(fontSize: 15)),
                    ),

                    TextFormField(
                      controller: emailController,

                      validator: (value) {
                        final RegExp isvalidEmail = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );
                        if (value == null) {
                          return 'Enter a Email';
                        } else if (!isvalidEmail.hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        labelText: "Enter Email",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.blue),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 10,
                      ),
                      child: Text("Password", style: TextStyle(fontSize: 15)),
                    ),

                    TextFormField(
                      controller: PasswordController,
                      validator: (value) {
                        final RegExp isvalidPassword = RegExp(
                          r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$',
                        );
                        if (value == null) {
                          return 'Enter a Password';
                        }
                        // else if(!isvalidPassword.hasMatch(value)){
                        //   return 'Enter a valid Password';
                        // }
                        return null;
                      },

                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: isobscure,
                      decoration: InputDecoration(
                        suffixIcon: TextButton(
                          onPressed: () {
                            setState(() {
                              if (isobscure) {
                                isobscure = false;
                              } else {
                                isobscure = true;
                              }
                            });
                          },
                          child:
                              isobscure
                                  ? Icon(Icons.remove_red_eye_outlined)
                                  : Icon(Icons.panorama_fish_eye_outlined),
                        ),
                        prefixIcon: Icon(Icons.lock_outline),
                        label: Text("Enter Password"),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.blue),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pushNamed('/ForgetPasswordScreen');
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text("Forgot  Password?"),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30, bottom: 10),
                      padding: EdgeInsets.symmetric(horizontal: 70),
                      child:
                          !isLoading
                              ? OutlinedButton(
                                onPressed: () async {
                                  if (_formkey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                      Email = emailController.text;
                                      Password = PasswordController.text;
                                    });
                                    try {
                                      await ref
                                          .read(authProvider.notifier)
                                          .signIn(Email, Password);
                                      GoRouter.of(
                                        context,
                                      ).pushNamed('HomeScreen');
                                    } on httpException catch (error) {
                                      print(error.Message);
                                      var errorMessage =
                                          'Authentication failed';
                                      var color = Colors.redAccent;
                                      if (error.toString().contains(
                                        'EMAIL_EXISTS',
                                      )) {
                                        errorMessage =
                                            'This email address is already in use.';
                                        color = Colors.indigoAccent;
                                      } else if (error.toString().contains(
                                        'INVALID_EMAIL',
                                      )) {
                                        errorMessage =
                                            'This is not a valid email address';
                                        color = Colors.indigoAccent;
                                      } else if (error.toString().contains(
                                        'WEAK_PASSWORD',
                                      )) {
                                        errorMessage =
                                            'This password is too weak.';
                                        color = Colors.indigoAccent;
                                      } else if (error.toString().contains(
                                        'EMAIL_NOT_FOUND',
                                      )) {
                                        errorMessage =
                                            'Could not find a user with that email.';
                                        color = Colors.blueAccent;
                                      } else if (error.toString().contains(
                                        'INVALID_PASSWORD',
                                      )) {
                                        errorMessage = 'Invalid password.';
                                        color = Colors.indigoAccent;
                                      } else if (error.toString().contains(
                                        'INVALID_LOGIN_CREDENTIALS',
                                      )) {
                                        errorMessage =
                                            'Invalid User,create a new one';
                                        color = Colors.indigoAccent;
                                      }
                                      setState(() {
                                        isLoading = false;
                                      });
                                      _showSnackbar(
                                        context,
                                        errorMessage,
                                        color,
                                      );
                                    } catch (error) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      const errorMessage =
                                          'Could not authenticate you. Please try again later.';
                                      _showSnackbar(
                                        context,
                                        errorMessage,
                                        Colors.blueAccent,
                                      );
                                    }
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [
                                    Icon(Icons.exit_to_app_sharp),
                                    Text("Sign In"),
                                  ],
                                ),
                              )
                              : Center(child: CircularProgressIndicator()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
