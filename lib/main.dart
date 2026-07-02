import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_management_app/core/theme/app_theme.dart';
import 'screens/notes/notes_screen.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const NoteManagementApp());
}

class NoteManagementApp extends StatelessWidget {
  const NoteManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cloud Notes Pro',
      theme: AppTheme.lightTheme,
      home: const NotesScreen(),
    );
  }
}
