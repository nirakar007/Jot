import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login/login_page.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);
  static const String routeName = "/register";

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController unameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final database = FirebaseFirestore.instance;

  Future<void> registerUser(String email, String password) async {
    try {
      // Register the user using FirebaseAuth
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Obtain the uid of the registered user
      String uid = userCredential.user!.uid;

      // Save additional user data to Firestore
      await saveUserData(uid, unameController.text, email);

      // Save the generated UID as a user ID for future note associations
      FirebaseAuth.instance.currentUser?.updateDisplayName(uid);

      // Show a success message in a green SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Successfully Registered!"),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to home screen or any other destination
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    } catch (error) {
      print("Registration error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to register. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> saveUserData(String uid, String username, String email) async {
    try {
      final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

      // Save user data to Firestore
      await usersCollection.doc(uid).set({
        'username': username,
        'email': email,
      });

      print('User data saved successfully');
    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 25),
              Text("Username"),
              TextFormField(controller: unameController),
              Container(height: 25),
              Text("Email"),
              TextFormField(controller: emailController),
              Container(height: 25),
              Text("Password"),
              TextFormField(controller: passwordController, obscureText: true),
              Container(height: 25),
              Text("Confirm password"),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                validator: (value) {
                  if (value != passwordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              Container(height: 25),
              Align(
                heightFactor: 1,
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    if (unameController.text.isEmpty ||
                        emailController.text.isEmpty ||
                        passwordController.text.isEmpty ||
                        confirmPasswordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("All fields must be filled"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    if (passwordController.text.length < 5) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Password must be at least 5 characters long"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    if (passwordController.text != confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Passwords do not match"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    try {
                      // Register the user and save additional data
                      await registerUser(emailController.text, passwordController.text);
                      // Show a success message in a green SnackBar

                    } catch (error) {
                      print("Registration error: $error");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Failed to register. Please try again."),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    fixedSize: Size(200, 50),
                  ),
                  child: Text("Register"),
                ),
              ),
              Align(
                heightFactor: 3,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already a user?"),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, LoginScreen.routeName);
                      },
                      child: Text(
                        " Log in",
                        style: TextStyle(
                          color: Colors.blue,
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
