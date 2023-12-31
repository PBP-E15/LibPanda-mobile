import 'dart:async';

import 'package:intl/intl.dart';
import 'package:lib_panda/models/wishlist.dart';
import 'package:lib_panda/screens/home_page.dart';
import 'package:lib_panda/screens/profile_page.dart';
import 'package:lib_panda/screens/request_books.dart';
import 'package:lib_panda/screens/search_page.dart';
import 'package:lib_panda/screens/shopping_cart.dart';
import 'package:lib_panda/widgets/navbar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lib_panda/models/Book.dart' as Bookdetails;
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _currentIndex = 3;
  final TextEditingController _searchController = TextEditingController();
  List<Wishlist> _filteredProducts = [];
  List<Wishlist> list_productOriginal = [];
  Timer? _debounceTimer;

  void _onNavbarItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BookHomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BookListPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeRequest()),
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
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
        break;
    }
  }

  Future<List<Wishlist>> fetchProduct(request) async {
    var response =
        await request.get('https://libpanda-e15-tk.pbp.cs.ui.ac.id/wishlist/json/');

    list_productOriginal.clear();

    List<Wishlist> listProduct = [];
    for (var d in response) {
      if (d != null) {
        listProduct.add(Wishlist.fromJson(d));
      }
    }

    list_productOriginal.addAll(listProduct);

    return listProduct;
  }

  @override
  Widget build(BuildContext context) {
    final Bookdetails.Book bookdetails;
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
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
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                    style: const TextStyle(color: Colors.white), 

                  onChanged: (value) {
                    // Hapus timer sebelumnya jika ada
                    if (_debounceTimer != null) {
                      _debounceTimer!.cancel();
                    }

                    // Tentukan durasi debounced
                    const Duration debounceDuration = Duration(milliseconds: 500);

                    // Atur timer baru
                    _debounceTimer = Timer(debounceDuration, () {
                      setState(() {
                        _filteredProducts = list_productOriginal
                            .where((product) =>
                                product.book.title.toLowerCase().contains(value.toLowerCase()))
                            .toList();
                      });
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by book title...',
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.5), 
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), 
                    ),
                    labelStyle: const TextStyle(color: Colors.white),
                    prefixIcon: const Icon(Icons.search, color: Colors.white), 
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: fetchProduct(request),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (!snapshot.hasData) {
                        return const Column(
                          children: [
                            Text(
                              "No Books available.",
                              style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                            ),
                            SizedBox(height: 8),
                          ],
                        );
                      } else {
                        return ListView.builder(
                          itemCount: _filteredProducts.isEmpty
                              ? snapshot.data!.length
                              : _filteredProducts.length,
                          itemBuilder: (_, index) => Card(
                            color: const Color.fromARGB(255, 255, 253, 208),
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      // Thumbnail
                                      Padding(
                                        padding: const EdgeInsets.only(right: 16.0),
                                        child: Image.network(
                                          "${_filteredProducts.isEmpty ? snapshot.data![index].book.thumbnail : _filteredProducts[index].book.thumbnail}",
                                          width: 100,
                                          height: 150,
                                          fit: BoxFit.cover,
                                          errorBuilder: (BuildContext context, Object error,
                                              StackTrace? stackTrace) {
                                            return Container(
                                              width: 100,
                                              height: 150,
                                              color: Colors.grey,
                                              child: const Center(
                                                child: Icon(Icons.error),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      // Informasi Judul, Harga, Kategori
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${_filteredProducts.isEmpty ? snapshot.data![index].book.title : _filteredProducts[index].book.title}",
                                              style: const TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                                "Price:${NumberFormat.currency(locale: 'id_ID', symbol: ' ').format(_filteredProducts.isEmpty ? snapshot.data![index].book.price : _filteredProducts[index].book.price)}"),
                                            const SizedBox(height: 10),
                                            Text(
                                                "Categories: ${_filteredProducts.isEmpty ? snapshot.data![index].book.categories : _filteredProducts[index].book.categories}"),
                                          ],
                                        ),
                                      ),
                                      // Tombol Delete
                                      ElevatedButton(
                                        onPressed: () async {
                                          // TODO: Add logic for Delete
                                          bool deleteConfirmed = await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text("Delete Confirmation"),
                                                content: const Text(
                                                    "Are you sure you want to remove this book from your wishlist?"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context, false); // Batalkan penghapusan
                                                    },
                                                    child: const Text("Cancel"),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, true); // Konfirmasi penghapusan
                                                    },
                                                    child: const Text("Delete"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          // Jika pengguna mengkonfirmasi penghapusan, lakukan penghapusan
                                          if (deleteConfirmed == true) {
                                            final response = await request.postJson(
                                              "https://libpanda-e15-tk.pbp.cs.ui.ac.id/wishlist/removed_wishlist_flutter/",
                                              jsonEncode(<String, String>{
                                                'wishlist_id': snapshot.data![index].pk.toString(),
                                              }),
                                            );
                                            if (response['status'] ==
                                                'Book removed from wishlist successfully') {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        "Book removed from wishlist successfully"),
                                                  ));
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => const ProductPage()),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text("Terdapat kesalahan, silakan coba lagi."),
                                                  ));
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green.shade800,
                                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  // ExpansionTile untuk menampilkan informasi buku
                                  ExpansionTile(
                                    title: const Text("Book Information"),
                                    tilePadding: EdgeInsets.zero, 

                                    children: [
                                      Text(
                                        "${_filteredProducts.isEmpty ? snapshot.data![index].book.description : _filteredProducts[index].book.description}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                          "Authors: ${_filteredProducts.isEmpty ? snapshot.data![index].book.authors : _filteredProducts[index].book.authors}"),
                                      Text(
                                          "Published Year: ${_filteredProducts.isEmpty ? snapshot.data![index].book.publishedYear : _filteredProducts[index].book.publishedYear}"),
                                      Text(
                                          "Average Rating: ${_filteredProducts.isEmpty ? snapshot.data![index].book.averageRating : _filteredProducts[index].book.averageRating}"),
                                      Text(
                                          "Number of Pages: ${_filteredProducts.isEmpty ? snapshot.data![index].book.numPages : _filteredProducts[index].book.numPages}"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Navbar(
        currentIndex: _currentIndex,
        onTap: _onNavbarItemTapped,
      ),
    );
  }
}
