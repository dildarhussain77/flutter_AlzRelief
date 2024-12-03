// ignore_for_file: prefer_const_constructors, sort_child_properties_last



import 'package:alzrelief/screens/alzheimer_user/home/drawer/drawer_header_screen.dart';
import 'package:alzrelief/screens/alzheimer_user/home/drawer/drawer_list.dart';
import 'package:alzrelief/screens/psychologist_user/Appointments/psy_appointments_screen.dart';

import 'package:alzrelief/util/appointmentcard.dart';
// import 'package:alzrelief/screens/notification_screen.dart';


import 'package:alzrelief/util/homepagetile.dart';
import 'package:alzrelief/util/tapnavigation.dart';

import 'package:flutter/material.dart';


class PsyHomePage extends StatefulWidget {
  const PsyHomePage({super.key});

  @override
  State<PsyHomePage> createState() => _PsyHomePageState();
}

class _PsyHomePageState extends State<PsyHomePage> {

   int currentIndex = 0;
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });

    // Handle navigation based on the selected index
    switch (currentIndex) {
      case 0:
        // Navigator.push(
        //   context, MaterialPageRoute(builder: (context) => HomePage()));
        break;
      case 1:
        // Navigate to the chats screen
        // Navigator.push(
        //   context, MaterialPageRoute(builder: (context) => ChatPage()));
        break;
      case 2:
        // Navigate to the consultants screen
        // Navigator.push(
        //   context, MaterialPageRoute(builder: (context) => ConsultantPage()));
        break;
      case 3:
        //Navigator.push(
        //   context, MaterialPageRoute(builder: (context) => NotificationPage()));
        // // _scaffoldKey.currentState?.openEndDrawer();
        break;
        
    }
  }

  @override
  Widget build(BuildContext context) {
    
    
    return SafeArea(
      child: Scaffold(
         key: _scaffoldKey,
          endDrawer: Drawer(
            backgroundColor: Colors.grey[200],
            child: SingleChildScrollView(
              child: Container(                
                child: Column(
                  children: [
                    DrawerHeaderPage(),
                    MyDrawerList(),
                    // Add other drawer items here
                  ],
                ),
              ),
            ),
          ),
      
        backgroundColor: Color.fromRGBO(95, 37, 133, 1.0),
      
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onItemTapped,
          selectedItemColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(fontSize: 12, color: Colors.black),
                        
          
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.black), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.message, color: Colors.black), label: "Chats"),
            BottomNavigationBarItem(
                icon: Icon(Icons.people, color: Colors.black),
                label: "Patients"),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_active, color: Colors.black), label: "Alerts"),
          ],                 
        ),      
        body: Column(
          
          children: [
        
            Padding(
             padding: const EdgeInsets.symmetric(horizontal: 25.0),
             child: Column(
              
              children: [
                 //greeting row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,                  
                  children: [                    
                    Column(                      
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(height: 10,),
                        Text(
                          "Welcome,", 
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 24, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      
                        Text(
                          "Ms. Kainat Malik", 
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 15, 
                            
                          ),
                        ),
                      ],
                    ),
                
                    GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState?.openEndDrawer();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.purple[600],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                      ),
                    ),           
                  ],      
                ),
                     
              SizedBox(height: 25,),                     
              ],
             ),
            ),
        
           Expanded(
             child: Container(
              padding: EdgeInsets.all(25),              
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                )
              ),
              
              
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 10,),
              
                    //listview 
                    Expanded(
                      child: ListView(
                        children: [
                         
                          TapNavigation(
                            child: HomePageTile(
                              height: 90,
                              width: 100,
                              iconAsset: 'assets/images/appointment.png',
                              icon: null,
                              iconColor: Colors.red,
                              homeTileName: "Appointments",
                              homeTileDes: "View Patient Appointments",
                              color: Colors.orange[200],  
                            ),
                            destination: PsyAppointment(),
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 1,
                            height: 1,
                        
                          ),
                          SizedBox(height: 10,),

                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Upcoming Appointments", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                              ),
                            ],
                          ),

                          AppointmentCard(
                            patientName: "Dildar Huusain Bhutto",
                            diseaseName: "Hypertension",
                            appointmentTime: "10:00 AM",
                            patientImage: 'assets/images/mypic.jpg',
                          ),
                          AppointmentCard(
                            patientName: "Aleena Javed",
                            diseaseName: "Hypertension",
                            appointmentTime: "11:30 AM",
                            patientImage: 'assets/images/mypic.jpg',
                          ),
                          // AppointmentCard(
                          //   patientName: "Muhammad Wajid",
                          //   diseaseName: "Asthma",
                          //   appointmentTime: "1:00 PM",
                          //   patientImage: 'assets/mypic.jpg',
                          // ),

                          TextButton(onPressed: () { 
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));            
                        }, 
                            child: Text(
                             "See more",  
                             style: TextStyle(
                               fontSize: 20, 
                               color: Colors.black, 
                               fontWeight: FontWeight.w700),),
                        ),


                        ],
                      ),
                    )
              
                  ],
                ),
              ),
             ),
           )
        
          ],
        ),
      ),
    );
  }
}
