import 'package:lib_panda/models/wishlist.dart';
import 'package:lib_panda/screens/book_details.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lib_panda/models/Book.dart' as Bookdetails;
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);
  
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Future<List<Wishlist>> fetchProduct(request) async {
    var response = await request.get('http://127.0.0.1:8000/wishlist/json/');
    final Wishlist wishlist;
    
    List<Wishlist> list_product = [];
    for (var d in response) {
      if (d != null) {
        list_product.add(Wishlist.fromJson(d));
      }
    }
    return list_product;
  }

  @override
  Widget build(BuildContext context) {
    final Bookdetails.Book bookdetails;
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
      ),
      body: FutureBuilder(
        future: fetchProduct(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    "Tidak ada data Buku.",
                    style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Image.network(
                        "${snapshot.data![index].book.thumbnail}",
                        width: 100,
                        height: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                          return Container(
                            width: 100,
                            height: 150,
                            color: Colors.grey,
                            child: Center(
                              child: Icon(Icons.error),
                            ),
                          );
                        },
                      ),
                      Text(
                        "${snapshot.data![index].book.title}",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("${snapshot.data![index].book.price}"),
                      const SizedBox(height: 10),
                      Text("${snapshot.data![index].book.categories}"),
                      const SizedBox(height: 10),
                      // ExpansionTile untuk menampilkan informasi buku
                      ExpansionTile(
                        title: Text("Book Information"),
                        children: [
                          Text("Authors: ${snapshot.data![index].book.authors}"),
                          Text("Description: ${snapshot.data![index].book.description}"),
                          Text("Published Year: ${snapshot.data![index].book.publishedYear}"),
                          Text("Average Rating: ${snapshot.data![index].book.averageRating}"),
                          Text("Number of Pages: ${snapshot.data![index].book.numPages}"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              // TODO: Add logic for Delete
                              // You can show a confirmation dialog and delete the item if confirmed.
                              final response = await request.postJson(
                                "http://127.0.0.1:8000/wishlist/removed_wishlist_flutter/",
                                jsonEncode(<String, String>{
                                  'wishlist_id': snapshot.data![index].pk.toString()
                                  // TODO: Sesuaikan field data sesuai dengan aplikasimu
                                }),
                              );
                              if (response['status'] == 'Book removed from wishlist successfully') {
                                ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                    content: Text("Book removed from wishlist successfully"),
                                  ));
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ProductPage()),
                                );
                              } else {
                                ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                    content: Text("Terdapat kesalahan, silakan coba lagi."),
                                  ));
                              }
                            },
                            child: Text("Delete"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
