import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:wisdom_repository_mobile/adminBuku/screens/buku_form.dart';
import 'package:wisdom_repository_mobile/adminBuku/screens/list_buku.dart';
import 'package:wisdom_repository_mobile/adminBuku/screens/list_request.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: Container(
        color: Colors.black,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: GNav(
              onTabChange: (index) => goToPage(index),
              gap: 8,
              backgroundColor: Colors.black,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.grey.shade800,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
