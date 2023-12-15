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
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ));
  }
}
