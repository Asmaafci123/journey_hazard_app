// To parse this JSON data, do
//
//     final countryModel = countryModelFromJson(jsonString);

import 'dart:convert';

CountryModel countryModelFromJson(String str) => CountryModel.fromJson(json.decode(str));

String countryModelToJson(CountryModel data) => json.encode(data.toJson());

class CountryModel {
  CountryModel({
    this.id,
    this.country,
    this.company,
    this.countryCode,
    this.active,
  });

  int id;
  String country;
  String company;
  String countryCode;
  bool active;

  CountryModel copyWith({
    int id,
    String country,
    String company,
    String countryCode,
    bool active,
  }) =>
      CountryModel(
        id: id ?? this.id,
        country: country ?? this.country,
        company: company ?? this.company,
        countryCode: countryCode ?? this.countryCode,
        active: active ?? this.active,
      );

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
    id: json["id"] == null ? null : json["id"],
    country: json["country"] == null ? null : json["country"],
    company: json["company"] == null ? null : json["company"],
    countryCode: json["countryCode"] == null ? null : json["countryCode"],
    active: json["active"] == null ? null : json["active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "country": country == null ? null : country,
    "company": company == null ? null :company,
    "countryCode": countryCode == null ? null : countryCode,
    "active": active == null ? null : active,
  };
}
