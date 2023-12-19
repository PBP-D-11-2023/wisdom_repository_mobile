// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:wisdom_repository_mobile/auth_bookmark/models/bookmark.dart';
import 'package:wisdom_repository_mobile/pinjamBuku/screens/pinjam_buku.dart';
import 'package:wisdom_repository_mobile/daftarBuku/widgets/bottom_navbar.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    Future<List<Bookmark>> fetchProduct() async {
      var response = await request.get(
          'https://wisdomrepository--wahyuridho5.repl.co/get-bookmark-user/');

      var data = response;

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
        automaticallyImplyLeading: false,
        title: const Text('Bookmark'),
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/images/background_bookmark.png',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Boookmark',
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
          FutureBuilder(
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
                      return const Column(
                        children: [
                          Text(
                            "Tidak ada bookmark.",
                            style: TextStyle(
                              color: Color(0xff59A5D8),
                              fontSize: 20,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'List of books:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF37465D),
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final bookmark = snapshot.data![index];
                              return GestureDetector(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  padding: const EdgeInsets.all(20.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        bookmark.fields.gambar,
                                        height: 120,
                                        width: 75,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${bookmark.fields.judul}",
                                              style: const TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF37465D),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 252, 214, 214),
                                                elevation: 5,
                                              ),
                                              onPressed: () async {
                                                try {
                                                  int bookmarkId = bookmark.pk;
                                                  final response =
                                                      await request.post(
                                                    'https://wisdomrepository--wahyuridho5.repl.co/delete-bookmark-flutter/',
                                                    jsonEncode(<String, int>{
                                                      'id_buku': bookmarkId
                                                    }),
                                                  );
                                                  if (response['status']) {
                                                    String message =
                                                        "Berhasil menghapus buku ${bookmark.fields.judul}";
                                                    setState(() {
                                                      snapshot.data!
                                                          .removeAt(index);
                                                    });
                                                    ScaffoldMessenger.of(
                                                        context)
                                                      ..hideCurrentSnackBar()
                                                      ..showSnackBar(
                                                        SnackBar(
                                                          content:
                                                              Text("$message!"),
                                                        ),
                                                      );
                                                    print(
                                                        'Permintaan hapus berhasil');
                                                    fetchProduct();
                                                  } else {
                                                    print(
                                                        'Permintaan hapus tidak berhasil');
                                                  }
                                                } catch (error) {
                                                  print('Error: $error');
                                                }
                                              },
                                              child: const Text('Delete'),
                                            ),
                                            const SizedBox(height: 10),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 204, 247, 227),
                                                elevation: 5,
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailPinjamBuku(
                                                      idBuku:
                                                          bookmark.fields.buku,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: const Text('Pinjam'),
                                            ),
                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.bookmark,
                                        color: Color(0xFF37465D),
                                        size:
                                            24, // Set the size of the bookmark icon
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }
                  }
                }
              }),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }

  Stack newMethod(
      Future<List<Bookmark>> fetchProduct(), CookieRequest request) {
    return Stack(
      children: [
        Positioned(
          top: 0,
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
                    return const Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [],
                    );
                  }
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
