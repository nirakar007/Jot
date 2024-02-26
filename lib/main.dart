import 'dart:math';

import 'package:jot_notes/route/route_generator.dart';
import 'package:jot_notes/screens/home.dart';
import 'package:jot_notes/screens/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: const [
            Icon(Icons.share),
            Padding(
              padding: EdgeInsets.only(right: 10, left: 20),
              child: Icon(Icons.favorite),
            )
          ],
          centerTitle: true,
          leading: Icon(Icons.menu),
          title: Text(
            "Jot",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          )),
    );
  }
}
