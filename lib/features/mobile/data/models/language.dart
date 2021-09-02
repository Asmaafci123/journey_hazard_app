// To parse this JSON data, do
//
//     final languageModel = languageModelFromJson(jsonString);

import 'dart:convert';

LanguageModel languageModelFromJson(String str) => LanguageModel.fromJson(json.decode(str));

String languageModelToJson(LanguageModel data) => json.encode(data.toJson());

class LanguageModel {
  LanguageModel({
    this.code,
    this.lang,
  });

  String code;
  String lang;

  LanguageModel copyWith({
    String code,
    String lang,
  }) =>
      LanguageModel(
        code: code ?? this.code,
        lang: lang ?? this.lang,
      );

  factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
    code: json["code"] == null ? null : json["code"],
    lang: json["lang"] == null ? null : json["lang"],
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "lang": lang == null ? null : lang,
  };
}
