import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:wisdom_repository_mobile/adminBuku/screens/buku_form.dart';
import 'package:wisdom_repository_mobile/adminBuku/screens/list_buku.dart';
import 'package:wisdom_repository_mobile/adminBuku/screens/list_request.dart';
import 'package:wisdom_repository_mobile/adminBuku/screens/logout.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int currentIndex = 0;

  void goToPage(index) {
    setState(() {
      currentIndex = index;
    });
  }

  final List _pages = [
    const BukuPage(),
    const BukuFormPage(),
    const RequestPage(),
    const LogoutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF37465D),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: GNav(
              onTabChange: (index) => goToPage(index),
              gap: 8,
              backgroundColor: const Color(0xFF37465D),
              color: const Color(0xFF4DC7BF),
              activeColor: const Color(0xFF37465D),
              tabBackgroundColor: const Color(0xFF4DC7BF),
              padding: const EdgeInsets.all(16),
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.add,
                  text: 'Add',
                ),
                GButton(
                  icon: Icons.request_page,
                  text: 'Request',
                ),
                GButton(
                  icon: Icons.logout,
                  text: 'Logout',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
