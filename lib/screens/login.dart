import 'package:flutter/material.dart';
import 'package:lib_panda/main.dart';
import 'package:lib_panda/screens/home_page.dart';
import 'package:lib_panda/screens/register.dart';
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
  const LoginPage({Key? key});

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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://pictures.pibig.info/uploads/posts/2023-04/1680787841_pictures-pibig-info-p-trostnik-risunok-instagram-34.jpg',
            fit: BoxFit.cover,
            color: Colors.black87,
            colorBlendMode: BlendMode.darken,
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Welcome to',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'MS UI Gothic',
                          fontSize: 20.0,
          
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const Text(
                        'Panda Library',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'MS UI Gothic',
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Image.network(
                        'https://i.ibb.co/brcxb2J/1698425247234.png',
                        width: 200,
                        height: 200,
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: () async {
                          String username = _usernameController.text;
                          String password = _passwordController.text;

                          // Cek kredensial
                          // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                          // Untuk menyambungkan Android emulator dengan Django pada localhost,
                          // gunakan URL http://10.0.2.2/
                          final response = await request.login("https://libpanda-e15-tk.pbp.cs.ui.ac.id/auth/login/", {
                          'username': username,
                          'password': password,
                          });
              
                          if (request.loggedIn) {
                              String message = response['message'];
                              String uname = response['username'];
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => BookHomePage()),
                              );
                              ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                      SnackBar(content: Text("$message Selamat datang, $uname.")));
                              } else {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                      title: const Text('Login Gagal'),
                                      content:
                                          Text(response['message']),
                                      actions: [
                                          TextButton(
                                              child: const Text('OK'),
                                              onPressed: () {
                                                  Navigator.pop(context);
                                              },
                                          ),
                                      ],
                                  ),
                              );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green.shade800, // Set the background color
                          // You can also customize other button properties here, like padding and shape
                          padding: EdgeInsets.symmetric(vertical: 15.0), // Adjust padding as needed
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), // Adjust the border radius
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white, // Text color set to white
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Don`t have an account yet?',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegistrationPage()),
                          );
                        },
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
