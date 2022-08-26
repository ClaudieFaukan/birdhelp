// To parse this JSON data, do
//
//     final fiche = ficheFromJson(jsonString);

import 'dart:convert';

import 'package:birdhelp/models/helper.dart';

Fiche ficheFromJson(String str) => Fiche.fromJson(json.decode(str));

String ficheToJson(Fiche data) => json.encode(data.toJson());

class Fiche {
  Fiche({
    this.id,
    this.helper,
    required this.animal,
    required this.geographicCoordinate,
    required this.date,
    this.photo,
    required this.healthstatus,
    required this.description,
    required this.category,
    required this.color,
  });

  int? id;
  Helper? helper;
  int? animal;
  List<double> geographicCoordinate;
  DateTime? date;
  String? photo;
  int? healthstatus;
  String? description;
  int? category;
  String? color;

  factory Fiche.fromJson(Map<String, dynamic> json) => Fiche(
    id: json["id"],
    helper: Helper.fromJson(json["helper"]),
    animal: json["Animal"],
    geographicCoordinate: List<double>.from(json["geographicCoordinate"].map((x) => x)),
    date: DateTime.parse(json["date"]),
    photo: json["photo"],
    healthstatus: json["healthstatus"],
    description: json["description"],
    category: json["category"],
    color: json["color"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "helper": helper?.toJson(),
    "Animal": animal,
    "geographicCoordinate": List<dynamic>.from(geographicCoordinate.map((x) => x)),
    "date": date?.toIso8601String(),
    "photo": photo,
    "healthstatus": healthstatus,
    "description": description,
    "category": category,
    "color": color,
  };
}
