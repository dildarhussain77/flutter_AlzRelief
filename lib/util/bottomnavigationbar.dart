
import 'package:flutter/material.dart';

class BottomNavigationBar extends StatelessWidget {

  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavigationBarItem> items;

  const BottomNavigationBar({super.key, 
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  // int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
    );
   
  }
}