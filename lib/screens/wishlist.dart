import 'package:intl/intl.dart';
import 'package:lib_panda/models/wishlist.dart';
import 'package:lib_panda/screens/book_details.dart';
import 'package:lib_panda/screens/home_page.dart';
import 'package:lib_panda/screens/profile_page.dart';
import 'package:lib_panda/screens/request_books.dart';
import 'package:lib_panda/screens/search_page.dart';
import 'package:lib_panda/widgets/navbar.dart';
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
  int _currentIndex = 3;

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

        break;
      case 5:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
      
        break;
    }
  }

   Future<List<Wishlist>> fetchProduct(request) async {
    var response = await request.get('https://libpanda-e15-tk.pbp.cs.ui.ac.id/wishlist/json/');
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
                    "Tidak ada data Buku.",
                    style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => Card(
                  // Set background menjadi light grey
                  color: Colors.grey[200],
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
                            // Informasi Judul, Harga, Kategori
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
                                  Text("Price:${NumberFormat.currency(locale: 'id_ID', symbol: ' ').format(snapshot.data![index].book.price)}"),
                                  const SizedBox(height: 10),
                                  Text("Categories: ${snapshot.data![index].book.categories}"),
                                ],
                              ),
                            ),
                            // Tombol Delete
                            ElevatedButton(
                              onPressed: () async {
                                // Tampilkan dialog konfirmasi penghapusan
                                bool deleteConfirmed = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Konfirmasi Penghapusan"),
                                      content: Text("Apakah Anda yakin ingin menghapus buku ini dari wishlist?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, false); // Batalkan penghapusan
                                          },
                                          child: Text("Batal"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context, true); // Konfirmasi penghapusan
                                          },
                                          child: Text("Delete"),
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
                                }
                              },
                              child: Text("Delete"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // ExpansionTile untuk menampilkan informasi buku
                        ExpansionTile(
                          title: Text("Book Information"),
                          children: [
                            Text(
                              "${snapshot.data![index].book.description}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text("Authors: ${snapshot.data![index].book.authors}"),
                            Text("Published Year: ${snapshot.data![index].book.publishedYear}"),
                            Text("Average Rating: ${snapshot.data![index].book.averageRating}"),
                            Text("Number of Pages: ${snapshot.data![index].book.numPages}"),
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
      bottomNavigationBar: Navbar(
        currentIndex: _currentIndex,
        onTap: _onNavbarItemTapped,
      ),
    );
  }
}