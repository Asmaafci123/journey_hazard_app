// To parse this JSON data, do
//
//     final jobsiteList = jobsiteListFromJson(jsonString);

import 'dart:convert';

import 'jobsite.dart';

JobSiteList jobSiteListFromJson(String str) => JobSiteList.fromJson(json.decode(str));

String jobSiteListToJson(JobSiteList data) => json.encode(data.toJson());

class JobSiteList {
  JobSiteList({
    this.data,
  });

  List<JobSite> data;

  JobSiteList copyWith({
    List<JobSite> data,
  }) =>
      JobSiteList(
        data: data ?? this.data,
      );

  factory JobSiteList.fromJson(Map<String, dynamic> json) => JobSiteList(
    data: json["data"] == null ? null : List<JobSite>.from(json["data"].map((x) => JobSite.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

