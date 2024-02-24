import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_exercise_2/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_exercise_2/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants/text_styles.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Exercise 2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
            bodyMedium: AppTextStyles.body
        )
      ),
      debugShowCheckedModeBanner: false,
      home: const FirestorePractice(),
    );
  }
}