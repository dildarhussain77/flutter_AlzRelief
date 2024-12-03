
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:alzrelief/util/image_logo_helper.dart';
import 'package:flutter/material.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      
        backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
        // resizeToAvoidBottomInset: true,              
      
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
                    child: LogoImage(
                      imagePath: 'assets/images/appointment.png',
                      borderColor: null,
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