import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lib_panda/models/Book.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
      elevation: 3,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
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
