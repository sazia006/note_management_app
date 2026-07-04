import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_management_app/providers/note_provider.dart';
import 'package:note_management_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'screens/notes/notes_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const NoteManagementApp());
}

class NoteManagementApp extends StatelessWidget {
  const NoteManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteProvider()..loadNotes()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'NoteX',

            theme: AppTheme.lightTheme,

            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,

            home: const NotesScreen(),
          );
        },
      ),
    );
  }
}
