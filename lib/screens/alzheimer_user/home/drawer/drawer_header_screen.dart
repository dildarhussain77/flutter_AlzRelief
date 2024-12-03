// ignore_for_file: unnecessary_const, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class DrawerHeaderPage extends StatefulWidget {
  const DrawerHeaderPage({super.key});

  @override
  State<DrawerHeaderPage> createState() => _DrawerHeaderPageState();
}

class _DrawerHeaderPageState extends State<DrawerHeaderPage> {
  
  
  @override
  Widget build(BuildContext context) {

    return Container(
      color: Color.fromRGBO(95, 37, 133, 1.0),
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle, 
              border: Border.all(
                color: Colors.white
              ),             
              image: DecorationImage(
                image: AssetImage('assets/images/mypic.jpg'),                
              ),
            ),
          ),
          Text('Dildar Hussain Bhutto', style: TextStyle(color: Colors.white, fontSize: 20,),),
          Text('dildarali99999@gmail.com', style: TextStyle(color: Colors.grey[200] ,fontSize: 14),),
        ],
      ),      
    );
  }  
}
