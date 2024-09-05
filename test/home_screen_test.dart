import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:studyguideapp/screens/course_list_screen.dart';
import 'package:studyguideapp/screens/home_screen.dart'; // Update with your actual import path
import 'package:studyguideapp/models/user_profile.dart'; // Update with your actual import path

// Mock class for UserProfile
class MockUserProfile extends Mock implements UserProfile {}

void main() {
  testWidgets('displays welcome message with user name', (WidgetTester tester) async {
    // Arrange
    final mockUserProfile = MockUserProfile();
    when(mockUserProfile.name).thenReturn('John Doe');

    // Act
    await tester.pumpWidget(
      ChangeNotifierProvider<UserProfile>.value(
        value: mockUserProfile,
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    // Assert
    expect(find.text('Welcome, John Doe!'), findsOneWidget);
  });

  testWidgets('displays the current time', (WidgetTester tester) async {
    // Arrange
    final mockUserProfile = MockUserProfile();
    when(mockUserProfile.name).thenReturn('John Doe');

    // Act
    await tester.pumpWidget(
      ChangeNotifierProvider<UserProfile>.value(
        value: mockUserProfile,
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    // Assert
    // Example logic to check for time display (adjust as needed):
    expect(find.text(RegExp(r'\d{2}:\d{2}:\d{2}') as String), findsOneWidget);
  });

  testWidgets('navigates to the course list when "Course List" is tapped', (WidgetTester tester) async {
    // Arrange
    final mockUserProfile = MockUserProfile();
    when(mockUserProfile.name).thenReturn('John Doe');

    // Act
    await tester.pumpWidget(
      ChangeNotifierProvider<UserProfile>.value(
        value: mockUserProfile,
        child: MaterialApp(
          home: const HomeScreen(),
          routes: {
            '/course_list': (context) => const CourseListScreen(), // Update with actual route and screen
          },
        ),
      ),
    );

    // Tap the Course List button
    await tester.tap(find.text('Course List'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(CourseListScreen), findsOneWidget);
  });
}
