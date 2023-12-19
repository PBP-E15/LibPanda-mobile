import 'package:flutter/material.dart';
import 'package:lib_panda/models/RequestedBooks.dart';
import 'package:lib_panda/screens/shopping_cart.dart';
import 'package:lib_panda/widgets/navbar.dart';
import 'package:lib_panda/screens/home_page.dart';
import 'package:lib_panda/screens/search_page.dart';
import 'package:lib_panda/screens/request_books.dart';
import 'package:lib_panda/screens/wishlist.dart';
import 'package:lib_panda/screens/profile_page.dart';

class RequestedListPage extends StatefulWidget {
  final List<RequestedBooks> itemList;

  const RequestedListPage({Key? key, required this.itemList}) : super(key: key);

  @override
  _RequestedListPageState createState() => _RequestedListPageState();
}

class _RequestedListPageState extends State<RequestedListPage> {
  int _currentIndex = 2;

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
            MaterialPageRoute(builder: (context) => ShoppingCart()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Requested Books',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.grey[800],
      ),
      bottomNavigationBar: Navbar(
        currentIndex: _currentIndex,
        onTap: _onNavbarItemTapped,
      ),
      body: ListView.builder(
        itemCount: widget.itemList.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: Colors.grey[800],
            child: ListTile(
              title: Text(
                widget.itemList[index].title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Author: ${widget.itemList[index].author}',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(widget.itemList[index].title),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Author: ${widget.itemList[index].author}'),
                          Text('Category: ${widget.itemList[index].category}'),
                          Text('Year Published: ${widget.itemList[index].year}'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
