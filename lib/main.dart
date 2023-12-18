import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:wisdom_repository_mobile/auth_bookmark/screens/login.dart';
import 'package:google_fonts/google_fonts.dart';

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
                title: 'Flutter App',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF37465D)),
                    useMaterial3: true,
                    scaffoldBackgroundColor: const Color(0xFFF5F2ED),
                    fontFamily: GoogleFonts.inknutAntiqua().fontFamily,
                ),
                home: const LoginPage(),
            ),
        );
    }
}
