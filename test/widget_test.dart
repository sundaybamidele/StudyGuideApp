import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:studyguideapp/screens/home_screen.dart'; // Import your HomeScreen
import 'package:studyguideapp/services/auth_service.dart'; // Import your AuthService

// Mock class for FirebaseAuth User
class MockUser extends Mock implements User {}

// Mock class for AuthService
class MockAuthService extends Mock implements AuthService {}

void main() {
  testWidgets('Test if Home Screen displays Welcome text', (WidgetTester tester) async {
    // Create mock instances
    final mockAuthService = MockAuthService();
    final mockUser = MockUser();

    // Stub the User properties with non-null values
    when(mockUser.uid).thenReturn('123');
    when(mockUser.displayName).thenReturn('John Doe');
    when(mockUser.email).thenReturn('johndoe@example.com');

    // Stub the AuthService to return the mockUser
    when(mockAuthService.currentUser).thenReturn(mockUser);

    // Build the widget under test
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthService>.value(value: mockAuthService),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    // Allow time for the widget to build
    await tester.pump();

    // Verify that the 'Welcome John Doe' text is displayed
    expect(find.text('Welcome John Doe'), findsOneWidget);
  });
}
