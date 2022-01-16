// To parse this JSON data, do
//
//     final jobsite = jobsiteFromJson(jsonString);

import 'dart:convert';

JobSite jobSiteFromJson(String str) => JobSite.fromJson(json.decode(str));

String jobSiteToJson(JobSite data) => json.encode(data.toJson());

class JobSite {
  int id;
  String jobsiteId;
  String jobsiteAr;
  String jobsiteEn;
  String jobsiteLat;
  String jobsiteLong;
  String country;
  String company;
  String riskAr;
  String riskEn;
  String image;
  String riskLat;
  String riskLong;

  JobSite({
    this.id,
    this.jobsiteId,
    this.jobsiteAr,
    this.jobsiteEn,
    this.jobsiteLat,
    this.jobsiteLong,
    this.country,
    this.company,
    this.riskAr,
    this.riskEn,
    this.image,
    this.riskLat,
    this.riskLong,
  });
  JobSite copyWith({
    int id,
    String jobsiteId,
    String jobsiteAr,
    String jobsiteEn,
    String jobsiteLat,
    String jobsiteLong,
    String country,
    String company,
    String riskAr,
    String riskEn,
    String image,
    String riskLat,
    String riskLong,
  }) =>
      JobSite(
        id: id ?? this.id,
        jobsiteId: jobsiteId ?? this.jobsiteId,
        jobsiteAr: jobsiteAr ?? this.jobsiteAr,
        jobsiteEn: jobsiteEn ?? this.jobsiteEn,
        jobsiteLat: jobsiteLat ?? this.jobsiteLat,
        jobsiteLong: jobsiteLong ?? this.jobsiteLong,
        country: country ?? this.country,
        company: company ?? this.company,
        riskAr: riskAr ?? this.riskAr,
        riskEn: riskEn ?? this.riskEn,
        image: image ?? this.image,
        riskLat: riskLat ?? this.riskLat,
        riskLong: riskLong ?? this.riskLong,
      );

  factory JobSite.fromJson(Map<String, dynamic> json) => JobSite(
    id: json["id"] == null ? null : json["id"],
    jobsiteId: json["jobsite_ID"] == null ? null : json["jobsite_ID"],
    jobsiteAr: json["jobsite_AR"] == null ? null : json["jobsite_AR"],
    jobsiteEn: json["jobsite_EN"] == null ? null : json["jobsite_EN"],
    jobsiteLat: json["jobsite_Lat"] == null ? null : json["jobsite_Lat"],
    jobsiteLong: json["jobsite_Long"] == null ? null : json["jobsite_Long"],
    country: json["country"] == null ? null : json["country"],
    company: json["company"] == null ? null : json["company"],
    riskAr: json["risk_AR"] == null ? null : json["risk_AR"],
    riskEn: json["risk_EN"] == null ? null : json["risk_EN"],
    image: json["image"] == null ? null : json["image"],
    riskLat: json["risk_Lat"] == null ? null : json["risk_Lat"],
    riskLong: json["risk_Long"] == null ? null : json["risk_Long"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "jobsite_ID": jobsiteId  == null ? null : jobsiteId,
    "jobsite_AR": jobsiteAr == null ? null : jobsiteAr,
    "jobsite_EN": jobsiteEn == null ? null : jobsiteEn,
    "jobsite_Lat": jobsiteLat == null ? null : jobsiteLat,
    "jobsite_Long": jobsiteLong == null ? null : jobsiteLong,
    "country": country == null ? null : country,
    "company": company == null ? null : company,
    "risk_AR": riskAr == null ? null : riskAr,
    "risk_EN": riskEn == null ? null : riskEn,
    "image": image == null ? null : image,
    "risk_Lat": riskLat == null ? null : riskLat,
    "risk_Long": riskLong == null ? null : riskLong,
  };

  ///this method will prevent the override of toString
  String jobSiteArAsString() {
    return '${this.jobsiteAr}';
  }

  String jobSiteEnAsString() {
    return '${this.jobsiteEn}';
  }

  ///this method will prevent the override of toString
  bool userFilterByJobSiteName(String filter) {
    print("filter:$filter");
    return this.jobsiteAr.toLowerCase().contains(filter.toLowerCase()) || this.jobsiteEn.toLowerCase().contains(filter.toLowerCase());
  }

  ///custom comparing function to check if two jobsites are equal
  bool isEqual(JobSite model) {
    return this.jobsiteId == model?.jobsiteId;
  }

  @override
  String toString() => jobsiteId;
}
