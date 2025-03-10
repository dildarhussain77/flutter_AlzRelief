import 'package:alzrelief/screens/user1%20alzheimer/drawer/profile/alzheimer_profile.dart';
import 'package:alzrelief/screens/sign%20in%20with%20google/sign_in_with_google_Role.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AlzheimerMyDrawerList extends StatefulWidget {
  const AlzheimerMyDrawerList({super.key});

  @override
  State<AlzheimerMyDrawerList> createState() => _AlzheimerMyDrawerListState();
}

class _AlzheimerMyDrawerListState extends State<AlzheimerMyDrawerList> {

  var currentPage = DrawerSections.profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          menuItem(1, 'Profile', Icons.person, Color.fromRGBO(95, 37, 133, 1.0),               
          currentPage == DrawerSections.profile ? true : false),
          // menuItem(2, 'Settings', Icons.settings, Colors.black,
          // currentPage == DrawerSections.settings ? true : false),
          menuItem(3, 'Logout', Icons.logout_rounded, Colors.red,
          currentPage == DrawerSections.logout ? true : false),
        
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon,Color iconColor, bool selected){

    return Material(
      color: selected? Colors.grey[200] : Colors.grey[200],
      child: InkWell(
        onTap: (){
          Navigator.pop(context);
          setState((){
            if(id == 1){
              currentPage = DrawerSections.profile;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AlzheimerProfilePage()), // Replace `LoginPage` with your login page widget
              );
                           
            }
            // else if(id==2){
            //   currentPage = DrawerSections.settings;
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => SettingPage()), // Replace `LoginPage` with your login page widget
            //   );
            // }
            else if(id==3){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Logout?"),
                    content: Text("Are you sure you want to logout?"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          // Close the dialog
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'), 
                      ),
                      TextButton(
                        onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInWithGoogleRolePage()),
                              (route) => false,
                            );
                        },
                        
                       
                        child: Text('Logout'),
                      ),
                    ],
                  );
                },
              );
            }
            
          });
        },
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: iconColor,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSections{
  profile,
  logout,
}