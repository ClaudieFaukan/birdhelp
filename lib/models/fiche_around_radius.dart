// To parse this JSON data, do
//
//     final ficheAroundRadius = ficheAroundRadiusFromMap(jsonString);

import 'dart:convert';

import 'coordinates.dart';

List<FicheAroundRadius> ficheAroundRadiusFromMap(String str) => List<FicheAroundRadius>.from(json.decode(str).map((x) => FicheAroundRadius.fromMap(x)));

String ficheAroundRadiusToMap(List<FicheAroundRadius> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

List<FicheAroundRadius> ficheAroundRadiusFromJson(String str) => List<FicheAroundRadius>.from(json.decode(str).map((x) => FicheAroundRadius.fromJson(x)));

String ficheAroundRadiusToJson(List<FicheAroundRadius> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FicheAroundRadius {
  FicheAroundRadius({
    required this.coordinates,
    required this.radius,
  });

  Coordinate coordinates;
  double radius;

  factory FicheAroundRadius.fromMap(Map<String, dynamic> json) => FicheAroundRadius(
    coordinates: Coordinate.fromMap(json["coordinates"]),
    radius: json["radius"] == null ? null : json["radius"].toDouble(),
  );

  Map<String, dynamic> toMap() => {
    "coordinates": coordinates.toMap(),
    "radius": radius,
  };

  factory FicheAroundRadius.fromJson(Map<String, dynamic> json) => FicheAroundRadius(
    coordinates: Coordinate.fromJson(json["coordinates"]),
    radius: json["radius"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "coordinates": coordinates.toJson(),
    "radius":  radius,
  };
}

