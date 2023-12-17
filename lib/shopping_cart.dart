import 'package:lib_panda/models/ShoppingCart.dart';
import 'package:lib_panda/models/ShoppingCart.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ShoppingCart extends StatefulWidget {
    const ShoppingCart({Key? key}) : super(key: key);

    @override
    _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
Future<List<Cart>> fetchProduct(request) async {
    var url = Uri.parse(
        'http://libpanda-e15-tk.pbp.cs.ui.ac.id/shoppingcart/json/');
        
    var response = await request.get(
        'http://libpanda-e15-tk.pbp.cs.ui.ac.id/shoppingcart/json/',
    );

    List<Cart> list_cart = [];
    for (var d in response) {
        if (d != null) {
            list_cart.add(Cart.fromJson(d));
        }
    }

    void deleteAllItems() {
      list_cart.clear();
    }

    return list_cart;
}

@override
Widget build(BuildContext context) {
  final request = context.watch<CookieRequest>();
    return Scaffold(
        appBar: AppBar(
        title: const Text('Shopping Cart'),
        ),
        //drawer: const LeftDrawer(),
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
                            "Tidak ada data produk.",
                            style:
                                TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                        ),
                        SizedBox(height: 8),
                        ],
                    );
                } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, index) => Container(
                                margin: 
                                  const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12
                                  ),
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
                                    Text(
                                        "${snapshot.data![index].book.categories}")
                                  ],
                                ),
                            )
                          );
                    }
                }
              }
            ),
            
          floatingActionButton: FloatingActionButton.extended (
            onPressed: deleteAllItems,
            label: Text('BUY'),
            icon: Icon(Icons.shopping_cart),
            backgroundColor: Colors.blue,
          ),
        );
    }
}