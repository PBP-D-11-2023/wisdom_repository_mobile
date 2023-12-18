import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wisdom_repository_mobile/daftarBuku/models/buku.dart';
import 'package:wisdom_repository_mobile/daftarBuku/screens/list_buku.dart';
import 'package:wisdom_repository_mobile/pinjamBuku/screens/list_pengembalian.dart';

Future<bool> submitReview(int idBuku, String reviewText, int idPengembalian) async {
  final url = Uri.parse('https://wisdomrepository--wahyuridho5.repl.co/review/post-review-flutter/');

  //TESTING
  // final url = Uri.parse('http://127.0.0.1:8000/review/post-review-flutter/');
  final headers = {
    "Content-Type": "application/json",
  };
  final body = jsonEncode({
    'idBuku': idBuku,
    'review_text': reviewText,
    'idPengembalian': idPengembalian,
  });

  try {
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to submit review: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error occurred while sending review: $e');
    return false;
  }
}

void showReviewSheet(BuildContext context, Buku book, int idPengembalian) {
  TextEditingController reviewController = TextEditingController();

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Write your review for ${book.fields.judul}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: reviewController,
              decoration: InputDecoration(
                labelText: 'Your review',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                String reviewText = reviewController.text;
                bool success = await submitReview(book.pk, reviewText, idPengembalian);
                if (success) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => BukuPage()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Review submitted successfully')),
                  );
                } else {
                  // Show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to submit review')),
                  );
                }
                Navigator.pop(context); // Close the BottomSheet
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PengembalianPage()),
                );
              },
              child: Text('Submit Review'),
            ),
          ],
        ),
      );
    },
  );
}
