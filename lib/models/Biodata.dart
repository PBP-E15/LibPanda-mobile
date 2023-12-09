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
  String name;
  String email;
  String gender;
  DateTime birthday;
  String phoneNumber;

  Fields({
    required this.user,
    required this.name,
    required this.email,
    required this.gender,
    required this.birthday,
    required this.phoneNumber,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    user: json["user"],
    name: json["name"],
    email: json["email"],
    gender: json["gender"],
    birthday: DateTime.parse(json["birthday"]),
    phoneNumber: json["phone_number"],
  );

  Map<String, dynamic> toJson() => {
    "user": user,
    "name": name,
    "email": email,
    "gender": gender,
    "birthday": "${birthday.year.toString().padLeft(4, '0')}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}",
    "phone_number": phoneNumber,
  };
}
