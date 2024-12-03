
import 'package:flutter/material.dart';

class TapNavigation extends StatelessWidget {

  final Widget child;
  final Widget? destination;
  final VoidCallback? onTap;
  final Function? onBeforeNavigate;
  // Add this parameter

  const TapNavigation({super.key, 
    required this.child, required this.destination, this.onTap, this.onBeforeNavigate});
  

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
        () {
          // First, check if there's a 'before navigate' function and run it.
          if (onBeforeNavigate != null) {
            onBeforeNavigate!(); // Call the function like _saveUserRole('family')
          }

          // Then, if the destination is not null, navigate to it.     
          if (destination != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination!),
            );
          }
        },
        child: child,
    );
  }
        
}
