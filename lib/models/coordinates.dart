// To parse this JSON data, do
//
//     final coordinate = coordinateFromJson(jsonString);

import 'dart:convert';

List<Coordinate> coordinateFromJson(String str) => List<Coordinate>.from(json.decode(str).map((x) => Coordinate.fromJson(x)));

String coordinateToJson(List<Coordinate> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
String coordianteToMap(List<Coordinate> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Coordinate {
  Coordinate({
    required this.id,
    required this.latitude,
    required this.longitude,
  });

  int id;
  double latitude;
  double longitude;

  factory Coordinate.fromJson(Map<String, dynamic> json) => Coordinate(
    id: json["id"],
    latitude: json["latitude"],
    longitude: json["longitude"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "latitude": latitude,
    "longitude": longitude,
  };

  Map<String, dynamic> toMap() => {
    "id": id,
    "latitude": latitude,
    "longitude": longitude,
  };


  factory Coordinate.fromMap(Map<String, dynamic> json) => Coordinate(
    id: json["id"],
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
  );
}
