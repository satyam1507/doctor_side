import 'package:doctor_side/screens/homepage.dart';
import 'package:doctor_side/screens/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'models/cooler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
User firebaseUser = FirebaseAuth.instance.currentUser;
Widget firstWidget;
if (firebaseUser != null) {
  firstWidget = HomePage();
} else {
  firstWidget = SignIn();
}
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Healthcare App',
      theme: ThemeData(
        primaryColor: greenish,
        scaffoldBackgroundColor: Colors.white,
       fontFamily: "OpenSans",
      ),
      home: firstWidget,
    );
  }
}
