// To parse this JSON data, do
//
//     final cart = cartFromJson(jsonString);

import 'dart:convert';

List<Cart> cartFromJson(String str) => List<Cart>.from(json.decode(str).map((x) => Cart.fromJson(x)));

String cartToJson(List<Cart> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cart {
    int pk;
    Books book;

    Cart({
        required this.pk,
        required this.book,
    });

    factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        pk: json["pk"],
        book: Books.fromJson(json["book"]),
    );

    Map<String, dynamic> toJson() => {
        "pk": pk,
        "book": book.toJson(),
    };
}

class Books {
    String thumbnail;
    String title;
    String authors;
    double averageRating;
    int price;
    String categories;
    bool inCart;

    Books({
        required this.thumbnail,
        required this.title,
        required this.authors,
        required this.averageRating,
        required this.price,
        required this.categories,
        required this.inCart,
    });

    factory Books.fromJson(Map<String, dynamic> json) => Books(
        thumbnail: json["thumbnail"],
        title: json["title"],
        authors: json["authors"],
        averageRating: json["average_rating"]?.toDouble(),
        price: json["price"],
        categories: json["categories"],
        inCart: json["in_cart"],
    );

    Map<String, dynamic> toJson() => {
        "thumbnail": thumbnail,
        "title": title,
        "authors": authors,
        "average_rating": averageRating,
        "price": price,
        "categories": categories,
        "in_cart": inCart,
    };
}