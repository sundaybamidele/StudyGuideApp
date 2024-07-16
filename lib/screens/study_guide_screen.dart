import 'package:flutter/material.dart';

class StudyGuideScreen extends StatelessWidget {
  const StudyGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Guide'),
      ),
      body: const Center(
        child: Text('Study Guide Screen'),
      ),
    );
  }
}
