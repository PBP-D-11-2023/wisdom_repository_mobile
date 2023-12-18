// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:wisdom_repository_mobile/pinjamBuku/models/peminjaman.dart';
import 'package:intl/intl.dart';
import 'package:wisdom_repository_mobile/pinjamBuku/screens/list_pengembalian.dart';
import 'package:wisdom_repository_mobile/daftarBuku/widgets/bottom_navbar.dart';

class PeminjamanPage extends StatefulWidget {
  const PeminjamanPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PeminjamanPageState createState() => _PeminjamanPageState();
}

class _PeminjamanPageState extends State<PeminjamanPage> {
  Future<List<Peminjaman>> fetchPeminjaman(CookieRequest request) async {
    var response = await request.get(
        'https://wisdomrepository--wahyuridho5.repl.co/borrow/peminjamanjson/');
    List<Peminjaman> listPeminjaman = [];
    for (var d in response) {
      if (d != null) {
        listPeminjaman.add(Peminjaman.fromJson(d));
      }
    }
    return listPeminjaman;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Daftar Peminjaman'),
      ),
      body: FutureBuilder(
          future: fetchPeminjaman(request),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (!snapshot.hasData) {
                return const Column(
                  children: [
                    Text(
                      "Tidak ada buku yang dipinjam saat ini.",
                      style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                    ),
                    SizedBox(height: 8),
                  ],
                );
              } else {
                return ListView(
                  children: [
                    Stack(
                      children: [
                        Image.asset(
                          'assets/images/background_bookmark.png',
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        const Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Borrowed Books',
                                style: TextStyle(
                                  fontSize: 48,
                                  color: Color(0xFF37465D),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.all(10.0), // Adjust the values as needed
                      child: Text(
                        'List of books:',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          color: Colors.white,
                          elevation: 2,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Hero(
                                  tag: snapshot.data![index].idBuku,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: SizedBox(
                                      height: 150,
                                      width: 150,
                                      child: Image.network(
                                        snapshot.data![index].bukuGambar,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data![index].bukuJudul,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Tanggal dipinjam: ',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        DateFormat('MMMM d, y').format(
                                          snapshot.data![index].tanggalDipinjam,
                                        ),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const Text(
                                        'Tanggal dikembalikan: ',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        DateFormat('MMMM d, y').format(
                                          snapshot
                                              .data![index].tanggalPengembalian,
                                        ),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          final response = await request.postJson(
                                              "https://wisdomrepository--wahyuridho5.repl.co/borrow/pengembalianflutter/",
                                              jsonEncode(<String, String>{
                                                'idPeminjaman': snapshot
                                                    .data![index].pk
                                                    .toString(),
                                                'idBuku': snapshot
                                                    .data![index].idBuku
                                                    .toString(),
                                              }));
                                          if (response['status'] == 'success') {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Buku berhasil dikembalikan!"),
                                            ));
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const PengembalianPage()),
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
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          backgroundColor:
                                              const Color(0xFF37465D),
                                        ),
                                        child: const Text(
                                          'Return',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            }
          }),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
