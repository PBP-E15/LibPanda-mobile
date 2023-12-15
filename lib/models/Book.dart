// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

import 'dart:convert';

List<Book> bookFromJson(String str) => List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));

String bookToJson(List<Book> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book {
  Model model;
  int pk;
  Fields fields;

  Book({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    model: modelValues.map[json["model"]]!,
    pk: json["pk"],
    fields: Fields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "model": modelValues.reverse[model],
    "pk": pk,
    "fields": fields.toJson(),
  };
}

class Fields {
  String title;
  String? authors;
  String categories;
  String thumbnail;
  String description;
  int publishedYear;
  double averageRating;
  int numPages;
  int price;

  Fields({
    required this.title,
    required this.authors,
    required this.categories,
    required this.thumbnail,
    required this.description,
    required this.publishedYear,
    required this.averageRating,
    required this.numPages,
    required this.price,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    title: json["title"],
    authors: json["authors"],
    categories: json["categories"],
    thumbnail: json["thumbnail"],
    description: json["description"],
    publishedYear: json["published_year"],
    averageRating: json["average_rating"]?.toDouble(),
    numPages: json["num_pages"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "authors": authors,
    "categories": categories,
    "thumbnail": thumbnail,
    "description": description,
    "published_year": publishedYear,
    "average_rating": averageRating,
    "num_pages": numPages,
    "price": price,
  };
}

enum Categories {
  COMICS_GRAPHIC_NOVELS,
  COOKING,
  FICTION,
  HISTORY,
  PHILOSOPHY
}

final categoriesValues = EnumValues({
  "Comics & Graphic Novels": Categories.COMICS_GRAPHIC_NOVELS,
  "Cooking": Categories.COOKING,
  "Fiction": Categories.FICTION,
  "History": Categories.HISTORY,
  "Philosophy": Categories.PHILOSOPHY
});

enum Model {
  BOOK_BOOK
}

final modelValues = EnumValues({
  "book.book": Model.BOOK_BOOK
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
