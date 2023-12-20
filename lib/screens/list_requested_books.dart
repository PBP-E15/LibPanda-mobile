import 'package:flutter/material.dart';
import 'package:lib_panda/models/RequestedBooks.dart';

class RequestedListPage extends StatefulWidget {
  final List<RequestedBooks> itemList;

  const RequestedListPage({Key? key, required this.itemList}) : super(key: key);

  @override
  _RequestedListPageState createState() => _RequestedListPageState();
}

class _RequestedListPageState extends State<RequestedListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Requested Books',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'images/bglogin.jpg',
            fit: BoxFit.cover,
            color: Colors.black87,
            colorBlendMode: BlendMode.darken,
          ),
          ListView.builder(
            itemCount: widget.itemList.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                color: Colors.grey[800],
                child: ListTile(
                  title: Text(
                    widget.itemList[index].title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Author: ${widget.itemList[index].author}',
                    style: const TextStyle(color: Colors.white),
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
        ],
      ),
    );
  }
}
