import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/auth_provider.dart';

class ForgetPasswordScreen extends ConsumerWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 200, horizontal: 40),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.centerLeft,
            colors: <Color>[Color(0xff082A8B), Color(0xff3F403B)],
            stops: [0.8, 0.2],
          ),
        ),
        child: Center(
          child: Container(
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
              color: Color(0xFFDFE8E6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 1, color: Colors.black45),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Password Recovery", style: TextStyle(fontSize: 20)),
                      Text("Enter your mail", style: TextStyle(fontSize: 15)),
                    ],
                  ),
                  Form(
                    key: formKey,
                    child: SizedBox(
                      height: 160,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: emailController,
                            validator: (text) {
                              final RegExp isValidEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}');
                              if (text == null || text.isEmpty) {
                                return 'Enter an Email';
                              } else if (!isValidEmail.hasMatch(text)) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: 'Confirm Email',
                              prefixIcon: const Icon(Icons.mail),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(width: 2, color: Colors.blue),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                ref.read(authProvider.notifier).sendPasswordResetEmail(emailController.text, ref);
                              }
                            },
                            child: const Text('Send Email'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Sign in back??'),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/AuthScreen');
                        },
                        child: const Text("here", style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 