// To parse this JSON data, do
//
//     final riskAddModel = riskAddModelFromJson(jsonString);

import 'dart:convert';

RiskAddModel riskAddModelFromJson(String str) => RiskAddModel.fromJson(json.decode(str));

String riskAddModelToJson(RiskAddModel data) => json.encode(data.toJson());

class RiskAddModel {
  RiskAddModel({
    this.riskId,
    this.riskAr,
    this.riskEn,
    this.lat,
    this.long,
    this.status,
    this.comment,
    this.riskLevel,
    this.mobileNumber,
    this.shipmentId,
    this.country,
  });

  int riskId;
  String riskAr;
  String riskEn;
  String lat;
  String long;
  String status;
  String comment;
  String riskLevel;
  String mobileNumber;
  String shipmentId;
  String country;


  RiskAddModel copyWith({
    int riskId,
    String riskAr,
    String riskEn,
    String lat,
    String long,
    String status,
    String comment,
    String riskLevel,
    String mobileNumber,
    String shipmentId,
    String country,
  }) =>
      RiskAddModel(
        riskId: riskId ?? this.riskId,
        riskAr: riskAr ?? this.riskAr,
        riskEn: riskEn ?? this.riskEn,
        lat: lat ?? this.lat,
        long: long ?? this.long,
        status: status ?? this.status,
        comment: comment ?? this.comment,
        riskLevel: riskLevel ?? this.riskLevel,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        shipmentId: shipmentId ?? this.shipmentId,
          country: country?? this.country,

      );

  factory RiskAddModel.fromJson(Map<String, dynamic> json) => RiskAddModel(
    riskId: json["risk_ID"] == null ? null : json["risk_ID"],
    riskAr: json["risk_AR"] == null ? null : json["risk_AR"],
    riskEn: json["risk_EN"] == null ? null : json["risk_EN"],
    lat: json["lat"] == null ? null : json["lat"],
    long: json["long"] == null ? null : json["long"],
    status: json["status"] == null ? null : json["status"],
    comment: json["comment"] == null ? null : json["comment"],
    riskLevel: json["riskLevel"] == null ? null : json["riskLevel"],
    mobileNumber: json["mobileNumber"] == null ? null : json["mobileNumber"],
    shipmentId: json["shipment_ID"] == null ? null : json["shipment_ID"],
    country: json["country"] == null ? null : json["country"],

  );

  Map<String, dynamic> toJson() => {
    "risk_ID": riskId == null ? null : riskId,
    "risk_AR": riskAr == null ? null : riskAr,
    "risk_EN": riskEn == null ? null : riskEn,
    "lat": lat == null ? null : lat,
    "long": long == null ? null : long,
    "status": status == null ? null : status,
    "comment": comment == null ? null : comment,
    "riskLevel": riskLevel == null ? null : riskLevel,
    "mobileNumber": mobileNumber == null ? null : mobileNumber,
    "shipment_ID": shipmentId == null ? null : shipmentId,
    "country": country == null ? null : country,
  };

  Map<String, dynamic> toSqlJson() => {
    "risk_ID": riskId == null ? null : riskId,
    "lat": lat == null ? null : lat,
    "long": long == null ? null : long,
    "status": status == null ? null : status,
    "mobileNumber": mobileNumber == null ? null : mobileNumber,
    "shipment_ID": shipmentId == null ? null : shipmentId,
    "country": country == null ? null : country,

  };
  Map<String, dynamic> toSendJson() => {
    "risk_ID": riskId == null ? null : riskId,
    "lat": lat == null ? null : lat,
    "long": long == null ? null : long,
    "MobileNumber": mobileNumber == null ? null : mobileNumber,
    "Shipment_ID": shipmentId == null ? null : shipmentId,
    "country": country == null ? null : country,

  };
}
