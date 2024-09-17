import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Study Guide Application'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add your image here (replace with your actual image path)
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/student_photo.jpg'), // Update this path to your image
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Application Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'This application was developed by Bamidele Joseph Sunday as an artifact for the MSc Computer Science program at the University of Wolverhampton.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Full Name: Bamidele Joseph Sunday',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Program: MSc Computer Science',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Email: b.j.sunday@wlv.ac.uk, sunday.bamidele@gmail.com',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Year Graduated: September 2024',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Supervisor:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Name: Sherin Nassa',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Title: Senior Lecturer',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Department: Department of Computer Science',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Faculty: Faculty of Science and Engineering',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Institution: University of Wolverhampton, United Kingdom',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Reader:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Name: Alix Bergeret',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Title: Reader',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Department: Department of Computer Science',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Faculty: Faculty of Science and Engineering',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Institution: University of Wolverhampton, United Kingdom',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
