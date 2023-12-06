// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:wisdom_repository_mobile/daftarBuku/models/buku.dart';
import 'package:wisdom_repository_mobile/adminBuku/screens/admin.dart';
import 'package:wisdom_repository_mobile/adminBuku/screens/edit_form.dart';

class DetailBuku extends StatelessWidget {
  final Buku buku;

  const DetailBuku({Key? key, required this.buku}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: Text(buku.fields.judul),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(buku.fields.gambar),
            Text(buku.fields.judul),
            Text(buku.fields.penulis),
            Text(buku.fields.deskripsi),
            Text(buku.fields.kategori),
            Text(buku.fields.tahun.toString()),
            Text(buku.fields.rating.toString()),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditFormPage(
                                  buku: buku,
                                ),
                              ),
                            );
              },
              child: const Text('Edit'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final response = await request.postJson(
                            "https://wisdomrepository--wahyuridho5.repl.co/admin-buku/delete-book-flutter/",
                            jsonEncode(<String, String>{
                              'bookID': buku.pk.toString(),
                            }));
                if (response['status'] == 'success') {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(
                    content: Text("Buku berhasil dihapus!"),
                  ));
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(
                    content:
                        Text("Terdapat kesalahan, silakan coba lagi."),
                  ));
                }
              },
              child: const Text('Hapus'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
