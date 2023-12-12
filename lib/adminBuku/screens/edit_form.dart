// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:wisdom_repository_mobile/daftarBuku/models/buku.dart';
import 'package:wisdom_repository_mobile/adminBuku/screens/admin.dart';

class EditFormPage extends StatefulWidget {
  final Buku buku;

  const EditFormPage({Key? key, required this.buku}) : super(key: key);

  @override
  State<EditFormPage> createState() => _BukuFormPageState();
}

class _BukuFormPageState extends State<EditFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _isbnController;
  late TextEditingController _judulController;
  late TextEditingController _penulisController;
  late TextEditingController _tahunController;
  late TextEditingController _kategoriController;
  late TextEditingController _gambarController;
  late TextEditingController _deskripsiController;
  late TextEditingController _ratingController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with widget.buku values
    _isbnController = TextEditingController(text: widget.buku.fields.isbn);
    _judulController = TextEditingController(text: widget.buku.fields.judul);
    _penulisController = TextEditingController(text: widget.buku.fields.penulis);
    _tahunController = TextEditingController(text: widget.buku.fields.tahun.toString());
    _kategoriController = TextEditingController(text: widget.buku.fields.kategori);
    _gambarController = TextEditingController(text: widget.buku.fields.gambar);
    _deskripsiController = TextEditingController(text: widget.buku.fields.deskripsi);
    _ratingController = TextEditingController(text: widget.buku.fields.rating.toString());
  }

  @override
  void dispose() {
    // Dispose controllers
    _isbnController.dispose();
    _judulController.dispose();
    _penulisController.dispose();
    _tahunController.dispose();
    _kategoriController.dispose();
    _gambarController.dispose();
    _deskripsiController.dispose();
    _ratingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      const Text(
                        "Form Edit Buku",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 500,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: const Color(0xFF37465D), width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _isbnController,
                                    decoration: InputDecoration(
                                      hintText: "ISBN",
                                      labelText: "ISBN",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return "ISBN tidak boleh kosong!";
                                      }
                                      return null;
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _judulController,
                                    decoration: InputDecoration(
                                      hintText: "Judul",
                                      labelText: "Judul",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return "Judul tidak boleh kosong!";
                                      }
                                      return null;
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _penulisController,
                                    decoration: InputDecoration(
                                      hintText: "Penulis",
                                      labelText: "Penulis",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return "Penulis tidak boleh kosong!";
                                      }
                                      return null;
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _tahunController,
                                    decoration: InputDecoration(
                                      hintText: "Tahun Terbit",
                                      labelText: "Tahun Terbit",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return "Tahun terbit tidak boleh kosong!";
                                      }
                                      if (int.tryParse(value) == null) {
                                        return "Tahun terbit harus berupa angka!";
                                      }
                                      return null;
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _kategoriController,
                                    decoration: InputDecoration(
                                      hintText: "Kategori",
                                      labelText: "Kategori",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return "Kategori tidak boleh kosong!";
                                      }
                                      return null;
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _gambarController,
                                    decoration: InputDecoration(
                                      hintText: "URL Gambar",
                                      labelText: "URL Gambar",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return "URL gambar tidak boleh kosong!";
                                      }
                                      return null;
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _deskripsiController,
                                    keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      hintText: "Deskripsi",
                                      labelText: "Deskripsi",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return "Deskripsi tidak boleh kosong!";
                                      }
                                      return null;
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _ratingController,
                                    decoration: InputDecoration(
                                      hintText: "Rating",
                                      labelText: "Rating",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return "Rating tidak boleh kosong!";
                                      }
                                      if (double.tryParse(value) == null) {
                                        return "Rating harus berupa angka!";
                                      }
                                      return null;
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              backgroundColor: const Color(0xFF37465D),
                            ),
                            child: const Text(
                              'Back',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              backgroundColor: const Color(0xFF4DC7BF),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // Kirim ke Django dan tunggu respons
                                final response = await request.postJson(
                                  "https://wisdomrepository--wahyuridho5.repl.co/admin-buku/edit-book-flutter/",
                                  jsonEncode(<String, String>{
                                    'bookID': widget.buku.pk.toString(),
                                    'isbn': _isbnController.text,
                                    'judul': _judulController.text,
                                    'penulis': _penulisController.text,
                                    'tahun': _tahunController.text,
                                    'kategori': _kategoriController.text,
                                    'gambar': _gambarController.text,
                                    'deskripsi': _deskripsiController.text,
                                    'rating': _ratingController.text,
                                  }),
                                );
                                if (response['status'] == 'success') {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Buku berhasil diperbarui!"),
                                  ));
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AdminPage(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                        "Terdapat kesalahan, silakan coba lagi."),
                                  ));
                                }
                              }
                            },
                            child: const Text(
                              "Save",
                              style: TextStyle(color: Color(0xFF37465D)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
