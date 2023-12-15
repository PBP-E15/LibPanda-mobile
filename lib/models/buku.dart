// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
    int pk;
    Book book;

    Product({
        required this.pk,
        required this.book,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        pk: json["pk"],
        book: Book.fromJson(json["book"]),
    );

    Map<String, dynamic> toJson() => {
        "pk": pk,
        "book": book.toJson(),
    };
}

class Book {
    String thumbnail;
    String title;
    String authors;
    double averageRating;
    int price;
    String categories;
    bool inWishlist;

    Book({
        required this.thumbnail,
        required this.title,
        required this.authors,
        required this.averageRating,
        required this.price,
        required this.categories,
        required this.inWishlist,
    });

    factory Book.fromJson(Map<String, dynamic> json) => Book(
        thumbnail: json["thumbnail"],
        title: json["title"],
        authors: json["authors"],
        averageRating: json["average_rating"]?.toDouble(),
        price: json["price"],
        categories: json["categories"],
        inWishlist: json["in_wishlist"],
    );

    Map<String, dynamic> toJson() => {
        "thumbnail": thumbnail,
        "title": title,
        "authors": authors,
        "average_rating": averageRating,
        "price": price,
        "categories": categories,
        "in_wishlist": inWishlist,
    };
}
