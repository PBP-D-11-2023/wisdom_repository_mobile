// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:wisdom_repository_mobile/daftarBuku/models/buku.dart';
import 'package:wisdom_repository_mobile/pinjamBuku/screens/pinjam_buku.dart';
import 'package:wisdom_repository_mobile/reviewBuku/screens/lihat_review.dart';
import 'package:wisdom_repository_mobile/auth_bookmark/screens/register.dart';

class DetailBuku extends StatelessWidget {
  final Buku buku;

  const DetailBuku({Key? key, required this.buku}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/images/banner.png',
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Center(
                        child: Container(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            color: Colors.white,
                            height: 175,
                            width: 125,
                            child: Hero(
                              tag: buku.pk,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(buku.fields.gambar),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  buku.fields.judul,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  buku.fields.penulis,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  '${buku.fields.rating.toString()}/5',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  buku.fields.tahun.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  buku.fields.kategori,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
                  ),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (member != "")
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Details",
                              style: TextStyle(fontSize: 20),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // lihat review
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ReviewBuku(buku: buku),
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              child: const Text(
                                'Lihat Review',
                                style: TextStyle(
                                  color: Color(0xFF37465D),
                                ),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity, // Set the width to full
                        height: 400,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xFF37465D), width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              member == ""
                                  ? "Anda perlu login"
                                  : buku.fields.deskripsi,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              backgroundColor: const Color(0xFF37465D),
                            ),
                            child: const Text(
                              'Back',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (member != "")
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    // bookmark
                                    int bookId = buku.pk;
                                    final response = await request.post(
                                        'https://wisdomrepository--wahyuridho5.repl.co/add-bookmark-ajax/',

                                        //TESTING
                                        // 'http://127.0.0.1:8000/add-bookmark-ajax/',
                                        jsonEncode(
                                            <String, int>{'id_buku': bookId}));
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
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    backgroundColor: const Color(0xFF4CB9E7),
                                  ),
                                  child: const Text(
                                    'Bookmark',
                                    style: TextStyle(
                                      color: Color(0xFF3B375D),
                                    ),
                                  ), // Add your button text here
                                ),
                                const SizedBox(width: 2),
                                ElevatedButton(
                                  onPressed: () {
                                    // pinjam
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailPinjamBuku(
                                          idBuku: buku.pk,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    backgroundColor: const Color(0xFF4DC7BF),
                                  ),
                                  child: const Text(
                                    'Pinjam',
                                    style: TextStyle(
                                      color: Color(0xFF37465D),
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ],
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
