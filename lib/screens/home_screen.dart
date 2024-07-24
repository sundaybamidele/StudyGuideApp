import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:studyguideapp/screens/course_list_screen.dart';
import '../services/auth_service.dart';
import 'feedback_screen.dart';
import 'assessment_screen.dart';
import 'reminder_screen.dart';
import 'study_materials_screen.dart';
import 'user_profile_screen.dart';
import 'create_course_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _userName;
  late DateTime _currentDateTime;

  @override
  void initState() {
    super.initState();
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;
    _userName = user?.displayName ?? 'User';
    _currentDateTime = DateTime.now();
    _updateTime();
  }

  void _updateTime() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _currentDateTime = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Message and Date/Time
            Text(
              'Welcome, $_userName',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8.0),
            Text(
              DateFormat('EEEE, MMM d, yyyy').format(_currentDateTime),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              DateFormat('h:mm:ss a').format(_currentDateTime),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20.0),

            // Grid for menu items
            Expanded(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                children: [
                  _buildGridItem(
                    context,
                    'Feedback',
                    Icons.feedback,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FeedbackScreen()),
                    ),
                  ),
                  _buildGridItem(
  context,
  'Manage Course',
  Icons.school,
  () => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CourseListScreen()),
  ),
),
                  _buildGridItem(
                    context,
                    'Assessment',
                    Icons.assignment,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AssessmentScreen()),
                    ),
                  ),
                  _buildGridItem(
                    context,
                    'Reminder',
                    Icons.alarm,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ReminderScreen()),
                    ),
                  ),
                  _buildGridItem(
                    context,
                    'Study Materials',
                    Icons.book,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const StudyMaterialsScreen()),
                    ),
                  ),
                  _buildGridItem(
                    context,
                    'Profile',
                    Icons.person,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserProfileScreen()),
                    ),
                  ),
                  _buildGridItem(
                    context,
                    'Create Course',
                    Icons.add_box,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CreateCourseScreen()),
                    ),
                  ),
                  _buildGridItem(
                    context,
                    'About',
                    Icons.info,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutScreen()),
                    ),
                  ),
                  _buildGridItem(
                    context,
                    'Logout',
                    Icons.logout,
                    () async {
                      final authService = Provider.of<AuthService>(context, listen: false);
                      await authService.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40.0),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
