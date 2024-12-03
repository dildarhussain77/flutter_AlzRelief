
import 'package:flutter/material.dart';

class ConsultantPage extends StatefulWidget {
  const ConsultantPage({super.key});

  @override
  State<ConsultantPage> createState() => _ConsultantPageState();
}

class _ConsultantPageState extends State<ConsultantPage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      
        backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
        resizeToAvoidBottomInset: false,              
      
        body: Column(
          children: [
        
            //greeting row
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
                        "Psychologists",                         
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
        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(12),
                ),

                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                        
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.white), // Text color
                        decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(color: Colors.white), // Hint text color
                        border: InputBorder.none, // Remove border
                        ),
                      ),
                    ),
                
                  ],
                ),
              ),
            ),
        
        
            const SizedBox(height: 15,),
        
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