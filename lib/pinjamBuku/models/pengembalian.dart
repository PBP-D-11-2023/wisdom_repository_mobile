// To parse this JSON data, do
//
//     final pengembalian = pengembalianFromJson(jsonString);

import 'dart:convert';

List<Pengembalian> pengembalianFromJson(String str) => List<Pengembalian>.from(
    json.decode(str).map((x) => Pengembalian.fromJson(x)));

String pengembalianToJson(List<Pengembalian> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Pengembalian {
  int pk;
  int idBuku;
  String bukuGambar;
  String bukuJudul;

  Pengembalian({
    required this.pk,
    required this.idBuku,
    required this.bukuGambar,
    required this.bukuJudul,
  });

  factory Pengembalian.fromJson(Map<String, dynamic> json) => Pengembalian(
        pk: json["pk"],
        idBuku: json["idBuku"],
        bukuGambar: json["buku__gambar"],
        bukuJudul: json["buku__judul"],
      );

  Map<String, dynamic> toJson() => {
        "pk": pk,
        "idBuku": idBuku,
        "buku__gambar": bukuGambar,
        "buku__judul": bukuJudul,
      };
}
