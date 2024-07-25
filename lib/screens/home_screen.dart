// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:url_launcher/url_launcher.dart';
import 'package:studyguideapp/screens/course_list_screen.dart';
import '../services/auth_service.dart';
import 'feedback_screen.dart';
import 'assessment_screen.dart';
import 'reminder_screen.dart';
import 'study_materials_screen.dart';
import 'user_profile_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _userName;
  late String _userPhotoUrl;
  late DateTime _currentDateTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentDateTime = DateTime.now();
    _updateTime();
    _loadUserData();
  }

  void _updateTime() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _currentDateTime = DateTime.now();
      });
    });
  }

  void _loadUserData() {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;
    setState(() {
      _userName = user?.displayName ?? 'User';
      _userPhotoUrl = user?.photoURL ?? 'https://via.placeholder.com/150'; // Placeholder image URL if no profile picture
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(_userPhotoUrl),
              radius: 20,
              onBackgroundImageError: (_, __) {
                setState(() {
                  _userPhotoUrl = 'https://via.placeholder.com/150'; // Fallback placeholder
                });
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(_userPhotoUrl),
                    onBackgroundImageError: (_, __) {
                      setState(() {
                        _userPhotoUrl = 'https://via.placeholder.com/150'; // Fallback placeholder
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _userName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              context,
              'Feedback',
              Icons.feedback,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FeedbackScreen()),
              ),
            ),
            _buildDrawerItem(
              context,
              'Manage Course',
              Icons.school,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CourseListScreen()),
              ),
            ),
            _buildDrawerItem(
              context,
              'Assessment',
              Icons.assignment,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AssessmentScreen()),
              ),
            ),
            _buildDrawerItem(
              context,
              'Reminder',
              Icons.alarm,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReminderScreen()),
              ),
            ),
            _buildDrawerItem(
              context,
              'Study Materials',
              Icons.book,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StudyMaterialsScreen()),
              ),
            ),
            _buildDrawerItem(
              context,
              'Profile',
              Icons.person,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserProfileScreen()),
              ),
            ),
            _buildDrawerItem(
              context,
              'About',
              Icons.info,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              ),
            ),
            _buildDrawerItem(
              context,
              'Exit',
              Icons.exit_to_app,
              () {
                Navigator.pop(context); // Close the drawer
                Navigator.pop(context); // Navigate back
              },
            ),
            _buildDrawerItem(
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
                      MaterialPageRoute(builder: (context) => const CourseListScreen()),
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
                    'MY WLV',
                    Icons.web,
                    () => _launchURL('https://my.wlv.ac.uk/dashboard/home'),
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

  Widget _buildDrawerItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      onTap: onTap,
    );
  }
}
