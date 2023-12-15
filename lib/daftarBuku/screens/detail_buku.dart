// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:wisdom_repository_mobile/auth_bookmark/screens/list_bookmark.dart';
import 'package:wisdom_repository_mobile/daftarBuku/models/buku.dart';
import 'package:wisdom_repository_mobile/daftarBuku/screens/list_buku.dart';
import 'package:http/http.dart' as http;

class DetailBuku extends StatelessWidget {
  final Buku buku;
  

  const DetailBuku({Key? key, required this.buku}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
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
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                // bookmark
                int bookId = buku.pk;
                final response = await request.post(
                  'https://wisdomrepository--wahyuridho5.repl.co/add-bookmark-ajax/',
                  jsonEncode(<String, int>{
                    'id_buku' : bookId
                  })
                );
                String message = response['message'];
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Bookmark'),
                      content: Text('$message !'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (BuildContext context) => const BookmarkPage(),
                            ));
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
            
              },
              child: const Text('Bookmark'), // Add your button text here
            ),
          ],
        ),
      ),
    );
  }
}
