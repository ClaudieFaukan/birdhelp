// To parse this JSON data, do
//
//     final animals = animalsFromJson(jsonString);

import 'dart:convert';

import 'package:birdhelp/models/categories.dart';

List<Animals> animalsFromJson(String str) => List<Animals>.from(json.decode(str).map((x) => Animals.fromJson(x)));

String animalsToJson(List<Animals> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Animals {
  Animals({
    required this.id,
    required this.color,
    required this.categorie,
  });

  int id;
  String color;
  Categories categorie;

  factory Animals.fromJson(Map<String, dynamic> json) => Animals(
    id: json["id"],
    color: json["color"],
    categorie: json["categorie"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "color": color,
    "categorie": categorie,
  };
}
