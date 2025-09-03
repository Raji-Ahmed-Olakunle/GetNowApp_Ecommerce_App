import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getnowshopapp/FeatureMigrated/auth/presentation/viewmodels/auth_provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/http_exception.dart';

class Signup extends ConsumerStatefulWidget {
  const Signup({super.key});

  @override
  ConsumerState<Signup> createState() => _SignupState();
}

class _SignupState extends ConsumerState<Signup> {
  bool _isLoading = false;

  final _formkey = GlobalKey<FormState>();
  bool isobscure = false;
  String Email = '', Password = '', Username = '';
  TextEditingController UsernameController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Sign Up", style: TextStyle(fontSize: 25)),
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
        Scrollbar(
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                        child: Text("USERNAME", style: TextStyle(fontSize: 15)),
                      ),
                      TextFormField(
                        controller: UsernameController,
                        validator: (value) {
                          if (value == null) {
                            return 'Enter a Username';
                          }

                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: "Enter username",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.blue,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.blue,
                            ),
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
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.blue,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30, bottom: 10),
                    padding: EdgeInsets.symmetric(horizontal: 70),
                    child:
                        !_isLoading
                            ? OutlinedButton(
                              onPressed: () async {
                                if (_formkey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                    Email = emailController.text;
                                    Password = PasswordController.text;
                                    Username = UsernameController.text;
                                  });
                                  try {
                                    await ref
                                        .read(authProvider.notifier)
                                        .signUp(Email, Password, Username);
                                    GoRouter.of(
                                      context,
                                    ).pushNamed('HomeScreen');
                                  } on httpException catch (error) {
                                    var errorMessage = 'Authentication failed';
                                    var color = Colors.redAccent;
                                    if (error.toString().contains(
                                      'EMAIL_EXISTS',
                                    )) {
                                      errorMessage =
                                          'This email address is already in use.';
                                      color = Colors.redAccent;
                                    } else if (error.toString().contains(
                                      'INVALID_EMAIL',
                                    )) {
                                      errorMessage =
                                          'This is not a valid email address';
                                      color = Colors.redAccent;
                                    } else if (error.toString().contains(
                                      'WEAK_PASSWORD',
                                    )) {
                                      errorMessage =
                                          'This password is too weak.';
                                      color = Colors.lightBlueAccent;
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
                                      color = Colors.redAccent;
                                    }
                                    _showSnackbar(context, errorMessage, color);
                                  } catch (error) {
                                    const errorMessage =
                                        'Could not authenticate you. Please try again later.';
                                    _showSnackbar(
                                      context,
                                      errorMessage,
                                      Colors.redAccent.shade400,
                                    );
                                  }
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  Icon(Icons.exit_to_app_sharp),
                                  Text("Sign Up"),
                                ],
                              ),
                            )
                            : Center(child: CircularProgressIndicator()),
                  ),

                  Container(
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Divider(
                          height: 10,
                          thickness: 1,
                          color: Colors.black,
                          indent: 10,
                          endIndent: 0,
                        ),
                        Container(
                          color: Color(0xfffaf5ee),
                          width: 30,
                          child: Center(
                            child: Text(
                              "OR",
                              style: TextStyle(
                                backgroundColor: Color(0xfffaf5ee),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
