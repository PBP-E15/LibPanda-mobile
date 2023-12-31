// To parse this JSON data, do
//
//     final wishlist = wishlistFromJson(jsonString);

import 'dart:convert';

List<Wishlist> wishlistFromJson(String str) => List<Wishlist>.from(json.decode(str).map((x) => Wishlist.fromJson(x)));

String wishlistToJson(List<Wishlist> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Wishlist {
    int pk;
    Book book;

    Wishlist({
        required this.pk,
        required this.book,
    });

    factory Wishlist.fromJson(Map<String, dynamic> json) => Wishlist(
        pk: json["pk"],
        book: Book.fromJson(json["book"]),
    );

    Map<String, dynamic> toJson() => {
        "pk": pk,
        "book": book.toJson(),
    };
}

class Book {
    int pk;
    int numPages;
    String description;
    int publishedYear;
    String thumbnail;
    String title;
    String authors;
    double averageRating;
    int price;
    String categories;
    bool inWishlist;

    Book({
        required this.pk,
        required this.numPages,
        required this.description,
        required this.publishedYear,
        required this.thumbnail,
        required this.title,
        required this.authors,
        required this.averageRating,
        required this.price,
        required this.categories,
        required this.inWishlist,
    });

    factory Book.fromJson(Map<String, dynamic> json) => Book(
        pk: json["pk"],
        numPages: json["numPages"],
        description: json["description"],
        publishedYear: json["publishedYear"],
        thumbnail: json["thumbnail"],
        title: json["title"],
        authors: json["authors"],
        averageRating: json["averageRating"]?.toDouble(),
        price: json["price"],
        categories: json["categories"],
        inWishlist: json["in_wishlist"],
    );

    Map<String, dynamic> toJson() => {
        "pk": pk,
        "numPages": numPages,
        "description": description,
        "publishedYear": publishedYear,
        "thumbnail": thumbnail,
        "title": title,
        "authors": authors,
        "averageRating": averageRating,
        "price": price,
        "categories": categories,
        "in_wishlist": inWishlist,
    };
}