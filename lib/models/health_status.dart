// To parse this JSON data, do
//
//     final healthStatus = healthStatusFromJson(jsonString);

import 'dart:convert';

List<HealthStatus> healthStatusFromJson(String str) => List<HealthStatus>.from(json.decode(str).map((x) => HealthStatus.fromJson(x)));

String healthStatusToJson(List<HealthStatus> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HealthStatus {
  HealthStatus({
    required this.id,
    required this.status,
  });

  int id;
  String status;

  factory HealthStatus.fromJson(Map<String, dynamic> json) => HealthStatus(
    id: json["id"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
  };
}
