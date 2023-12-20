import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lib_panda/models/Book.dart';
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class BookDetailsPage extends StatelessWidget {
  final Book book;

  const BookDetailsPage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text(book.fields.title),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'images/bglogin.jpg',
            fit: BoxFit.cover,
            color: Colors.black87,
            colorBlendMode: BlendMode.darken,
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                        child: SizedBox(
                          width: double.infinity,
                          height: 300, // Adjust the height of the image
                          child: Image.network(
                            book.fields.thumbnail,
                            fit: BoxFit.contain, // Ensure the whole image is visible
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0), // Adjust top padding
                        child: Column(
                          children: [
                            Text(
                              'Price:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24, // Increase font size of price text
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8), // Add space between price text and value
                            Text(
                              formatCurrency.format(book.fields.price ?? 0),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 32, // Increase font size of price value
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      shape: CircleBorder(),
                      color: Colors.grey[800],
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50.0),
                         onTap: () async {
                            // Implement wishlist functionality
                              // Kirim ke Django dan tunggu respons
                              // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                              final response = await request.postJson(
                              "https://libpanda-e15-tk.pbp.cs.ui.ac.id/wishlist/add_wishlist_flutter/",
                              jsonEncode(<String, String>{
                                  'book_id': book.pk.toString(),
                                  // TODO: Sesuaikan field data sesuai dengan aplikasimu
                              }));
                              if (response['status'] == 'Book added to wishlist successfully') {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                  content: Text("Book added to wishlist successfully"),
                                  ));
                              } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                      content:
                                          Text("Buku sudah ada di wishlist."),
                                  ));
                              }
                          },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.favorite,
                            size: 40,
                            color: const Color.fromARGB(255, 255, 90, 90),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 40),
                    Material(
                      shape: CircleBorder(),
                      color: Colors.grey[800],
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50.0),
                        onTap: () async {
                            final response = await request.postJson(
                              "https://libpanda-e15-tk.pbp.cs.ui.ac.id/shoppingcart/add_cart_flutter/",
                              jsonEncode(<String, String>{
                                'book_id': book.pk.toString(),
                              }));
                              if (response['status'] == 'Book added to shopping cart successfully') {
                                ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                  content: 
                                  Text("Book added to shopping cart successfully"),
                                ));
                              } else {
                                  ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                    content:
                                      Text("Book is already in the shopping cart"),
                                  ));
                              }
                          },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.shopping_cart,
                            size: 40,
                            color: Color.fromARGB(255, 255, 198, 75),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Title:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          book.fields.title,
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                         SizedBox(height: 10),
                    Text(
                      'Authors:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      book.fields.authors ?? 'N/A',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Categories:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      book.fields.categories,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Description:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      book.fields.description,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Published Year: ${book.fields.publishedYear ?? 'N/A'}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Average Rating: ${book.fields.averageRating ?? 'N/A'}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Number of Pages: ${book.fields.numPages ?? 'N/A'}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

