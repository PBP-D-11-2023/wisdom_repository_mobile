import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:wisdom_repository_mobile/daftarBuku/models/rating.dart';
import 'package:wisdom_repository_mobile/adminBuku/screens/buku_form.dart';
import 'package:wisdom_repository_mobile/adminBuku/models/requestBuku.dart';
import 'package:wisdom_repository_mobile/adminBuku/screens/detail_request.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  late List<RequestBuku> _filteredBuku;
  late List<RequestBuku> _bukuSemua;
  late TextEditingController _searchController;
  String _searchText = '';
  bool _booksFetched = false;

  @override
  void initState() {
    super.initState();
    _filteredBuku = [];
    _searchController = TextEditingController();
    _bukuSemua = [];
  }

  Future<List<RequestBuku>> fetchBuku() async {
    if (!_booksFetched) {
      final request = context.watch<CookieRequest>();
      final response = await request.get(
        'https://wisdomrepository--wahyuridho5.repl.co/admin-buku/get-request-books/',
      );

      List<RequestBuku> buku = [];
      for (var i in response) {
        if (i != null) buku.add(RequestBuku.fromJson(i));
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
    var response =
        await http.post(Uri.parse('https://wisdomrepository--wahyuridho5.repl.co/main/get_rating/'));

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
    List<RequestBuku> filteredList = _bukuSemua
        .where((buku) =>
            buku.fields.judul.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredBuku = filteredList;
    });
  }

  void _filterGenre(String query) {
    List<RequestBuku> filteredList = _bukuSemua
        .where((buku) =>
            buku.fields.kategori.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredBuku = filteredList;
    });
  }

  void tambahBuku() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BukuFormPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Request Buku"),
        automaticallyImplyLeading: false,
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
                    decoration: const InputDecoration(
                      labelText: 'Cari Buku',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String? value) {
                      _searchText = value!;
                    },
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    _filterBuku(_searchText);
                  },
                  child: const Text('Cari'),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _filterGenre('Fiction');
                },
                child: const Text('Fiction'),
              ),
              ElevatedButton(
                onPressed: () {
                  _filterGenre('Drama');
                },
                child: const Text('Drama'),
              ),
              ElevatedButton(
                onPressed: () {
                  _filterGenre('Adventure');
                },
                child: const Text('Adventure'),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<RequestBuku>>(
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
                                builder: (context) => DetailRequest(
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
