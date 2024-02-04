import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jot_notes/screens/home.dart';
import 'package:jot_notes/screens/splash/splash_screen.dart';

import '../registration/registration_screen.dart';
import '../../widgets/common_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String routeName = "/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _unameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool visibility = false;
  // FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;
  final database = FirebaseFirestore.instance;

  void _showSnackbar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  // Login logic
  Future<void> _performLogin() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Check if any of the fields are empty
      if (_unameController.text.isEmpty || _passwordController.text.isEmpty) {
        _showSnackbar('All fields must be filled', Colors.red);
        return;
      }

      // Sign in the user using FirebaseAuth
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _unameController.text.trim(),
        password: _passwordController.text,
      );

      // Success
      print('User logged in: ${_unameController.text}');
      Navigator.pushReplacementNamed(context, SplashScreen.routeName).then((_) {
        _showSnackbar('Login successful', Colors.green);
      });
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } catch (e) {
      // Handle other login errors
      print('Login error: $e');
      _showSnackbar('Login failed. Please try again.', Colors.red);
    } finally {
      setState(() {
        isLoading = false;
      });
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
                controller: _unameController,
                prefixIcon: const Icon(Icons.account_circle),
                hintText: "enter email",
              ),
              const SizedBox(height: 30),
              CommonTextField(
                controller: _passwordController,
                hintText: "enter password",
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
                    onPressed: _performLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      fixedSize: Size(200, 50),
                    ),
                    child: Text("Login"),
                  ),
                ),
              ),
              Container(
                width: 200,
              ),
              Align(
                heightFactor: 5,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RegistrationScreen.routeName);
                      },
                      child: Text(
                        " Register",
                        style: TextStyle(
                          color: Colors.blue, // You can customize the color
                          fontWeight: FontWeight.bold,
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
    );
  }
}
