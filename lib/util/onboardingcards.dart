import 'package:flutter/material.dart';

class OnBoardingCards extends StatelessWidget {
  final String image,title, description, buttonText;
  final Function onPressed;

  const OnBoardingCards({super.key, 
  required this.image,
  required this.title,
  required this.description,
  required this.buttonText,
  required this.onPressed,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            image,
          ),
          Column(
            children: [
              Text(
                title, 
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(95, 37, 133, 1.0),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 10,
                ),
                child: Text(
                  description, 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    
                  ),
                ),
              ),

            ],
          ),
          //SizedBox(height: 25,),

          MaterialButton(
            minWidth: 300,
            onPressed:  () => onPressed(),
            color: Color.fromRGBO(95, 37, 133, 1.0),
            child: Text(
              buttonText,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            
          ),
        ],
      ),
    );
  }
}