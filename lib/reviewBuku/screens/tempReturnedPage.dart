import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wisdom_repository_mobile/daftarBuku/models/buku.dart';
import 'package:wisdom_repository_mobile/reviewBuku/models/tempReturned.dart';
import 'package:wisdom_repository_mobile/reviewBuku/widgets/bottomSheetReview.dart';

class ReturnedBooksPage extends StatefulWidget {
  @override
  _ReturnedBooksPageState createState() => _ReturnedBooksPageState();
}

class _ReturnedBooksPageState extends State<ReturnedBooksPage> {
  late Future<List<Buku>> futureReturnedBooks;

  @override
  void initState() {
    super.initState();
    futureReturnedBooks = fetchReturnedBookDetails();
  }

  Future<List<Buku>> fetchReturnedBookDetails() async {
  final tempReturnedResponse = await http.get(
    Uri.parse('https://wisdomrepository--wahyuridho5.repl.co/review/show-returned-json/'),

    //TESTING
    // Uri.parse('http://127.0.0.1:8000/review/show-returned-json/'),
    headers: {"Content-Type": "application/json"},
  );

  if (tempReturnedResponse.statusCode == 200) {
    List<dynamic> tempReturnedData = jsonDecode(tempReturnedResponse.body);
    List<TempReturned> tempReturnedBooks = tempReturnedData.map((e) => TempReturned.fromJson(e)).toList();
    List<int> bookIds = tempReturnedBooks.map((e) => e.fields.buku).toList();

    List<Buku> returnedBooks = [];
    for (var bookId in bookIds) {
      final bookResponse = await http.get(
        Uri.parse('https://wisdomrepository--wahyuridho5.repl.co/review/get-book-json/$bookId/'),

        //TESTING
        // Uri.parse('http://127.0.0.1:8000/review/get-book-json/$bookId/'),
        headers: {"Content-Type": "application/json"},
      );

      if (bookResponse.statusCode == 200) {
        var decodedResponse = jsonDecode(bookResponse.body);
        Buku bookDetails;
        if (decodedResponse is List) {
          bookDetails = Buku.fromJson(decodedResponse.first);
        } else {
          bookDetails = Buku.fromJson(decodedResponse);
        }
        returnedBooks.add(bookDetails);
      }
    }
    return returnedBooks;
  } else {
    throw Exception('Failed to load returned books');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Returned Books'),
      ),
      body: FutureBuilder<List<Buku>>(
        future: futureReturnedBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No returned books found'));
          } else {
            List<Buku> returnedBooks = snapshot.data!;
            return ListView.builder(
              itemCount: returnedBooks.length,
              itemBuilder: (context, index) {
                Buku book = returnedBooks[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(book.fields.gambar), // Assuming `gambar` holds a valid image URL
                    title: Text(book.fields.judul),
                    subtitle: Text(book.fields.penulis),
                    trailing: TextButton(
                      onPressed: () => showReviewSheet(context, book),
                      child: Text('Review'),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}