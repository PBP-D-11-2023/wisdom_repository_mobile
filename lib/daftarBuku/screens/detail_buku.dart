import 'package:flutter/material.dart';
import 'package:wisdom_repository_mobile/daftarBuku/models/buku.dart';
import 'package:wisdom_repository_mobile/daftarBuku/screens/list_buku.dart';

class DetailBuku extends StatelessWidget {
  final Buku buku;
  

  const DetailBuku({Key? key, required this.buku}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(buku.fields.judul),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(buku.fields.gambar),
            Text(buku.fields.judul),
            Text(buku.fields.penulis),
            Text(buku.fields.deskripsi),
            Text(buku.fields.kategori),
            Text(buku.fields.tahun.toString()),
            Text(buku.fields.rating.toString()),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // pinjam
              },
              child: Text('Pinjam'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // lihat review
              },
              child: Text('Lihat Review'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // bookmark
      

              },
              child: Text('Bookmark'),
            ),
          ],
        ),
      ),
    );
  }
}
