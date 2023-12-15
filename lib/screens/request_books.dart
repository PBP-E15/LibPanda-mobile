import 'package:flutter/material.dart';
import 'package:lib_panda/screens/form_request_buku.dart';
import 'package:lib_panda/screens/list_requested_books.dart';
import 'package:lib_panda/screens/home_page.dart';
import 'package:lib_panda/screens/search_page.dart';
import 'package:lib_panda/widgets/navbar.dart';

class HomeRequest extends StatefulWidget {
  @override
  _HomeRequestState createState() => _HomeRequestState();
}

class _HomeRequestState extends State<HomeRequest> {
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
        title: Text('Book Request App'),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: _currentIndex,
        onTap: _onNavbarItemTapped,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: 2,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (index == 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RequestFormPage(),
                  ),
                );
              } else if (index == 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RequestedListPage(itemList: itemList),
                  ),
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[800], // Set background color
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    index == 0
                        ? Icons.mode_edit_outlined
                        : Icons.library_books_outlined,
                    size: 48.0,
                    color: Colors.white, // Set icon color to white
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    index == 0
                        ? 'Request New Books Form'
                        : 'Requested Books List',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white, // Set text color to white
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
