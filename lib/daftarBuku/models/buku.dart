// To parse this JSON data, do
//
//     final buku = bukuFromJson(jsonString);

import 'dart:convert';

Buku bukuFromJson(String str) => Buku.fromJson(json.decode(str));

String bukuToJson(Buku data) => json.encode(data.toJson());

class Buku {
  String model;
  int pk;
  Fields fields;

    Buku({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Buku.fromJson(Map<String, dynamic> json) => Buku(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String isbn;
    String judul;
    String penulis;
    int tahun;
    String kategori;
    String gambar;
    String deskripsi;
    double rating;

    Fields({
        required this.isbn,
        required this.judul,
        required this.penulis,
        required this.tahun,
        required this.kategori,
        required this.gambar,
        required this.deskripsi,
        required this.rating,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        isbn: json["isbn"],
        judul: json["judul"],
        penulis: json["penulis"],
        tahun: json["tahun"],
        kategori: json["kategori"],
        gambar: json["gambar"],
        deskripsi: json["deskripsi"],
        rating: json["rating"],
    );

    Map<String, dynamic> toJson() => {
        "isbn": isbn,
        "judul": judul,
        "penulis": penulis,
        "tahun": tahun,
        "kategori": kategori,
        "gambar": gambar,
        "deskripsi": deskripsi,
        "rating": rating,
    };
}
