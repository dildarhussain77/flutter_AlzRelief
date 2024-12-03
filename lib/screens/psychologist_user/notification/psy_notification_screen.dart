
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class PsyNotificationPage extends StatefulWidget {
  const PsyNotificationPage({super.key});

  @override
  State<PsyNotificationPage> createState() => _PsyNotificationPageState();
}

class _PsyNotificationPageState extends State<PsyNotificationPage> {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      
        backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
      
        body: Column(
          children: [
        
            //welcome row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Stack(
                 
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                  ),
                                
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7.0),
                      child: Text(
                        "Notifications",                         
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 24, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),                  
        
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 5,
                  right: 5,
                ),              
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  )
                ),
                child: const Center(
                  child: Column(  
                    children: [
                      
                      
                    ]
                  ),
                )
              ),
            )
          ],
        ), 
      ),
    );
  }
}