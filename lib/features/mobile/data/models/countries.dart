import 'dart:convert';

import 'country.dart';

CountriesModel countriesModelFromJson(String str) => CountriesModel.fromJson(json.decode(str));

String countriesModelToJson(CountriesModel data) => json.encode(data.toJson());

class CountriesModel {
  CountriesModel({
    this.data,
  });

  List<CountryModel> data;

  CountriesModel copyWith({
    List<CountryModel> data,
  }) =>
      CountriesModel(
        data: data ?? this.data,
      );

  factory CountriesModel.fromJson(Map<String, dynamic> json) => CountriesModel(
    data: json["data"] == null ? null : List<CountryModel>.from(json["data"].map((x) => CountryModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}