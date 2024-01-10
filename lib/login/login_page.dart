import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jot_notes/screens/mainScreen.dart';

import '../registration/registration_screen.dart';
import '../widgets/common_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String routeName = "/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool visibility = true;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;

  Future<void> _performLogin() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Check for empty fields
      if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
        // Handle empty fields
        print("Email and password cannot be empty");
        return;
      }

      // Sign in user with email and password
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      print("User logged in: ${userCredential.user?.email}");
      Navigator.pushNamed(context, MainScreen.routeName);

      // Navigate to the home screen or perform other actions after successful login
      // Navigator.pushNamed(context, HomeScreen.routeName);
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });

      // Handle login errors
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('Invalid email or password.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Handle other login errors
        print('Login error: ${e.code}, ${e.message}');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 200,
                  width: 300,
                ),
              ),
              const SizedBox(height: 10),
              CommonTextField(
                controller: _emailController,
                prefixIcon: const Icon(Icons.account_circle),
                hintText: "Enter email",
              ),
              const SizedBox(height: 20),
              CommonTextField(
                controller: _passwordController,
                hintText: "Enter password",
                suffixIcon: IconButton(
                  icon: visibility
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      visibility = !visibility;
                    });
                  },
                ),
                prefixIcon: Icon(Icons.key),
              ),
              SizedBox(height: 30),
              Center(
                child: Container(
                  width: 300,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.black),

                    onPressed: isLoading ? null : _performLogin,
                    child:
                    isLoading
                        ? CircularProgressIndicator()
                        : Text("Login"),
                  ),
                ),
              ),
              Container(
                width: 200,
              ),
              Align(
                heightFactor: 5,
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RegistrationScreen.routeName);
                  },
                  child: Text("Register now"),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}
