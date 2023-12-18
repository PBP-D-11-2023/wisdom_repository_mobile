import 'package:flutter/material.dart';
import 'package:wisdom_repository_mobile/daftarBuku/models/buku.dart';
import 'package:http/http.dart' as http;
import 'package:wisdom_repository_mobile/reviewBuku/models/review.dart';

class ReviewBuku extends StatefulWidget {
  final Buku buku;

  const ReviewBuku({Key? key, required this.buku}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ReviewBukuState createState() => _ReviewBukuState();
}

class _ReviewBukuState extends State<ReviewBuku> {
  late Future<List<Review>> _reviewsFuture;

  Future<List<Review>> fetchReviews(int bukuId) async {
    final response = await http.get(
      Uri.parse(
          'https://wisdomrepository--wahyuridho5.repl.co/review/show-review-json/$bukuId/'),

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
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.buku.fields.judul,
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              Text(widget.buku.fields.penulis,
                  style: Theme.of(context).textTheme.titleMedium),
              Text('Published in ${widget.buku.fields.tahun}',
                  style: Theme.of(context).textTheme.titleSmall),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  Text(widget.buku.fields.rating.toString()),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text('Reviews:',
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              FutureBuilder<List<Review>>(
                future: _reviewsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
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
                    return const Text('No reviews found');
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
