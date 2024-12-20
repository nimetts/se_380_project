import 'package:flutter/material.dart';
import 'package:se_380_project/screens/book_search_screen.dart';
import 'package:se_380_project/screens/category_screen.dart';
import 'package:se_380_project/screens/favorites_manager.dart';
import 'package:se_380_project/screens/home_screen.dart';
import 'package:se_380_project/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FavoritesManager().fetchFavorites();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: welcomeScreen(),

    );
  }
}
