import 'package:flutter/material.dart';
import 'package:lib_panda/models/RequestedBooks.dart';
import 'package:lib_panda/widgets/navbar.dart';
import 'package:lib_panda/screens/home_page.dart';
import 'package:lib_panda/screens/search_page.dart';
import 'package:lib_panda/screens/request_books.dart';

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
        // Handle case 3
        break;
      case 4:
        // Handle case 4
        break;
      case 5:
        // Handle case 5
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
            color: Colors.white, // Set text color to white
          ),
        ),
        // leading: GestureDetector(
        //   onTap: () {
        //     Navigator.pop(context); // Go back to the previous screen
        //   },
        //   child: Icon(Icons.arrow_back),
        // ),
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
            child: ListTile(
              title: Text(widget.itemList[index].title),
              subtitle: Text('Author: ${widget.itemList[index].author}'),
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
                          Text(
                              'Year Published: ${widget.itemList[index].year}'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Closed'),
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
