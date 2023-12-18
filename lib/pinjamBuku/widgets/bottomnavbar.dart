import 'package:flutter/material.dart';
import 'package:wisdom_repository_mobile/pinjamBuku/screens/list_pinjam.dart';
import 'package:wisdom_repository_mobile/pinjamBuku/screens/list_pengembalian.dart';
import 'package:wisdom_repository_mobile/daftarBuku/screens/list_buku.dart';
import 'package:wisdom_repository_mobile/auth_bookmark/screens/list_bookmark.dart';
import 'package:wisdom_repository_mobile/adminBuku/screens/logout.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 61,
        color: const Color(0xFF37465D),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton(IconData(0xf107, fontFamily: 'MaterialIcons'), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const BukuPage()),
              );
            }),
            _buildButton(IconData(0xeee2, fontFamily: 'MaterialIcons'), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const BookmarkPage()),
              );
            }),
            _buildButton(Icons.library_books, () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PeminjamanPage()),
              );
            }),
            _buildButton(Icons.assignment_turned_in, () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PengembalianPage()),
              );
            }),
            _buildButton(Icons.person, () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AdjustedLogoutPage()),
              );
            }),
          ],
        ),
    );
  }

  Widget _buildButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class AdjustedLogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const LogoutPage(), // Your desired body widget (e.g., LogoutPage)
      bottomNavigationBar: CustomBottomNavigationBar(), // Your desired bottom navigation bar
    );
  }
}