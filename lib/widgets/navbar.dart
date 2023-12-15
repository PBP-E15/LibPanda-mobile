// navbar.dart

import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  Navbar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return
      Theme(data: ThemeData.dark(),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            iconSize: 32,
            selectedItemColor: Colors.white,
            currentIndex: currentIndex,
            onTap: onTap,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Homepage',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_books),
                label: 'Library',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_add),
                label: 'Request',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Wishlist',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ));
  }
}
