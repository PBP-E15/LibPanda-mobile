import 'package:flutter/material.dart';
import 'package:lib_panda/models/RequestedBooks.dart';
import 'package:lib_panda/widgets/navbar.dart';
import 'package:lib_panda/screens/home_page.dart';
import 'package:lib_panda/screens/search_page.dart';
import 'package:lib_panda/screens/request_books.dart';

List<RequestedBooks> itemList = [];

class RequestFormPage extends StatefulWidget {
  const RequestFormPage({Key? key}) : super(key: key);

  @override
  State<RequestFormPage> createState() => _RequestFormPageState();
}

class _RequestFormPageState extends State<RequestFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _author;
  String? _category; // Make category nullable
  late int _year;
  int _currentIndex = 2;

  List<String> _categories = [
    'Fiction',
    'History',
    'Cooking',
    'Graphic Novels',
    'Philosophy'
  ];

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
        title: const Center(
          child: Text(
            'Form Tambah Item',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white, // Set text color to white
            ),
          ),
        ),
        foregroundColor: Colors.white,
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Title",
                    labelText: "Title",
                    hintStyle: TextStyle(
                        color: Colors.white
                            .withOpacity(0.5)), // Set hint text color
                    labelStyle:
                        TextStyle(color: Colors.white), // Set label text color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide:
                          BorderSide(color: Colors.white), // Set border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                          color: Colors.white), // Set focused border color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                          color: Colors.white), // Set enabled border color
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _title = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Title cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Author",
                    labelText: "Author",
                    hintStyle: TextStyle(
                        color: Colors.white
                            .withOpacity(0.5)), // Set hint text color
                    labelStyle:
                        TextStyle(color: Colors.white), // Set label text color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide:
                          BorderSide(color: Colors.white), // Set border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                          color: Colors.white), // Set focused border color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                          color: Colors.white), // Set enabled border color
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _author = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Author cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: _category,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    hintStyle: TextStyle(
                        color: Colors.white
                            .withOpacity(0.5)), // Set hint text color
                    labelStyle:
                        TextStyle(color: Colors.white), // Set label text color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide:
                          BorderSide(color: Colors.white), // Set border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                          color: Colors.white), // Set focused border color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                          color: Colors.white), // Set enabled border color
                    ),
                  ),
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _category = value;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Category cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Year Published",
                    labelText: "Year Published",
                    hintStyle: TextStyle(
                        color: Colors.white
                            .withOpacity(0.5)), // Set hint text color
                    labelStyle:
                        TextStyle(color: Colors.white), // Set label text color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide:
                          BorderSide(color: Colors.white), // Set border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                          color: Colors.white), // Set focused border color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                          color: Colors.white), // Set enabled border color
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _year = int.parse(value!);
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Year Published cannot be empty!";
                    }
                    if (int.tryParse(value) == null) {
                      return "Year Published must be a number!";
                    }
                    return null;
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        RequestedBooks newItem = RequestedBooks(
                          title: _title,
                          author: _author,
                          category: _category ?? "",
                          year: _year,
                        );
                        itemList.add(newItem);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                  'The book has been successfully requested'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Title: $_title'),
                                    Text('Author: $_author'),
                                    Text('Category: $_category'),
                                    Text('Year Published: $_year'),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        _formKey.currentState!.reset();
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
