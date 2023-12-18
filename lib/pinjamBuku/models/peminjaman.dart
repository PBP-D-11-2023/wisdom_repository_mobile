// To parse this JSON data, do
//
//     final peminjaman = peminjamanFromJson(jsonString);

import 'dart:convert';

List<Peminjaman> peminjamanFromJson(String str) =>
    List<Peminjaman>.from(json.decode(str).map((x) => Peminjaman.fromJson(x)));

String peminjamanToJson(List<Peminjaman> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Peminjaman {
  int pk;
  int idBuku;
  String bukuGambar;
  String bukuJudul;
  DateTime tanggalDipinjam;
  DateTime tanggalPengembalian;

  Peminjaman({
    required this.pk,
    required this.idBuku,
    required this.bukuGambar,
    required this.bukuJudul,
    required this.tanggalDipinjam,
    required this.tanggalPengembalian,
  });

  factory Peminjaman.fromJson(Map<String, dynamic> json) => Peminjaman(
        pk: json["pk"],
        idBuku: json["idBuku"],
        bukuGambar: json["buku__gambar"],
        bukuJudul: json["buku__judul"],
        tanggalDipinjam: DateTime.parse(json["tanggal_dipinjam"]),
        tanggalPengembalian: DateTime.parse(json["tanggal_pengembalian"]),
      );

  Map<String, dynamic> toJson() => {
        "pk": pk,
        "idBuku": idBuku,
        "buku__gambar": bukuGambar,
        "buku__judul": bukuJudul,
        "tanggal_dipinjam":
            "${tanggalDipinjam.year.toString().padLeft(4, '0')}-${tanggalDipinjam.month.toString().padLeft(2, '0')}-${tanggalDipinjam.day.toString().padLeft(2, '0')}",
        "tanggal_pengembalian":
            "${tanggalPengembalian.year.toString().padLeft(4, '0')}-${tanggalPengembalian.month.toString().padLeft(2, '0')}-${tanggalPengembalian.day.toString().padLeft(2, '0')}",
      };
}
