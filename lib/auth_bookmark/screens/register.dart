// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wisdom_repository_mobile/auth_bookmark/screens/login.dart';

String member = "";

void main() {
  runApp(const RegisterApp());
}

class RegisterApp extends StatelessWidget {
  const RegisterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegisterPage> {
  String?
      selectedMember; // Tambahkan variabel untuk menyimpan pilihan radio button
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _registerUser() async {
    final url = Uri.parse(
        "https://wisdomrepository--wahyuridho5.repl.co/register-flutter/");
    final response = await http.post(
      url,
      body: {
        'username': _usernameController.text,
        'member': selectedMember ?? '',
        'password1': _passwordController.text,
        'password2': _passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      // Handle successful registration
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Registrasi berhasil!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => const LoginPage(),
                  ));
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Handle registration errors
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'Registrasi gagal, silakan perbaiki data yang dimasukkan.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Registration Form'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo_blue.png',
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 8.0),
              RadioListTile<String>(
                title: const Text('Regular'),
                value: 'regular',
                groupValue: selectedMember,
                onChanged: (value) {
                  setState(() {
                    selectedMember = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Premium'),
                value: 'premium',
                groupValue: selectedMember,
                onChanged: (value) {
                  setState(() {
                    selectedMember = value;
                  });
                },
              ),
              const SizedBox(height: 8.0),
              TextButton(
                onPressed: () async {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text(
                  "Already have an account? Login Now",
                  style: TextStyle(
                    color: Color(0xFF37465D),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () async {
                  await _registerUser();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF37465D),
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 24.0),
                  minimumSize: const Size(200, 60.0),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
