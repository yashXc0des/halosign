import 'package:esign/core/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/views/signup_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
    return; // Optionally return or handle error as needed
  }
  await Hive.initFlutter();
  await Hive.openBox('settings');
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'Your App Title',
        home: const signup_view(), // Ensure the class name is correct
      ),
    ),
  );
}
