// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lib_panda/models/Book.dart';
import 'package:lib_panda/screens/profile_page.dart';
import 'package:lib_panda/screens/search_page.dart';
import 'package:lib_panda/widgets/navbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Viewer',
      
      home: BookHomePage(),
    );
  }
}
// Book and other classes remain unchanged


class BookHomePage extends StatefulWidget {
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
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BookListPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
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
      if (name.length == 0) {
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

      if (listBookOriginal.length == 0) {
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
        title: Text('LibPanda'),
        backgroundColor: Colors.grey[800],
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
                      ? InputDecoration(
                    hintText: 'Search by book name...',
                    hintStyle: TextStyle(color: Colors.white),
                  ) :
                  InputDecoration(
                    hintText: searchText,
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          IconButton(
            icon: Icon(Icons.search,
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
      body: Center(
        child: FutureBuilder<List<Book>>(
          future: futureBooks,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                padding: EdgeInsets.all(8.0),
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
                                  return Placeholder(
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
                            padding: EdgeInsets.all(8.0),
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
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class BookDetailsPage extends StatelessWidget {
  final Book book;

  const BookDetailsPage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.fields.title),
        backgroundColor: Colors.grey[800],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              book.fields.thumbnail,
              errorBuilder: (context, error, stackTrace) {
                return Placeholder(
                  fallbackHeight: 100,
                  fallbackWidth: 100,
                );
              },
            ),
            SizedBox(height: 20),
            Text('Title: ${book.fields.title}'),
            Text('Authors: ${book.fields.authors ?? "N/A"}'),
            Text('Categories: ${book.fields.categories}'),
            Text('Description: ${book.fields.description}'),
            Text('Published Year: ${book.fields.publishedYear.toString()}'),
            Text('Average Rating: ${book.fields.averageRating.toString()}'),
            Text('Number of Pages: ${book.fields.numPages.toString()}'),
            Text('Price: \$${book.fields.price.toString()}'),
          ],
        ),
      ),
    );
  }
}
