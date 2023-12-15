import 'package:flutter/material.dart';
import 'package:lib_panda/screens/home_page.dart';
import 'package:lib_panda/screens/profile_page.dart';
import 'package:lib_panda/screens/search_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
          title: 'LibPanda',
          theme: ThemeData(
            //brightness: Brightness.light, // Use a light theme for a more modern feel
            primaryColor: Colors.indigo, // Update primary color

            scaffoldBackgroundColor: const Color(0xFF1E1E1E), // Dark grey color

            textTheme: const TextTheme(
              titleLarge: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              bodyMedium: TextStyle(
                fontSize: 14.0,
                color: Colors.black54,
              ),
            ),
          ),
          home: BookHomePage()),
    );
  }
}