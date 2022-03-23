import 'dart:convert';
import 'package:journeyhazard/features/trips/data/models/risk.dart';

TripsModel tripsModelFromJson(String str) =>
    TripsModel.fromJson(json.decode(str));

String tripsModelToJson(TripsModel data) => json.encode(data.toJson());

class TripsModel {
  TripsModel({
    this.data,
  });

  List<RiskModel> data;

  TripsModel copyWith({
    List<RiskModel> data,
  }) {
    return TripsModel(
      data: data ?? this.data,
    );
  }

  factory TripsModel.fromJson(Map<String, dynamic> json) => TripsModel(
        data: json["data"] == null
            ? null
            : List<RiskModel>.from(
                json["data"].map(
                  (x) => RiskModel.fromJson(x),
                ),
              ),
      );

//  factory TripsModel.fromSqlJson(Map<String, dynamic> json) => TripsModel(
//    data: json["data"] == null ? null : List<RiskModel>.from(json["data"].map((x) => RiskModel.fromSqlJson(x))),
//  );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(
                data.map(
                  (x) => x.toJson(),
                ),
              ),
      };
}
