// // ignore_for_file: unnecessary_const, prefer_const_constructors, prefer_const_constructors_in_immutables, unnecessary_import, prefer_const_literals_to_create_immutables



// import 'package:alzrelief/screens/auth/otp_screen2.dart';
// import 'package:alzrelief/util/uihelper.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:alzrelief/util/image_logo_helper.dart';
// import 'package:flutter/widgets.dart';

// class   OTPEmailPage extends StatefulWidget {
//   OTPEmailPage({super.key});

//   @override
//   State<OTPEmailPage> createState() => _OTPEmailPageState();
// }

// class _OTPEmailPageState extends State<OTPEmailPage> {

//   TextEditingController emailController = TextEditingController();
  
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(

//         backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
//         resizeToAvoidBottomInset: false,

//         body: SingleChildScrollView(
//           child: SizedBox(
//             height: MediaQuery.of(context).size.height,
//             child: Column(
//               children: [
                      
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
//                   child: Stack(                 
//                     children: [
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: IconButton(
//                             icon: Icon(Icons.arrow_back, color: Colors.white),
//                             onPressed: (){
//                               Navigator.pop(context);
//                             },
//                           ),
//                       ),
                                    
//                       Center(
//                         child: LogoImage(
//                           imagePath: 'assets/images/emailverificationotp.png',
//                           borderColor: null,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 Expanded(
//                   child: Container(
//                      padding: const EdgeInsets.only(
//                       top: 15,
//                       left: 5,
//                       right: 5,
//                     ),              
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(30.0),
//                         topRight: Radius.circular(30.0),
//                       )
//                     ),

//                     child: Column(
//                       children: [
//                         const Text("Email Verification",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
//                         const Text("We need your email to verify account",style: TextStyle(fontSize: 16,),),
//                         SizedBox(height: 15,),
//                         CustomTextField(controller:  emailController,text:  "Email",iconData:  Icons.mail,toHide:  false,),
//                         SizedBox(height: 20,),

//                         CustomButton(
//                         voidCallBack: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => OTPVerifyPage()),);                            
//                         },
//                         text: 'Get Code', 
//                         backgroundColor:  Color.fromRGBO(95, 37, 133, 1.0), 
//                         color: Colors.white,
//                         height: 50,
//                         width: 300,
//                       ), 

//                         // UiHelper.CustomButton(() {
//                         //   Navigator.push(context, MaterialPageRoute(builder: (context) => OTPVerifyPage()));            
//                         // }, "Get Code"),

//                         SizedBox(height: 10,),

//                       ],
//                     ),
//                   )
//                 )                                                                                                
//               ],
//             ),
//           ),
//         ),

//       )
//     );
//   }
// }