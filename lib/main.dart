import 'package:halosign/core/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:halosign/views/signupscreen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await Hive.initFlutter();
  await Hive.openBox('settings');
    runApp(
      ProviderScope(
        child: MaterialApp(
          home:GoogleSignInScreen (), // PdfViewer is now the home widget
        ),
      ),
    );
  }


