import 'dart:async';
import 'package:flutter/material.dart';

enum Emotion { Happy, Sad, Confused, Angry }
class EmotionHandler {
  static bool _isTimerActive = false;  
  static void selectEmotion(BuildContext context, Emotion emotion) {
    if(!_isTimerActive){
      String emotionMessage = '';
      switch (emotion) {
        case Emotion.Happy:
          emotionMessage = "You seem happy! Keep embracing the positive moments and let them fuel your journey.";
          break;
        case Emotion.Sad:
          emotionMessage = "You seem sad. It's okay to feel this way. Remember, you're not alone.";
          break;
        case Emotion.Confused:
          emotionMessage = "Feeling confused? Take a deep breath and relax.";
          break;
        case Emotion.Angry:
          emotionMessage = "Take a moment to calm down. Remember, forgiveness is a gift you give yourself..";
          break;
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Emotion Response"),
            content: Text(emotionMessage),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      // Start the timer
      _isTimerActive = true;
      Timer(Duration(seconds: 10), () {
        _isTimerActive = false;
      });
    }
    else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Please Wait"),
            content: Text("Please wait for 10 Seconds between emotion selections."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
