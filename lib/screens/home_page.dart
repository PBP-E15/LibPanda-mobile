// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lib_panda/models/Book.dart';
//import 'package:lib_panda/models/wishlist.dart';
import 'package:lib_panda/screens/book_details.dart';
import 'package:lib_panda/screens/profile_page.dart';
import 'package:lib_panda/screens/request_books.dart';
import 'package:lib_panda/screens/search_page.dart';
import 'package:lib_panda/screens/shopping_cart.dart';
import 'package:lib_panda/screens/wishlist.dart';
import 'package:lib_panda/widgets/navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Book Viewer',
      
      home: BookHomePage(),
    );
  }
}
// Book and other classes remain unchanged


class BookHomePage extends StatefulWidget {
  const BookHomePage({super.key});

  @override
  _BookHomePageState createState() => _BookHomePageState();
}

class _BookHomePageState extends State<BookHomePage> {
  late Future<List<Book>> futureBooks;
  List<Book> listBook = <Book>[];
  List<Book> listBookOriginal = <Book>[];
  bool isSearchVisible = false;
  String searchText = '';
  int _currentIndex = 0;

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

  @override
  void initState() {
    super.initState();
    futureBooks = fetchBooks();
  }

  void sortBooks(List<Book> listBookParam, String name) {
    setState(() {
      if (name.isEmpty) {
        listBook = listBookOriginal;
      }
      listBook = listBookParam
          .where((book) =>
          book.fields.title.toLowerCase().contains(name.toLowerCase()))
          .toList();

      List<Book> listBookTemp = <Book>[];
      listBookTemp.length;
    });
  }

  Future<List<Book>> fetchBooks() async {
    final response = await http.get(
        Uri.parse('https://libpanda-e15-tk.pbp.cs.ui.ac.id/api/books'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      List<Book> books = jsonResponse.map((book) => Book.fromJson(book)).toList();

      if (listBookOriginal.isEmpty) {
        listBook.length;
        listBook = books;
        listBookOriginal = books;
      }

      // Shuffle the list of books
      books.shuffle();

      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LibPanda'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
        actions: [
          if (isSearchVisible)
            Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: Colors.white,
                  ),
                  onChanged: (value) {
                    searchText = value;
                    sortBooks(listBookOriginal, searchText);
                  },
                  decoration: searchText.compareTo('') == 0
                      ? const InputDecoration(
                    hintText: 'Search by book name...',
                    hintStyle: TextStyle(color: Colors.white),
                  ) :
                  InputDecoration(
                    hintText: searchText,
                    hintStyle: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.search,
              size: 28.0,
              color: Colors.white,),
            onPressed: () {
              setState(() {
                isSearchVisible = !isSearchVisible;
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: Navbar(
        currentIndex: _currentIndex,
        onTap: _onNavbarItemTapped,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'images/bglogin.jpg',
            fit: BoxFit.cover,
            color: Colors.black87,
            colorBlendMode: BlendMode.darken,
          ),
          Center(
        child: FutureBuilder<List<Book>>(
          future: futureBooks,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                padding: const EdgeInsets.all(8.0),
                itemCount: listBook.length,
                itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  color: Colors.grey[800], // Slightly brighter grey for the card background

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookDetailsPage(
                              book: listBook[index],
                            ),
                          ),
                        );
                      },
                      // Add onTap functionality
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Update image layout and placeholder
                          Expanded(
                              child: Image.network(
                                listBook[index].fields.thumbnail,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Placeholder(
                                    fallbackHeight: 100,
                                    fallbackWidth: 100,
                                  );
                                },
                                //fit: BoxFit.cover, // Adjust the image to cover the space
                                width: 150, // Take full available width
                                height: double.infinity, // Set a fixed height for the image
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              listBook[index].fields.title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline6!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
            },
            ),
          ),
        ],
      ),
    );
  }
}