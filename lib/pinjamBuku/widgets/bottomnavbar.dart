import 'package:flutter/material.dart';
import 'package:wisdom_repository_mobile/pinjamBuku/screens/list_pinjam.dart';
import 'package:wisdom_repository_mobile/pinjamBuku/screens/list_pengembalian.dart';
import 'package:wisdom_repository_mobile/daftarBuku/screens/list_buku.dart';

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
              // Handle Home button tap
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const BukuPage()),
              );
            }),
            _buildButton(IconData(0xeee2, fontFamily: 'MaterialIcons'), () {
              // Handle Books button tap
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const BukuPage()),
              );
            }),
            _buildButton(Icons.library_books, () {
            // Handle Add button tap
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PeminjamanPage()),
              );
            }),
            _buildButton(Icons.assignment_turned_in, () {
              // Handle Add button tap
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PengembalianPage()),
              );
            }),
            _buildButton(Icons.person, () {
              // Handle Profile button tap
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const BukuPage()),
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
