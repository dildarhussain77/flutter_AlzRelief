import 'package:alzrelief/screens/user1%20alzheimer/Activity_Manager/Game/game_board_screen.dart';
import 'package:alzrelief/screens/user1%20alzheimer/Activity_Manager/expenses%20manager/expense_home.dart';
import 'package:alzrelief/screens/user1%20alzheimer/Activity_Manager/Personal%20Diary/diary_screen.dart';
import 'package:alzrelief/screens/user1%20alzheimer/Activity_Manager/music_playlist/music_playlist_page.dart';
import 'package:alzrelief/util/homepagetile.dart';
import 'package:alzrelief/util/image_logo_helper.dart';
import 'package:alzrelief/util/tapnavigation.dart';
import 'package:flutter/material.dart';


class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {

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
                      imagePath: 'assets/images/mindexercise.png',
                      borderColor: null,
                    ),
                  ),
                ],
              ),
            ),                   
        
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(25),              
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  )
                ),
               // Text("Exercises", style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
                child: Center(
                  child: Column(  
                    children: [                             
                       Padding(
                         padding: EdgeInsets.only(
                          bottom: 10
                         ),
                         child: Text("Activities", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                       ),
                      // SizedBox(height: 10,),              
                      Expanded(
                        child: ListView(
                          
                          children: [                                                                               
                            TapNavigation(
                              destination: const GameBoard(),
                              child: HomePageTile(
                                height: 87,
                                width: 100,
                                icon: null,
                                iconColor: Colors.lightGreen,
                                iconAsset: 'assets/images/game.png',
                                homeTileName: "Game",
                                homeTileDes: "Play and challenge your mind",
                                color: Colors.lightGreen[200], 
                              ),
                              
                            ),                                                                          
                            TapNavigation(
                              destination: DiaryScreen(),
                              child: HomePageTile(
                                height: 87,
                                width: 100,
                                icon: null,
                                iconColor: Colors.red,
                                iconAsset: 'assets/images/diary.png',
                                homeTileName: "Personal Diary",
                                homeTileDes: "Organize your events",
                                color: Colors.lightBlue[200], 
                              ),
                            ),                                                                         
                            TapNavigation(
                              destination: MusicPlaylistPage(),
                              child: HomePageTile(
                                height: 87,
                                width: 100,
                                icon: null,
                                iconColor: Colors.red,
                                iconAsset: 'assets/images/music.png',
                                homeTileName: "Music PlayList",
                                homeTileDes: "Listen to your favorite songs",
                                color: Colors.red[200], 
                              ),
                            ),          
                            TapNavigation(
                              destination: ExpensesHome(),
                              child: HomePageTile(
                                height: 87,
                                width: 100,
                                icon: null,
                                iconColor: Colors.red,
                                iconAsset: 'assets/images/expense.png',
                                homeTileName: "Expenses Manager",
                                homeTileDes: "Manage your Finance",
                                color: Colors.orange[200], 
                              ),
                            ),
                                                                                                                                      
                          ],
                        ),
                      ),                                                     
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