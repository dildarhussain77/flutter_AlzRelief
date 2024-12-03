// 
// ignore_for_file: unnecessary_const


// import 'package:alzrelief/screens/home/home_screen.dart';
// import 'package:alzrelief/screens/home/home_screen.dart';
import 'package:alzrelief/util/image_logo_helper.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      
        backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
      
       
      
        body: Column(
          children: [

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
                      imagePath: 'assets/images/mypic.jpg',
                      borderColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
                    
            const SizedBox(height: 10,),        
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
                child: Center(
                  child: Column( 
                     
                    children: [

                                                                                 
                    ],
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