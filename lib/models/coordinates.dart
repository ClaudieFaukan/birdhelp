// To parse this JSON data, do
//
//     final coordinate = coordinateFromJson(jsonString);

import 'dart:convert';

Coordinate coordinateFromJson(String str) => Coordinate.fromJson(json.decode(str));

String coordinateToJson(Coordinate data) => json.encode(data.toJson());

class Coordinate {
  Coordinate({
    required this.id,
    required this.longitude,
    required this.lattitude,
  });

  int id;
  String longitude;
  String lattitude;

  factory Coordinate.fromJson(Map<String, dynamic> json) => Coordinate(
    id: json["id"],
    longitude: json["longitude"],
    lattitude: json["lattitude"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "longitude": longitude,
    "lattitude": lattitude,
  };
}
