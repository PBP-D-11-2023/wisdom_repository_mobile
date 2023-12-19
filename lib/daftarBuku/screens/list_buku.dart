import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:wisdom_repository_mobile/auth_bookmark/screens/register.dart';
import 'package:wisdom_repository_mobile/daftarBuku/models/buku.dart';
import 'package:wisdom_repository_mobile/daftarBuku/models/rating.dart';
import 'package:wisdom_repository_mobile/daftarBuku/screens/detail_buku.dart';
import 'package:wisdom_repository_mobile/daftarBuku/screens/request_form.dart';
import 'package:wisdom_repository_mobile/daftarBuku/widgets/bottom_navbar.dart';

class BukuPage extends StatefulWidget {
  const BukuPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BukuPageState createState() => _BukuPageState();
}

class _BukuPageState extends State<BukuPage> {
  String buku = 'Buku';
  late List<Buku> _filteredBuku;
  late List<Buku> _bukuSemua;
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

  Future<List<Buku>> fetchBuku() async {
    if (!_booksFetched) {
      final request = context.watch<CookieRequest>();
      final response = await request.get(
        'https://wisdomrepository--wahyuridho5.repl.co/main/get_books_json/',
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
    http.Response response;
    response = await http.post(Uri.parse(
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
    List<Buku> filteredList = _bukuSemua
        .where((buku) =>
            buku.fields.judul.toLowerCase().contains(query.toLowerCase()) ||
            buku.fields.penulis.toLowerCase().contains(query.toLowerCase()) ||
            buku.fields.kategori.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredBuku = filteredList;
    });
  }

  void filterBukuFromDjango(String query) async {
    final body = {
      'query': query,
    };
    http.Response response;
    response = await http.post(
      Uri.parse(
          'https://wisdomrepository--wahyuridho5.repl.co/main/search_books_json/'),
      body: body,
    );

    List<Buku> buku = [];
    var data = jsonDecode(response.body);
    for (var i in data) {
      if (i != null) buku.add(Buku.fromJson(i));
    }
    fetchRating();
    setState(() {
      _filteredBuku = buku;
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
    late http.Response response;
    if (nama == "judul") {
      response = await http.post(Uri.parse(
          'https://wisdomrepository--wahyuridho5.repl.co/main/sortjson/judul'));
    } else if (nama == "tahun") {
      response = await http.post(Uri.parse(
          'https://wisdomrepository--wahyuridho5.repl.co/main/sortjson/tahun'));
    } else if (nama == "rating") {
      response = await http.post(Uri.parse(
          'https://wisdomrepository--wahyuridho5.repl.co/main/sortjson/rating'));
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
                    Row(
                      children: [
                        const Row(
                          children: [
                            Text('Sort by'),
                            Icon(Icons.sort),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      sortBuku('judul');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF37465D),
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Judul'),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                SizedBox(
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      sortBuku('rating');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF37465D),
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Rating'),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                SizedBox(
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      sortBuku('tahun');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF37465D),
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Tahun'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    const SizedBox(height: 8),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.52,
                      child: FutureBuilder<List<Buku>>(
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: Hero(
                                                tag: _filteredBuku[index].pk,
                                                child: SizedBox(
                                                  height: 100,
                                                  child: Image.network(
                                                      _filteredBuku[index]
                                                          .fields
                                                          .gambar),
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    _filteredBuku[index]
                                                        .fields
                                                        .judul,
                                                    style: const TextStyle(
                                                        fontSize: 20),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  if (member == 'premium')
                                                    Container(
                                                      width: 60,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      decoration: BoxDecoration(
                                                        color: Colors.yellow,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.star,
                                                            color: Colors.black,
                                                            size: 16,
                                                          ),
                                                          const SizedBox(
                                                              width: 4),
                                                          Text(
                                                            _filteredBuku[index]
                                                                .fields
                                                                .rating
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                ],
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
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
                                );
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          } else {
                            return const CircularProgressIndicator();
                          }
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RequestFormPage()),
          );
        },
        backgroundColor: const Color(0xFF4DC7BF),
        icon: const Icon(Icons.add, color: Color(0xFF37465D)),
        label: const Text(
          'Request',
          style: TextStyle(color: Color(0xFF37465D)),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
