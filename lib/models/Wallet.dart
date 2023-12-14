// To parse this JSON data, do
//
//     final wallet = walletFromJson(jsonString);

import 'dart:convert';

List<Wallet> walletFromJson(String str) => List<Wallet>.from(json.decode(str).map((x) => Wallet.fromJson(x)));

String walletToJson(List<Wallet> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Wallet {
  String model;
  int pk;
  Fields fields;

  Wallet({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
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
