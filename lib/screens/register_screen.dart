import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';


class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isPDFVisible = false;
  Uint8List? _pdfBytes;

  Future<void> _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Passwords do not match"),
      ));
      return;
    }
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Registration failed"),
      ));
    }
  }

  void _openPDF() async {
    final data = await rootBundle.load('assets/terms.pdf');
    setState(() {
      _pdfBytes = data.buffer.asUint8List();
      _isPDFVisible = true; // Show PDF view
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAE6FF),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Create Your Account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              TextField(
                controller: _usernameController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Username",
                  labelStyle: TextStyle(color: Color(0xFF5A2D9F)),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Color(0xFF5A2D9F),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Color(0xFF5A2D9F),width: 3),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Color(0xFF5A2D9F),width: 3),
                  ) ,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Color(0xFF5A2D9F),width: 3),
                  ),
                  fillColor: Color(0xFFD3C1FF),
                  filled: true,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email Adress",
                  labelStyle: TextStyle(color: Color(0xFF5A2D9F)),
                  prefixIcon: Icon(
                    Icons.mail,
                    color: Color(0xFF5A2D9F),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Color(0xFF5A2D9F),width: 3),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Color(0xFF5A2D9F),width: 3),
                  ) ,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Color(0xFF5A2D9F),width: 3),
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
                    borderSide: BorderSide(color: Color(0xFF5A2D9F),width: 3),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Color(0xFF5A2D9F),width: 3),
                  ) ,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Color(0xFF5A2D9F),width: 3),
                  ),
                  fillColor: Color(0xFFD3C1FF),
                  filled: true,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  labelStyle: TextStyle(color: Color(0xFF5A2D9F)),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Color(0xFF5A2D9F),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Color(0xFF5A2D9F),width: 3),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Color(0xFF5A2D9F),width: 3),
                  ) ,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Color(0xFF5A2D9F),width: 3),
                  ),
                  fillColor: Color(0xFFD3C1FF),
                  filled: true,
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: _openPDF,
                child: Text(
                  "By registering, you are agreeing to our Terms of Use and Privacy Policy",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _register,
                child: Text("Create Account"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD3C1FF),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
    throw UnimplementedError();
  }
}
