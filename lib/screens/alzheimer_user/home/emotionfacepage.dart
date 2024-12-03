import 'package:flutter/material.dart';

class EmotionFace extends StatelessWidget {
final String emotionFace;

  const EmotionFace({
    super.key,
    required this.emotionFace,});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.purple[600],
        borderRadius: BorderRadius.circular(12)
      ),
      padding: EdgeInsets.all(12),
      child: Center(
        child: Text(
          emotionFace, 
          style: TextStyle( 
            fontSize: 28,          
        ),
      )
    ),
    );  
    
  }
  }