// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:wisdom_repository_mobile/pinjamBuku/screens/list_pinjam.dart';
import 'package:wisdom_repository_mobile/daftarBuku/widgets/bottom_navbar.dart';

class DetailPinjamBuku extends StatelessWidget {
  final int idBuku;

  const DetailPinjamBuku({Key? key, required this.idBuku}) : super(key: key);

  Future<Map<String, dynamic>> fetchItem(CookieRequest request) async {
    var response = await request.get(
        'https://wisdomrepository--wahyuridho5.repl.co/borrow/peminjamanjsonidbuku/$idBuku');
    return response;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Peminjaman Buku'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchItem(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Data loaded successfully, you can access JSON data using snapshot.data
            final jsonData = snapshot.data;
            return jsonData != null
                ? SingleChildScrollView(
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
                                        tag: idBuku,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child:
                                              Image.network(jsonData["gambar"]),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            jsonData["judul"],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            jsonData["penulis"],
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          Text(
                                            '${jsonData["rating"]}/5',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          Text(
                                            jsonData["tahun"],
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          Text(
                                            jsonData["kategori"],
                                            style: const TextStyle(
                                                color: Colors.white),
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
                              jsonData["dipinjam_member"]
                                  ? const Text(
                                      "Buku ini saat ini sedang dipinjam olehmu",
                                      style: TextStyle(fontSize: 16),
                                    )
                                  : !jsonData["dipinjam"]
                                      ? const Text(
                                          "Buku ini saat ini sedang dipinjam oleh member lain.",
                                          style: TextStyle(fontSize: 16),
                                        )
                                      : jsonData["overlimit"]
                                          ? const Text(
                                              "Batas peminjaman tercapai. Kembalikan buku yang sudah dipinjam untuk meminjam buku ini",
                                              style: TextStyle(fontSize: 16),
                                            )
                                          : const Text(
                                              "Detail Peminjaman",
                                              style: TextStyle(fontSize: 20),
                                            ),
                              jsonData["final"]
                                  ? Text(
                                      'Username: ${jsonData["username"]}',
                                      style: const TextStyle(fontSize: 16),
                                    )
                                  : const Text(
                                      '', // default message
                                      style: TextStyle(fontSize: 16),
                                    ),
                              jsonData["final"]
                                  ? Text(
                                      'Member: ${jsonData["member"]}',
                                      style: const TextStyle(fontSize: 16),
                                    )
                                  : const Text(
                                      '', // default message
                                      style: TextStyle(fontSize: 16),
                                    ),
                              jsonData["final"]
                                  ? Text(
                                      'Tanggal Peminjaman: ${jsonData["hari_dipinjam"]}',
                                      style: const TextStyle(fontSize: 16),
                                    )
                                  : const Text(
                                      '', // default message
                                      style: TextStyle(fontSize: 16),
                                    ),
                              jsonData["final"]
                                  ? Text(
                                      'Tanggal Pengembalian: ${jsonData["hari_kembali"]}',
                                      style: const TextStyle(fontSize: 16),
                                    )
                                  : const Text(
                                      '', // default message
                                      style: TextStyle(fontSize: 16),
                                    ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      jsonData["final"]
                                          ? ElevatedButton(
                                              onPressed: () async {
                                                final response =
                                                    await request.postJson(
                                                        "https://wisdomrepository--wahyuridho5.repl.co/borrow/peminjamanflutter/",
                                                        jsonEncode(<String,
                                                            String>{
                                                          'idBuku':
                                                              idBuku.toString(),
                                                        }));
                                                if (response['status'] ==
                                                    'success') {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                    content: Text(
                                                        "Buku berhasil dipinjam!"),
                                                  ));
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const PeminjamanPage()),
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                    content: Text(
                                                        "Terdapat kesalahan, silakan coba lagi."),
                                                  ));
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                ),
                                                backgroundColor:
                                                    const Color(0xFF4DC7BF),
                                              ),
                                              child: const Text(
                                                'Pinjam',
                                                style: TextStyle(
                                                  color: Color(0xFF37465D),
                                                ),
                                              ),
                                            )
                                          : const Text(
                                              '', // default message
                                              style: TextStyle(fontSize: 16),
                                            ),
                                      const SizedBox(width: 8),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : const Text('No data');
          }
        },
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
