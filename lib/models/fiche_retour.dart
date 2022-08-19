// To parse this JSON data, do
//
//     final fichesRetour = fichesRetourFromJson(jsonString);

import 'dart:convert';

import 'package:birdhelp/models/animals.dart';
import 'package:birdhelp/models/helper.dart';
import 'package:birdhelp/models/coordinates.dart';

List<FichesRetour> fichesRetourFromJson(String str) => List<FichesRetour>.from(json.decode(str).map((x) => FichesRetour.fromJson(x)));

String fichesRetourToJson(List<FichesRetour> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FichesRetour {
  FichesRetour({
    this.id,
    this.helper,
    this.animal,
    this.healthStatus,
    this.category,
    this.date,
    this.photo,
    this.description,
    this.coordinates,
  });

  int? id;
  Helper? helper;
  Animals? animal;
  String? healthStatus;
  String? category;
  DateTime? date;
  String? photo;
  String? description;
  Coordinate? coordinates;

  factory FichesRetour.fromJson(Map<String, dynamic> json) => FichesRetour(
    id: json["id"] == null ? null : json["id"],
    helper: json["helper"] == null ? null : Helper.fromJson(json["helper"]),
    animal: json["animal"] == null ? null : Animals.fromJson(json["animal"]),
    healthStatus: json["healthStatus"] == null ? null : json["healthStatus"],
    category: json["category"] == null ? null : json["category"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    photo: json["photo"],
    description: json["description"] == null ? null : json["description"],
    coordinates: json["coordinates"] == null ? null : Coordinate.fromJson(json["coordinates"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "helper": helper == null ? null : helper?.toJson(),
    "animal": animal == null ? null : animal?.toJson(),
    "healthStatus": healthStatus == null ? null : healthStatus,
    "category": category == null ? null : category,
    "date": date == null ? null : "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')} ${date?.hour.toString().padLeft(2, '0')} : ${date?.minute.toString().padLeft(2, '0')} ",
    "photo": photo,
    "description": description == null ? null : description,
    "coordinates": coordinates == null ? null : coordinates?.toJson(),
  };
}

