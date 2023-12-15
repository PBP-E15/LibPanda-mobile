import 'package:flutter/material.dart';
import 'package:lib_panda/models/Book.dart';
import 'package:intl/intl.dart'; // Import the intl package
// Import any additional dependencies or custom widgets you might use for a modern design
class BookDetailsPage extends StatelessWidget {
  final Book book;

  const BookDetailsPage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

    return Scaffold(
      appBar: AppBar(
        title: Text(book.fields.title),
        backgroundColor: Colors.grey[800],
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Go back to the previous screen
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      book.fields.thumbnail,
                      fit: BoxFit.none, // Do not resize, keep original size
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                        shape: CircleBorder(),
                        color: Colors.grey[800], // Color of the circle
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50.0),
                          onTap: () {
                            // Implement wishlist functionality
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.favorite, // Heart icon for wishlist
                              size: 40, // Adjust the size of the icon
                              color: const Color.fromARGB(255, 255, 90, 90), // Set icon color to white
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 40),
                      Material(
                        shape: CircleBorder(),
                        color: Colors.grey[800], // Color of the circle
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50.0),
                          onTap: () {
                            // Implement shopping cart functionality
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.shopping_cart, // Shopping cart icon
                              size: 40, // Adjust the size of the icon
                              color: Color.fromARGB(255, 255, 198, 75), // Set icon color to white
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Title:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white, // Set text color to white
              ),
            ),
            Text(
              book.fields.title,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              'Price:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              // Format price using NumberFormat
              formatCurrency.format(book.fields.price ?? 0),
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              'Authors:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              book.fields.authors ?? 'N/A',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              'Categories:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              book.fields.categories,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              'Description:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              book.fields.description,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 10),
            // Displaying remaining data from the toJson method
            Text(
              'Published Year: ${book.fields.publishedYear ?? 'N/A'}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Average Rating: ${book.fields.averageRating ?? 'N/A'}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Number of Pages: ${book.fields.numPages ?? 'N/A'}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            // Add more details with similar styling as needed
          ],
        ),
      ),
    );
  }
}