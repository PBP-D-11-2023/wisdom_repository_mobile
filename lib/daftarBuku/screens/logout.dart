// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:wisdom_repository_mobile/auth_bookmark/screens/login.dart';
import 'package:wisdom_repository_mobile/auth_bookmark/screens/register.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Image.asset(
              'assets/images/home.png',
              height: 150,
              fit: BoxFit.fill,
            ),
            Expanded(
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final response = await request.logout(
                        "https://wisdomrepository--wahyuridho5.repl.co/logout-flutter/");
                    String message = response["message"];
                    if (response['status']) {
                      String uname = response["username"];
                      if(uname != "") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("$message Sampai jumpa, $uname."),
                        ));
                        member = "";
                      }
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(message),
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    backgroundColor: member!= "" ? const Color(0xFFFC726F) : const Color(0xFF4DC7BF),
                    minimumSize:
                        const Size(150, 50), // Set the desired size here
                  ),
                  child: Text(
                    member!= "" ? 'Logout' : 'Login',
                    style: const TextStyle(
                      color: Color(0xFF37465D),
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
