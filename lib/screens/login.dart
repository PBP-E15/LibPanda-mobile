import 'package:flutter/material.dart';
import 'package:lib_panda/main.dart';
import 'package:lib_panda/screens/home_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.grey[800],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 253, 208), // Warna Krim
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Teks "PANDA LIBRARY"
              Text(
                'PANDA LIBRARY',
                style: TextStyle(
                  fontFamily: 'MS UI Gothic',
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800], // Warna Hijau Tua
                ),
              ),
              const SizedBox(height: 12.0),
              // Gambar di atas input
              Image.network(
                'https://i.ibb.co/brcxb2J/1698425247234.png',
                width: 300,
                height: 300,
              ),
              const SizedBox(height: 20.0),
              // Input Username
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 200, // Sesuaikan lebar container sesuai kebutuhan
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              // Input Password
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 200, // Sesuaikan lebar container sesuai kebutuhan
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () async {
                  // ... (sama seperti sebelumnya)
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
