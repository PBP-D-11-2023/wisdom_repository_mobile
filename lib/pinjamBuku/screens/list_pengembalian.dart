import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:wisdom_repository_mobile/pinjamBuku/models/pengembalian.dart';
import 'package:wisdom_repository_mobile/pinjamBuku/widgets/bottomnavbar.dart';
import 'package:wisdom_repository_mobile/daftarBuku/models/buku.dart';
import 'package:wisdom_repository_mobile/reviewBuku/widgets/bottomSheetReview.dart';

class PengembalianPage extends StatefulWidget {
  const PengembalianPage({Key? key}) : super(key: key);

  @override
  _PengembalianPageState createState() => _PengembalianPageState();
}

class _PengembalianPageState extends State<PengembalianPage> {
  Future<List<Pengembalian>> fetchPengembalian(CookieRequest request) async {
    var response = await request
        .get('https://wisdomrepository--wahyuridho5.repl.co/borrow/pengembalianjson/');
    List<Pengembalian> list_pengembalian = [];
    for (var d in response) {
      if (d != null) {
        list_pengembalian.add(Pengembalian.fromJson(d));
      }
    }
    return list_pengembalian;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Pengembalian'),
        ),
        body: FutureBuilder(
            future: fetchPengembalian(request),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (!snapshot.hasData) {
                  return const Column(
                    children: [
                      Text(
                        "Tidak ada buku yang dikembalikan yang belum direview saat ini.",
                        style:
                            TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                } else {
                  return ListView(
                    children: [
                      Stack(
                        children: [
                          Image.asset(
                            'assets/images/background_bookmark.png',
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Returned Books',
                                  style: TextStyle(
                                    fontSize: 48,
                                    color: const Color(0xFF37465D),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(
                            10.0), // Adjust the values as needed
                        child: Text(
                          'List of books:',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, index) => Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            color: Colors.white,
                            elevation: 2,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Hero(
                                    tag: snapshot.data![index].idBuku,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: SizedBox(
                                        height: 150,
                                        width: 150,
                                        child: Image.network(
                                          snapshot.data![index].bukuGambar,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data![index].bukuJudul,
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        ElevatedButton(
                                          onPressed: () async {
                                            int idbuku = snapshot.data![index].idBuku;
                                            var response = await request.get(
                                              'https://wisdomrepository--wahyuridho5.repl.co/review/get-book-json/$idbuku/');
                                            Buku bukuKembali = Buku.fromJson(response[0]);
                                            showReviewSheet(context, bukuKembali, snapshot.data![index].pk);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            backgroundColor:
                                                const Color(0xFF37465D),
                                          ),
                                          child: const Text(
                                            'Review',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }
            }),
            bottomNavigationBar: CustomBottomNavigationBar(),
            );
  }
}