// To parse this JSON data, do
//
//     final tempReturned = tempReturnedFromJson(jsonString);

import 'dart:convert';

List<TempReturned> tempReturnedFromJson(String str) => List<TempReturned>.from(json.decode(str).map((x) => TempReturned.fromJson(x)));

String tempReturnedToJson(List<TempReturned> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TempReturned {
    String model;
    int pk;
    Fields fields;

    TempReturned({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory TempReturned.fromJson(Map<String, dynamic> json) => TempReturned(
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
    int peminjam;
    int idBuku;
    bool review;

    Fields({
        required this.buku,
        required this.peminjam,
        required this.idBuku,
        required this.review,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        buku: json["buku"],
        peminjam: json["peminjam"],
        idBuku: json["idBuku"],
        review: json["review"],
    );

    Map<String, dynamic> toJson() => {
        "buku": buku,
        "peminjam": peminjam,
        "idBuku": idBuku,
        "review": review,
    };
}
