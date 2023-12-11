// To parse this JSON data, do
//
//     final bookmark = bookmarkFromJson(jsonString);

import 'dart:convert';

List<Bookmark> bookmarkFromJson(String str) => List<Bookmark>.from(json.decode(str).map((x) => Bookmark.fromJson(x)));

String bookmarkToJson(List<Bookmark> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Bookmark {
    String model;
    int pk;
    Fields fields;

    Bookmark({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
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
    int buku;
    int user;
    String judul;
    String gambar;

    Fields({
        required this.buku,
        required this.user,
        required this.judul,
        required this.gambar,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        buku: json["buku"],
        user: json["user"],
        judul: json["judul"],
        gambar: json["gambar"],
    );

    Map<String, dynamic> toJson() => {
        "buku": buku,
        "user": user,
        "judul": judul,
        "gambar": gambar,
    };
}
