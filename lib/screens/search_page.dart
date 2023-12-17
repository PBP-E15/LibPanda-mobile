import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lib_panda/models/Book.dart';
import 'package:intl/intl.dart';
import 'package:lib_panda/screens/home_page.dart';
import 'package:lib_panda/screens/profile_page.dart';
import 'package:lib_panda/widgets/navbar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class BookListPage extends StatefulWidget {
  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  bool sortCategoryAscending = true;
  bool sortPriceAscending = true;
  bool isSearchVisible = false;
  String selectedCategory = 'All Categories';
  String searchText = '';
  List<Book> listBook = <Book>[];
  List<Book> listBookOriginal = <Book>[];
  List<String> categories = <String>[];
  int _currentIndex = 1;

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

        break;
      case 2:

        break;
      case 3:

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

  void sortBooks(List<Book> listBookParam,  String category, String name, bool checkPrice) {

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

      selectedCategory = category;
      if (category != 'All Categories') {
        for (int i = 0; i < listBook.length; i++) {
          if(listBook[i].fields.categories == (category)) {
            listBookTemp.add(listBook[i]);
          }
        }
        listBook = listBookTemp;
      }

      if (checkPrice) {
        listBook.sort((a, b) =>
        sortPriceAscending ? a.fields.price.compareTo(b.fields.price) : b.fields.price.compareTo(a.fields.price));

        sortPriceAscending = !sortPriceAscending;
      }
      else {
        sortPriceAscending = !sortPriceAscending;

        listBook.sort((a, b) =>
        sortPriceAscending ? a.fields.price.compareTo(b.fields.price) : b.fields.price.compareTo(a.fields.price));

        sortPriceAscending = !sortPriceAscending;
      }
    });
  }

  Future<List<Book>> fetchBook() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        'https://libpanda-e15-tk.pbp.cs.ui.ac.id/api/books');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    if (!categories.contains('All Categories')) {
      categories.add('All Categories');
    }

    List<Book> list_book = [];
    for (var d in data) {
      if (d != null) {
        if (!categories.contains(Book.fromJson(d).fields.categories)) {
          categories.add(Book.fromJson(d).fields.categories);
        }
        list_book.add(Book.fromJson(d));
      }
    }

    if (listBookOriginal.length == 0) {
      listBook.length;
      listBook = list_book;
      listBook.shuffle();
      listBookOriginal = list_book;
    }

    return list_book;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
        appBar: AppBar(
          title: Text('Library'),
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
                      sortBooks(listBookOriginal, selectedCategory, searchText, false);
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
        body: FutureBuilder(
            future: fetchBook(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (!snapshot.hasData) {
                  return const Column(
                    children: [
                      Text(
                        "Tidak ada data buku.",
                        style:
                        TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                } else {
                  return Theme(data: ThemeData.dark(),
                      child: CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            backgroundColor: Colors.grey[900],
                            pinned: true,
                            flexibleSpace: FlexibleSpaceBar(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  DropdownButton<String>(
                                    value: selectedCategory,
                                    items: categories.map((String category) {
                                      return DropdownMenuItem<String>(
                                        value: category,
                                        child: Text(
                                          category,
                                          style: TextStyle(
                                            color: Colors.white, // Set text color to white
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      sortBooks(listBookOriginal, newValue!, searchText, false);
                                    },
                                  ),
                                  SizedBox(width: 20),
                                  InkWell(
                                    onTap: () {
                                      sortBooks(listBookOriginal, selectedCategory, searchText, true); },
                                    child: Row(
                                      children: [
                                        Text(
                                          'Price',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),),
                                        Icon(sortPriceAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: Colors.grey[800],
                                    elevation: 5,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(8),
                                      leading: Container(
                                        width: 80,
                                        height: 80,
                                        child: Image.network('${listBook[index].fields.thumbnail}'),
                                      ),
                                      title: Text("${listBook[index].fields.title}",
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          SizedBox(height: 8),
                                          Text('Category: ${listBook[index].fields.categories}',
                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300)),
                                          SizedBox(height: 4),
                                          Text('Price: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(listBook[index].fields.price)}',
                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300)),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              childCount: listBook.length,
                            ),
                          ),
                        ],
                      ));
                }
              }
            }));
  }
}
