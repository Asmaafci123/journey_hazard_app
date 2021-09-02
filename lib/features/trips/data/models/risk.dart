// To parse this JSON data, do
//
//     final riskModel = riskModelFromJson(jsonString);

import 'dart:convert';

RiskModel riskModelFromJson(String str) => RiskModel.fromJson(json.decode(str));

String riskModelToJson(RiskModel data) => json.encode(data.toJson());

class RiskModel {
  RiskModel({
    this.riskId,
    this.riskAr,
    this.riskEn,
    this.lat,
    this.long,
    this.active,
    this.comment,
    this.riskLevel,
    this.distance,
    this.done
  });

  int riskId;
  String riskAr;
  String riskEn;
  String lat;
  String long;
  dynamic active;
  String comment;
  String riskLevel;
  double distance;
  int done;

  RiskModel copyWith({
    int riskId,
    String riskAr,
    String riskEn,
    String lat,
    String long,
    dynamic active,
    String comment,
    String riskLevel,
    double distance,
    int done,
  }) =>
      RiskModel(
        riskId: riskId ?? this.riskId,
        riskAr: riskAr ?? this.riskAr,
        riskEn: riskEn ?? this.riskEn,
        lat: lat ?? this.lat,
        long: long ?? this.long,
        active: active ?? this.active,
        comment: comment ?? this.comment,
        riskLevel: riskLevel ?? this.riskLevel,
        distance: distance?? this.distance,
        done: done?? this.done,
      );

  factory RiskModel.fromJson(Map<String, dynamic> json) => RiskModel(
    riskId: json["risk_ID"] == null ? null : json["risk_ID"],
    riskAr: json["risk_AR"] == null ? null : json["risk_AR"],
    riskEn: json["risk_EN"] == null ? null : json["risk_EN"],
    lat: json["lat"] == null ? null : json["lat"],
    long: json["long"] == null ? null : json["long"],
    active: json["active"] == null ? null : json["active"] == true ? 1 : 0,
    comment: json["comment"] == null ? null : json["comment"],
    riskLevel: json["riskLevel"] == null ? null : json["riskLevel"],
    distance:  json["distance"] == null ? null : json["distance"],
    done:  json["done"] == null ? 0 : json["done"],
  );

  Map<String, dynamic> toJson() => {
    "risk_ID": riskId == null ? null : riskId,
    "risk_AR": riskAr == null ? null : riskAr,
    "risk_EN": riskEn == null ? null : riskEn,
    "lat": lat == null ? null : lat,
    "long": long == null ? null : long,
    "active": active == null ? null : active,
    "comment": comment == null ? null : comment,
    "riskLevel": riskLevel == null ? null : riskLevel,
    "distance": distance == null ? null : distance,
    "done": done == null ? 0 : done,
  };

  Map<String, dynamic> toSqlJson() => {
    "risk_id": riskId == null ? null : riskId,
    "risk_AR": riskAr == null ? null : riskAr,
    "risk_EN": riskEn == null ? null : riskEn,
    "lat": lat == null ? null : lat,
    "long": long == null ? null : long,
    "Active": active == null ? null : active,
    "Comment": comment == null ? null : comment,
  };
}
