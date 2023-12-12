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
    var response = await http.post(Uri.parse(
        'https://wisdomrepository--wahyuridho5.repl.co/main/get_rating/'));

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/images/home.png',
                height: 150,
                fit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40.0,
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                labelText: 'Cari Buku',
                                labelStyle: const TextStyle(
                                  color: Color(0xFF37465D),
                                ),
                                filled: true,
                                fillColor:
                                    const Color(0xFF000000).withOpacity(0.07),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                              ),
                              onChanged: (String? value) {
                                _searchText = value!;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        ElevatedButton(
                          onPressed: () {
                            _filterBuku(_searchText);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF37465D),
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () {
                                _filterGenre('Fiction');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF37465D),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Fiction'),
                            ),
                          ),
                          const SizedBox(width: 4),
                          SizedBox(
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () {
                                _filterGenre('Drama');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF37465D),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Drama'),
                            ),
                          ),
                          const SizedBox(width: 4),
                          SizedBox(
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () {
                                _filterGenre('Adventure');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF37465D),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Adventure'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.48,
                      child: FutureBuilder<List<RequestBuku>>(
                        future: fetchBuku(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: _filteredBuku.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 2,
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Hero(
                                              tag: _filteredBuku[index].pk,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: SizedBox(
                                                  height: 100,
                                                  child: Image.network(
                                                      _filteredBuku[index]
                                                          .fields
                                                          .gambar),
                                                ),
                                              ),
                                            )),
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                              _filteredBuku[index].fields.judul,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ))
                                      ],
                                    ),
                                  ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
