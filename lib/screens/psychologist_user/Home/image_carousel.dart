import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.3, // Responsive height (30% of screen height)
      padding: EdgeInsets.all(screenWidth * 0.05), // Responsive padding
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(screenWidth * 0.025), // Responsive corner radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Light shadow color
            spreadRadius: screenWidth * 0.005, // Slight spread of the shadow
            blurRadius: screenWidth * 0.03, // Blurry shadow
            offset: Offset(0, screenHeight * 0.01), // Shadow position
          ),
        ],
        color: Colors.white, // Background color for the container
      ),
      child: CarouselSlider.builder(
        itemCount: 3, // Number of images
        itemBuilder: (context, index, realIndex) {
          final List<String> images = [
            'assets/images/AlzReliefImage4.jpg', // Psychologist and patient therapy session
            'assets/images/AlzReliefImage4.jpg',   // Brain image or scan symbolizing mental health
            'assets/images/AlzReliefImage4.jpg',          // Hands offering care or support
            'assets/images/AlzReliefImage4.jpg',       // Calm nature scene promoting mental well-being
            'assets/images/AlzReliefImage4.jpg',  // Psychologist working with a patient or on a laptop
          ];

          return ClipRRect(
            borderRadius: BorderRadius.circular(screenWidth * 0.035), // Responsive corner radius
            child: Image.asset(
              images[index], // Use the image from the list
              fit: BoxFit.cover, // Ensures the image covers the entire area without distortion
              width: double.infinity, // Ensures it spans the full width of the container
              height: screenHeight * 0.3, // Matches the container's height
            ),
          );
        },
        options: CarouselOptions(
          height: screenHeight * 0.3, // Responsive height for the carousel
          autoPlay: true, // Enable auto-play for the carousel
          enlargeCenterPage: true, // Slightly enlarge the center image
          viewportFraction: 1.0, // Ensure the entire carousel is visible
        ),
      ),
    );
  }
}
