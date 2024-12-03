// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';

class HomePageTile extends StatelessWidget {

  final icon;
  final String iconAsset;
  final String homeTileName;
  final String homeTileDes;
  final color;
  final Color iconColor;
  final double height, width;
   // Add this parameter


  const HomePageTile({
  super.key, 
  required this.icon,
  required this.iconAsset, required this.homeTileName, 
  required this.homeTileDes,
  required this.color, required this.height, required this.width, required this.iconColor, 
   // Add this parameter

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
      height: height,
      width: width,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16)
        ),
        
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.all(4),
                color: color,
                child: iconAsset != null && iconAsset.isNotEmpty // Check if iconAsset is provided
                  ? Image.asset(
                      iconAsset,
                      width: 50,
                      height: 50,
                      //color: Colors.white,
                    )
                  : Icon(
                      icon,
                      color: iconColor,
                      size: 50,
                    ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  homeTileName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  homeTileDes,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                )
              ],
            )
          ],      
        )
      ),
    );
  }
}