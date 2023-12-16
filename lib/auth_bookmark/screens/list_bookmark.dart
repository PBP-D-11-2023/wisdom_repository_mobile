// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:wisdom_repository_mobile/adminBuku/screens/logout.dart';
import 'dart:convert';
import 'package:wisdom_repository_mobile/auth_bookmark/models/bookmark.dart';

class BookmarkPage extends StatefulWidget {
    const BookmarkPage({Key? key}) : super(key: key);

    @override
    _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
@override
Widget build(BuildContext context) {
  final request = context.watch<CookieRequest>();
  Future<List<Bookmark>> fetchProduct() async {
      // Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
      var response = await request.get(
          'https://wisdomrepository--wahyuridho5.repl.co/get-bookmark-user/'
      );

      // melakukan decode response menjadi bentuk json
      var data = response;

      // melakukan konversi data json menjadi object Product
      List<Bookmark> listBookmark = [];
      for (var d in data) {
          if (d != null) {
              listBookmark.add(Bookmark.fromJson(d));
          }
      }
      return listBookmark;
  }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmark'),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned(
            child: Image.asset(
               'assets/images/background_bookmark.png',
              fit: BoxFit.cover,
            ),
          ),
          // Teks di atas background image
          const Positioned(
            top: 20,
            left: 16,
            child: Text(
              'Daftar Bookmark',
              style: TextStyle(
                color: Color(0x0037465d),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // FutureBuilder untuk daftar bookmark
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            bottom: 0,
            child: FutureBuilder(
              future: fetchProduct(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    if (!snapshot.hasData || snapshot.data.isEmpty) {
                      return const Center(
                        child: Text(
                          "Tidak ada bookmark.",
                          style: TextStyle(
                            color: Color(0xff59A5D8),
                            fontSize: 20,
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) => GestureDetector(
                          child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Colors.white, 
                            borderRadius: BorderRadius.circular(10), // Mengatur sudut (radius) kotak
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: const Offset(0, 3), // Mengatur bayangan (shadow) kotak
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(snapshot.data![index].fields.gambar),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start, // Added CrossAxisAlignment
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${snapshot.data![index].fields.judul}",
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          int bookmarkId = snapshot.data![index].pk; 
                                          final response = await request.post(
                                            'https://wisdomrepository--wahyuridho5.repl.co/delete-bookmark-flutter/',
                                            jsonEncode(<String, int>{
                                              'id_buku' : bookmarkId
                                            })
                                          );
                                          if (response['status']){
                                            String message = "Berhasil menghapus buku ${snapshot.data![index].fields.judul}";
                                            setState(() {
                                              snapshot.data!.removeAt(index);
                                            });
                                            // ignore: use_build_context_synchronously
                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(
                                                SnackBar(content: Text("$message!")),
                                              );
                                            print('Permintaan hapus berhasil');
                                            // Lakukan tindakan yang diperlukan setelah penghapusan berhasil
                                            fetchProduct();
                                          } else {
                                            print('Permintaan hapus tidak berhasil');
                                          }
                                        } catch (error) {
                                          print('Error: $error');
                                        }
                                      },
                                      child: const Text('Delete'),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: (){
                                      Navigator.pushReplacement(
                                        context,
                                      MaterialPageRoute(builder: (context) => const LogoutPage()),
                                      );
                                    }, 
                                    child: const Text('Pinjam'),
                                  ),
                                  const SizedBox(height: 10),
                                ], // Added closing bracket for children of Column
                              ), // Added closing bracket for Column
                            ], // Added closing bracket for children of Row
                          ),
                        ),
                        ),
                      );
                    }
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}