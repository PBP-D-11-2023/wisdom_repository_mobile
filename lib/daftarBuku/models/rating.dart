// To parse this JSON data, do
//
//     final rating = ratingFromJson(jsonString);

import 'dart:convert';

Rating ratingFromJson(String str) => Rating.fromJson(json.decode(str));

String ratingToJson(Rating data) => json.encode(data.toJson());

class Rating {
    String model;
    int pk;
    Fields fields;

    Rating({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Rating.fromJson(Map<String, dynamic> json) => Rating(
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
    String rating;

    Fields({
        required this.rating,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        rating: json["rating"],
    );

    Map<String, dynamic> toJson() => {
        "rating": rating,
    };
}
