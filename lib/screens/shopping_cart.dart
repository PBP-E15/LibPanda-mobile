import 'package:intl/intl.dart';
import 'package:lib_panda/models/ShoppingCart.dart';
import 'package:lib_panda/screens/book_details.dart';
import 'package:lib_panda/screens/home_page.dart';
import 'package:lib_panda/screens/profile_page.dart';
import 'package:lib_panda/screens/request_books.dart';
import 'package:lib_panda/screens/search_page.dart';
import 'package:lib_panda/screens/wishlist.dart';
import 'package:lib_panda/widgets/navbar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lib_panda/models/Book.dart' as Bookdetails;
import 'package:provider/provider.dart';

class ShoppingCart extends StatefulWidget {
    const ShoppingCart({Key? key}) : super(key: key);

    @override
    _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  int _currentIndex = 4;

  void _onNavbarItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BookHomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BookListPage()),
        );
        break;
      case 2:
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeRequest()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProductPage()),
        );
        break;
      case 4:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ShoppingCart()),
          );
        break;
      case 5:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
      
        break;
    }
  }
    
  Future<List<Cart>> fetchProduct(request) async {
      var response = await request.get('https://libpanda-e15-tk.pbp.cs.ui.ac.id/shoppingcart/json/');
      final Cart cart;

      List<Cart> list_cart = [];
      for (var d in response) {
          if (d != null) {
              list_cart.add(Cart.fromJson(d));
          }
      }
      return list_cart;
  }

  @override
  Widget build(BuildContext context) {
    final Bookdetails.Book bookdetails;
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: Colors.grey[800],
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
                    "Tidak ada data buku.",
                    style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              double totalPrice = snapshot.data!
                  .map((cart) => cart.book.price)
                  .fold(0, (prev, price) => prev + price);

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => Card(
                        color: Color.fromARGB(255, 255, 253, 208),
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: Image.network(
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
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${snapshot.data![index].book.title}",
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text("Price: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(snapshot.data![index].book.price)}"),
                                        const SizedBox(height: 10),
                                        Text("Categories: ${snapshot.data![index].book.categories}"),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      bool deleteConfirmed = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Remove Confirmation"),
                                            content: Text("Are you sure you want to remove this book from your shopping cart?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, false);
                                                },
                                                child: Text("Batal"),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context, true);
                                                },
                                                child: Text("Delete"),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      if (deleteConfirmed == true) {
                                        final response = await request.postJson(
                                          "https://libpanda-e15-tk.pbp.cs.ui.ac.id/shoppingcart/remove_cart_flutter/",
                                          jsonEncode(<String, String>{
                                            'book_id': snapshot.data![index].pk.toString()
                                          }),
                                        );
                                        if (response['status'] == 'Book removed from shopping cart successfully') {
                                          ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                              content: Text("Book removed from shopping cart successfully"),
                                            ));
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => const ShoppingCart()),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                              content: Text("Terdapat kesalahan, silakan coba lagi."),
                                            ));
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green.shade800, 
                                      padding: EdgeInsets.symmetric(vertical: 15.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    child: Text("Delete"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), 
                      color: Color.fromARGB(255, 255, 253, 208), 
                    ),
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Add margin for spacing
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Price:",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(totalPrice)}",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4), 
                  ElevatedButton(
                    onPressed: () async {
                      bool buyConfirmed = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Purchase Confirmation"),
                            content: Text("Are you sure you want to purchase all the books in the shopping cart?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                child: Text("Purchase"),
                              ),
                            ],
                          );
                        },
                      );

                      if (buyConfirmed == true) {
                        final response = await request.postJson(
                          "https://libpanda-e15-tk.pbp.cs.ui.ac.id/shoppingcart/buy_cart_flutter/",
                          jsonEncode({}),
                        );

                        if (response['status'] == 'Berhasil membeli semua buku') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Berhasil membeli semua buku"),
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const ShoppingCart()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Pembayaran Gagal."),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 57, 160, 69), // Adjusted color
                      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0), // Increased padding to widen the button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      "Purchase Now!",
                      style: TextStyle(
                        fontSize: 16, // Adjust the font size if needed
                        color: Colors.white, // Text color set to white
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                SizedBox(height: 8),
                ],
              );
            }
          }
        },
      ),
      bottomNavigationBar: Navbar(
        currentIndex: _currentIndex,
        onTap: _onNavbarItemTapped,
      ),
    );
  }
}