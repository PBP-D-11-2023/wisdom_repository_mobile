import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:wisdom_repository_mobile/main.dart';
import 'package:wisdom_repository_mobile/auth_bookmark/models/bookmark.dart';
import 'package:wisdom_repository_mobile/pinjamBuku/widgets/bottomnavbar.dart';
import 'package:wisdom_repository_mobile/pinjamBuku/screens/pinjam_buku.dart';

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
                    return 
                    ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => GestureDetector(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(snapshot.data![index].fields.gambar),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start, // Added CrossAxisAlignment
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailPinjamBuku(
                                            idBuku: snapshot.data![index].fields.buku,
                                          ),
                                        ),
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
            }),
            bottomNavigationBar: CustomBottomNavigationBar(),
            );
    }
}

