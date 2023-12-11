import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wisdom_repository_mobile/main.dart';
import 'package:wisdom_repository_mobile/auth_bookmark/models/bookmark.dart';

class BookmarkPage extends StatefulWidget {
    const BookmarkPage({Key? key}) : super(key: key);

    @override
    _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
@override
Widget build(BuildContext context) {
  Future<List<Bookmark>> fetchProduct() async {
      // Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
      var url = Uri.parse(
          'https://wisdomrepository--wahyuridho5.repl.co/get_bookmark_user/');
      var response = await http.get(
          url,
      );

      // melakukan decode response menjadi bentuk json
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      // melakukan konversi data json menjadi object Product
      List<Bookmark> list_bookmark = [];
      for (var d in data) {
          if (d != null) {
              list_bookmark.add(Bookmark.fromJson(d));
          }
      }
      return list_bookmark;
  }
    return Scaffold(
        appBar: AppBar(
        title: const Text('Bookmark'),
        ),
        body: FutureBuilder(
            future: fetchProduct(),
            builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                } else {
                    if (!snapshot.hasData) {
                    return const Column(
                        children: [
                        Text(
                            "Tidak ada bookmark.",
                            style:
                                TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                        ),
                        SizedBox(height: 8),
                        ],
                    );
                } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => GestureDetector(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${snapshot.data![index].fields.judul}",
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text("${snapshot.data![index].fields.gambar}"),
                            ],
                          ),
                        ),
                      ),
                    );

                    }
                }
            }));
    }
}