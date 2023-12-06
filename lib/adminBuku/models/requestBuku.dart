// To parse this JSON data, do
//
//     final requestBuku = requestBukuFromJson(jsonString);

import 'dart:convert';

List<RequestBuku> requestBukuFromJson(String str) => List<RequestBuku>.from(json.decode(str).map((x) => RequestBuku.fromJson(x)));

String requestBukuToJson(List<RequestBuku> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RequestBuku {
    String model;
    int pk;
    Fields fields;

    RequestBuku({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory RequestBuku.fromJson(Map<String, dynamic> json) => RequestBuku(
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
    int user;

    Fields({
        required this.isbn,
        required this.judul,
        required this.penulis,
        required this.tahun,
        required this.kategori,
        required this.gambar,
        required this.deskripsi,
        required this.rating,
        required this.user,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        isbn: json["isbn"],
        judul: json["judul"],
        penulis: json["penulis"],
        tahun: json["tahun"],
        kategori: json["kategori"],
        gambar: json["gambar"],
        deskripsi: json["deskripsi"],
        rating: json["rating"]?.toDouble(),
        user: json["user"],
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
        "user": user,
    };
}
