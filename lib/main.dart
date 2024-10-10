import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'registration_page.dart';
import 'customer_home_page.dart'; // Import the CustomerHomePage file
import 'package:crypto/crypto.dart';
import 'dart:convert';

const Color primaryColor = Color(0xFF4CAF50); // Primary color (green)
const Color backgroundColor =
    Color(0xFFFFF9C4); // Background color (light cream)
const Color textColor = Color(0xFF3E2723); // Text color (deep brown)

void main() async {
  try {
    // Initialize Firebase
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error) {
    print('Error initializing Firebase: $error');
  }

  // Run your app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login and Registration Demo',
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: textColor),
          bodyText2: TextStyle(color: textColor),
          headline6: TextStyle(color: textColor),
        ),
      ),
      home: LoginPage(),
      routes: {
        '/customer_home': (context) => CustomerHomePage(),
        // Add routes for other pages as needed
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> loginUser() async {
    try {
      // Hash the password using SHA-256
      String hashedPassword =
          sha256.convert(utf8.encode(_passwordController.text)).toString();

      // Check if user exists with the provided email
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: hashedPassword, // Compare with hashed password
      );

      // Login successful
      print(
          'Login successful for user: ${userCredential.user?.email ?? "Unknown user"}');

      // Navigate to CustomerHomePage after successful login
      Navigator.pushReplacementNamed(context, '/customer_home');
    } catch (e) {
      // Login failed
      print('Error logging in: $e');
      // Display error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error logging in: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'City of Bristol Hair Salon',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Login',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: loginUser,
              child: Text('Login'),
            ),
            SizedBox(height: 12.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
              child: Text('Register'), //registered
            ),
          ],
        ),
      ),
    );
  }
}
