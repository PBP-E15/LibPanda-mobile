// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lib_panda/models/Book.dart';
import 'book_details.dart';



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

  @override
  void initState() {
    super.initState();
    futureBooks = fetchBooks();
  }

  Future<List<Book>> fetchBooks() async {
    final response = await http.get(
        Uri.parse('https://libpanda-e15-tk.pbp.cs.ui.ac.id/api/books'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      List<Book> books = jsonResponse.map((book) => Book.fromJson(book)).toList();

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
                itemCount: snapshot.data!.length,
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
                              book: snapshot.data![index],
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
                                snapshot.data![index].fields.thumbnail,
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
                              snapshot.data![index].fields.title,
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

