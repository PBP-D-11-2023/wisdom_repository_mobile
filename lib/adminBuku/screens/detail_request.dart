// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:wisdom_repository_mobile/adminBuku/screens/admin.dart';
import 'package:wisdom_repository_mobile/adminBuku/models/requestBuku.dart';

class DetailRequest extends StatelessWidget {
  final RequestBuku buku;

  const DetailRequest({Key? key, required this.buku}) : super(key: key);

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
                    width: double.infinity,
                    height: 250,
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
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(buku.fields.gambar),
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
                    const Text(
                      "Details",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity, // Set the width to full
                      height: 400,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF37465D), width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            buku.fields.deskripsi,
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
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                // Kirim ke Django dan tunggu respons
                                final response = await request.postJson(
                                  "https://wisdomrepository--wahyuridho5.repl.co/admin-buku/acc-request-book-flutter/",
                                  jsonEncode(<String, String>{
                                    'bookID': buku.pk.toString(),
                                    'isbn': buku.fields.isbn,
                                    'judul': buku.fields.judul,
                                    'penulis': buku.fields.penulis,
                                    'tahun': buku.fields.tahun.toString(),
                                    'kategori': buku.fields.kategori,
                                    'gambar': buku.fields.gambar,
                                    'deskripsi': buku.fields.deskripsi,
                                    'rating': buku.fields.rating.toString(),
                                  }),
                                );
                                if (response['status'] == 'success') {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                        "Request buku berhasil disetujui!"),
                                  ));
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AdminPage(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                        "Terdapat kesalahan, silakan coba lagi."),
                                  ));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                backgroundColor: const Color(0xFF4DC7BF),
                              ),
                              child: const Text(
                                'Setujui',
                                style: TextStyle(
                                  color: Color(0xFF37465D),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () async {
                                final response = await request.postJson(
                                    "https://wisdomrepository--wahyuridho5.repl.co/admin-buku/delete-request-book-flutter/",
                                    jsonEncode(<String, String>{
                                      'bookID': buku.pk.toString(),
                                    }));
                                if (response['status'] == 'success') {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content:
                                        Text("Request buku berhasil ditolak!"),
                                  ));
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AdminPage()),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                        "Terdapat kesalahan, silakan coba lagi."),
                                  ));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                backgroundColor: const Color(0xFFFC726F),
                              ),
                              child: const Text(
                                'Tolak',
                                style: TextStyle(
                                  color: Color(0xFF37465D),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
