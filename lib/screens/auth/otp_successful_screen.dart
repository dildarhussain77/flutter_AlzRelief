// import 'package:alzrelief/screens/auth/login_screen.dart';
// import 'package:alzrelief/util/image_logo_helper.dart';
// import 'package:alzrelief/util/uihelper.dart';
// import 'package:flutter/material.dart';

// class OTPSuccessfulPage extends StatefulWidget {
//   const OTPSuccessfulPage({super.key});

//   @override
//   State<OTPSuccessfulPage> createState() => _OTPSuccessfulPageState();
// }

// class _OTPSuccessfulPageState extends State<OTPSuccessfulPage> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(

//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [

//             Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
                  
                  
//                   children: [
//                     LogoImage(
//                       imagePath: 'assets/images/otpdone.png',
//                       borderColor: null,
//                     ),
//                   ],
//                 ),

//                 const Text("Verification Success!",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
//                 SizedBox(height: 10,),
//                 const Text("Congrats and welcome to AlzRelief.",style: TextStyle(fontSize: 16,),),
//                 SizedBox(height: 25,),

//                 CustomButton(
//                         voidCallBack: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => LoginPage()),);                            
//                         },
//                         text: 'Done', 
//                         backgroundColor:  Color.fromRGBO(95, 37, 133, 1.0), 
//                         color: Colors.white,
//                         height: 50,
//                         width: 300,
//                       ), 

//                 // UiHelper.CustomButton(() {
//                 //           Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));            
//                 //         }, "Done"),  



//           ],
//         ),

//       )
//     );
//   }
// }