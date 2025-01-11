import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:se_380_project/Firebase/AuthService.dart';
import 'package:se_380_project/screens/category_screen.dart';
import 'package:se_380_project/screens/home_screen.dart';
import 'package:se_380_project/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'google_books_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleBooksService _googleBooksService = GoogleBooksService();

  Future<void> _login() async {
    try {
      final userCredential = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (userCredential == null) return;
      final User? user = userCredential.user;
      if (user == null) return;

      bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      if (!isNewUser) {
        await _authService.addUserStatsToFirestore(user);
        await _authService.fetchUserStatsFromFirestore(user);
        Map<String, List<Map<String, dynamic>>> booksByCategory = {};
        var selectedCategories = AuthService.userStats["bookCategories"];
        if (selectedCategories != null) {
          for (String category in selectedCategories) {
            booksByCategory[category] =
            await _googleBooksService.fetchBooksByCategory(category);
          }
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CategoryScreen()),
        );

      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAE6FF),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Welcome Back! ",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email Adress",
                labelStyle: TextStyle(color: Color(0xFF5A2D9F)),
                prefixIcon: Icon(
                  Icons.email,
                  color: Color(0xFF5A2D9F),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Color(0xFF5A2D9F), width: 3),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Color(0xFF5A2D9F), width: 3),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Color(0xFF5A2D9F), width: 3),
                ),
                fillColor: Color(0xFFD3C1FF),
                filled: true,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(color: Color(0xFF5A2D9F)),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Color(0xFF5A2D9F),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Color(0xFF5A2D9F), width: 3),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Color(0xFF5A2D9F), width: 3),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Color(0xFF5A2D9F), width: 3),
                ),
                fillColor: Color(0xFFD3C1FF),
                filled: true,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: Text("Login"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD3C1FF),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()));
              },
              child: Text("Don\'t have an account? register right now"),
            ),
          ],
        ),
      ),
    );
    throw UnimplementedError();
  }
}
