import 'package:flutter/material.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cloud Notes Pro")),

      body: const Center(
        child: Text(
          "Next Step: Firestore List",
          style: TextStyle(fontSize: 22),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text("New Note"),
      ),
    );
  }
}
