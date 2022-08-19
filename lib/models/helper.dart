// To parse this JSON data, do
//
//     final helper = helperFromMap(jsonString);

import 'dart:convert';

List<Helper> helperFromMap(String str) => List<Helper>.from(json.decode(str).map((x) => Helper.fromMap(x)));

String helperToMap(List<Helper> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

List<Helper> helperFromJson(String str) => List<Helper>.from(json.decode(str).map((x) => Helper.fromJson(x)));

String helperToJson(List<Helper> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Helper {
  Helper({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  int id;
  String firstName;
  String lastName;
  String email;

  factory Helper.fromMap(Map<String, dynamic> json) => Helper(
    id: json["id"],
    firstName: json["FirstName"],
    lastName: json["LastName"],
    email: json["Email"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "FirstName": firstName,
    "LastName": lastName,
    "Email": email,
  };

  factory Helper.fromJson(Map<String, dynamic> json) => Helper(
    id: json["id"],
    firstName: json["FirstName"],
    lastName: json["LastName"],
    email: json["Email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "FirstName": firstName,
    "LastName": lastName,
    "Email": email,
  };
}
