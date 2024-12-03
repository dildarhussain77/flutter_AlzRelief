// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class LogoImage extends StatelessWidget {
  final String imagePath;
  final Color? borderColor;

  const LogoImage({Key? key, 
    required this.imagePath,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200, // Adjust the width of the container as needed
      height: 200, // Adjust the height of the container as needed

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,          
            border: borderColor != null
              ? Border.all(
                  color: borderColor!, // Use null-aware operator
                  width: 2, // Set the border width here
                )
              : null,
          ),
          
        child: ClipOval(
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain, // Adjust the fit of the image inside the container            
          ),
        ),
        ),
      ),
    );
  }
}
