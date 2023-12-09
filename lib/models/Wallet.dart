// To parse this JSON data, do
//
//     final biodata = biodataFromJson(jsonString);

import 'dart:convert';

List<Biodata> biodataFromJson(String str) => List<Biodata>.from(json.decode(str).map((x) => Biodata.fromJson(x)));

String biodataToJson(List<Biodata> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Biodata {
  String model;
  int pk;
  Fields fields;

  Biodata({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Biodata.fromJson(Map<String, dynamic> json) => Biodata(
    model: json["model"],
    pk: json["pk"],
    fields: Fields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "model": model,
    "pk": pk,
    "fields": fields.toJson(),
  };
}

class Fields {
  int user;
  int balance;

  Fields({
    required this.user,
    required this.balance,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    user: json["user"],
    balance: json["balance"],
  );

  Map<String, dynamic> toJson() => {
    "user": user,
    "balance": balance,
  };
}
