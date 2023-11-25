// ignore_for_file: prefer_const_constructors, duplicate_import, unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medotg/Screens/homepage/components/home_page_body.dart';
import 'Screens/login/components/auth_page.dart';
import 'Screens/login/login.dart';
import 'firebase_options.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: ' MEDOTG ',
      theme: ThemeData().copyWith(
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: HexColor("#8d8d8d"),
            ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // or your custom loading widget
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Check if user is signed in
            if (snapshot.hasData) {
              return LoginScreen(); // replace with your home screen widget
            } else {
              return const AuthPage();
            }
          
        }
        },
      ),
    );
  }
}
