import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
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
  TextEditingController confirmPasswordController = TextEditingController(); // Added for confirm password

  final database = FirebaseFirestore.instance;

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
              Container(height: 25), // Set obscureText to true for password
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
                    // Check if any of the fields are empty
                    if (unameController.text.isEmpty ||
                        emailController.text.isEmpty ||
                        passwordController.text.isEmpty ||
                        confirmPasswordController.text.isEmpty) {
                      // Show an error message if any field is empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("All fields must be filled"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Check if passwords match
                    if (passwordController.text != confirmPasswordController.text) {
                      // Show an error message if passwords don't match
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Passwords do not match"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Check if the username already exists
                    var usernameExistsQuery = await database
                        .collection('users')
                        .where('username', isEqualTo: unameController.text.trim())
                        .get();

                    if (usernameExistsQuery.docs.isNotEmpty) {
                      // Show an error message if the username already exists
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Username already exists. Choose a different one."),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Proceed with data entry if all checks pass
                    var data = {
                      "username": unameController.text,
                      "email": emailController.text,
                      "password": passwordController.text,
                    };

                    // firestore.collection('users').doc().set
                    await database.collection('users').doc().set(data).then((value) {
                      // Show a success message in a green SnackBar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Successful"),
                          backgroundColor: Colors.green,
                        ),
                      );

                      print("Success");
                      unameController.clear();
                      emailController.clear();
                      passwordController.clear();
                      confirmPasswordController.clear();
                    }).onError((error, stackTrace) {
                      print(error.toString());
                    });
                  },

                  style:
                  ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    fixedSize: Size(200,50),
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
