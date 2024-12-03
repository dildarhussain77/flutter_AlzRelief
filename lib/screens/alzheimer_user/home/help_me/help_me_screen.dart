// 
// ignore_for_file: unnecessary_const


// import 'package:alzrelief/screens/home/home_screen.dart';
// import 'package:alzrelief/screens/home/home_screen.dart';
import 'package:alzrelief/util/image_logo_helper.dart';
import 'package:alzrelief/util/uihelper.dart';
import 'package:flutter/material.dart';

class HelpMePage extends StatefulWidget {
  const HelpMePage({super.key});

  @override
  State<HelpMePage> createState() => _HelpMePageState();
}

class _HelpMePageState extends State<HelpMePage> {

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

                      const Text("Hello my name is",style: TextStyle(fontSize: 20,),),
                      SizedBox(height: 5,),
                      const Text("Dildar Hussain Bhutto",style: TextStyle(
                        fontSize: 22,fontWeight: FontWeight.bold, color: const Color.fromRGBO(95, 37, 133, 1.0),),),
                      SizedBox(height: 5,),
                      const Text("and I am lost, Please Help me.",style: TextStyle(fontSize: 20,),),

                      SizedBox(height: 20,),

                      Divider(
                        color: Colors.black,
                        thickness: 1,
                        height: 1,
                        
                      ),

                      SizedBox(height: 5,),                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.call),
                          const Text("Call my family at:",style: TextStyle(fontSize: 20,),),
                        ],
                      ),
                      TextButton(onPressed: () { 
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));            
                        }, 
                            child: Text(
                             "03153427213",  
                             style: TextStyle(
                               fontSize: 22, 
                               color: Color.fromRGBO(95, 37, 133, 1.0), 
                               fontWeight: FontWeight.w700),),
                        ), 

                      SizedBox(height: 20,),

                      Divider(
                        color: Colors.black,
                        thickness: 1,
                        height: 1,
                        
                      ),

                      SizedBox(height: 5,),
                      const Text("And i live here:",style: TextStyle(fontSize: 20,),),                      
                      Padding(
                        padding: EdgeInsets.only(top: 5.0, left: 8, right: 8, bottom: 5,),
                        child: const Text("4 Khayaban-e-Johar, H 9/4 H-9, Islamabad, Islamabad Capital Territory 44000",
                        style: TextStyle(fontSize: 20,color: Color.fromRGBO(95, 37, 133, 1.0),),),
                      ),

                      SizedBox(height: 5,),

                       CustomButton(
                        voidCallBack: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => HomePage()),);                            
                        },
                        text: 'open map', 
                        backgroundColor:  Color.fromRGBO(95, 37, 133, 1.0), 
                        color: Colors.white,
                        height: 50,
                        width: 150,
                      )                                                              
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