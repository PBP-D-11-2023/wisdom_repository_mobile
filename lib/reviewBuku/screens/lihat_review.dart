import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:wisdom_repository_mobile/auth_bookmark/screens/list_bookmark.dart';
import 'package:wisdom_repository_mobile/daftarBuku/models/buku.dart';
import 'package:wisdom_repository_mobile/daftarBuku/screens/list_buku.dart';
import 'package:http/http.dart' as http;
import 'package:wisdom_repository_mobile/reviewBuku/models/review.dart';

class ReviewBuku extends StatefulWidget {
  final Buku buku;

  const ReviewBuku({Key? key, required this.buku}) : super(key: key);

  @override
  _ReviewBukuState createState() => _ReviewBukuState();
}

class _ReviewBukuState extends State<ReviewBuku> {
  late Future<List<Review>> _reviewsFuture;

  Future<List<Review>> fetchReviews(int bukuId) async {
    final response = await http.get(
      Uri.parse('https://wisdomrepository--wahyuridho5.repl.co/review/show-review-json/$bukuId/'),

      //TESTING
      // Uri.parse('http://127.0.0.1:8000/review/show-review-json/$bukuId/'),
    );

    if (response.statusCode == 200) {
      return reviewFromJson(response.body);
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  @override
  void initState() {
    super.initState();
    _reviewsFuture = fetchReviews(widget.buku.pk); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.buku.fields.judul),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.network(widget.buku.fields.gambar, height: 200),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(widget.buku.fields.judul, style: Theme.of(context).textTheme.headline6),
              ),
              Text(widget.buku.fields.penulis, style: Theme.of(context).textTheme.subtitle1),
              Text('Published in ${widget.buku.fields.tahun}', style: Theme.of(context).textTheme.subtitle2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  Text(widget.buku.fields.rating.toString()),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text('Reviews:', style: Theme.of(context).textTheme.headline6),
              ),
              FutureBuilder<List<Review>>(
                future: _reviewsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data!
                          .map(
                            (review) => ListTile(
                              title: Text(review.fields.reviewText),
                              subtitle: Text(
                                'Reviewed on: ${review.fields.createdAt.toLocal()}',
                              ),
                            ),
                          )
                          .toList(),
                    );
                  } else {
                    return Text('No reviews found');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}