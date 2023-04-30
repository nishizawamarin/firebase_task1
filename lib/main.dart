import 'package:flutter/material.dart';
import 'package:firebase_exercise_2/pages/home_page.dart';

import 'constants/text_styles.dart';

void main() {
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