import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wisdom_repository_mobile/daftarBuku/models/buku.dart';
import 'package:wisdom_repository_mobile/daftarBuku/screens/detail_buku.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:wisdom_repository_mobile/daftarBuku/models/rating.dart';

class BukuPage extends StatefulWidget {
  const BukuPage({Key? key}) : super(key: key);

  @override
  _BukuPageState createState() => _BukuPageState();
}

class _BukuPageState extends State<BukuPage> {
  late List<Buku> _filteredBuku;
  late List<Buku> _bukuSemua;
  late List<Rating> _test;
  late TextEditingController _searchController;
  String _searchText = '';
  bool _booksFetched = false;

  @override
  void initState() {
    super.initState();
    _filteredBuku = [];
    _searchController = TextEditingController();
    _bukuSemua = [];
    _test = [];
  }

  Future<List<Buku>> fetchBuku() async {
    if (!_booksFetched) {
      final request = context.watch<CookieRequest>();
      final response = await request.get(
        'http://127.0.0.1:8000/main/get_books_json/',
      );

      List<Buku> buku = [];
      for (var i in response) {
        if (i != null) buku.add(Buku.fromJson(i));
      }
      _bukuSemua = buku;
      _booksFetched = true;
      fetchRating();
      setState(() {
        _filteredBuku = _bukuSemua;
      });
      return buku;
    } else {
      return _bukuSemua;
    }
  }

  void fetchRating() async {
    //use http get
    var response;
    response =
        await http.post(Uri.parse('http://127.0.0.1:8000/main/get_rating/'));

 
    List<Rating> rating = [];
    var data = jsonDecode(response.body);
    for (var i in data) {
      if (i != null) rating.add(Rating.fromJson(i));
    }
    for (var i in _bukuSemua) {
      for (var j in rating) {
        if (j.pk == i.fields.rating) {
          i.fields.rating = double.parse(j.fields.rating);
        }
      }
    }
  }


  void _filterBuku(String query) {
    List<Buku> filteredList = _bukuSemua
        .where((buku) =>
            buku.fields.judul.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredBuku = filteredList;
    });
  }

  void _filterGenre(String query) {
    List<Buku> filteredList = _bukuSemua
        .where((buku) =>
            buku.fields.kategori.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredBuku = filteredList;
    });
  }

  void sortBuku(String nama) async {
    var response;
    if (nama == "judul") {
      response = await http
          .post(Uri.parse('http://127.0.0.1:8000/main/sortjson/judul'));
    } else if (nama == "tahun") {
      response = await http
          .post(Uri.parse('http://127.0.0.1:8000/main/sortjson/tahun'));
    } else if (nama == "rating") {
      response = await http
          .post(Uri.parse('http://127.0.0.1:8000/main/sortjson/rating'));
    }

    List<Buku> buku = [];
    var data = jsonDecode(response.body);
    for (var i in data) {
      if (i != null) buku.add(Buku.fromJson(i));
    }
    _bukuSemua = buku;
    fetchRating();
    setState(() {
      _filteredBuku = _bukuSemua;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Buku"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Cari Buku',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String? value) {
                      _searchText = value!;
                    },
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    _filterBuku(_searchText);
                  },
                  child: Text('Cari'),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  sortBuku('judul');
                },
                child: Text('Judul'),
              ),
              ElevatedButton(
                onPressed: () {
                  sortBuku('rating');
                },
                child: Text('Rating'),
              ),
              ElevatedButton(
                onPressed: () {
                  sortBuku('tahun');
                },
                child: Text('Tahun'),
              ),
            ],
          ),
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _filterGenre('Fiction');
                },
                child: Text('Fiction'),
              ),
              ElevatedButton(
                onPressed: () {
                  _filterGenre('Drama');
                },
                child: Text('Drama'),
              ),
              ElevatedButton(
                onPressed: () {
                  _filterGenre('Adventure');
                },
                child: Text('Adventure'),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<Buku>>(
              future: fetchBuku(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: _filteredBuku.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading:
                              Image.network(_filteredBuku[index].fields.gambar),
                          title: Text(_filteredBuku[index].fields.judul),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailBuku(
                                  buku: _filteredBuku[index],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}