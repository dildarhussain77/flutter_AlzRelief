// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'package:alzrelief/screens/auth/otp_successful_screen.dart';
// import 'package:alzrelief/util/image_logo_helper.dart';
// import 'package:alzrelief/util/uihelper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class OTPVerifyPage extends StatefulWidget {
//   const OTPVerifyPage({super.key});

//   @override
//   State<OTPVerifyPage> createState() => _OTPVerifyPageState();
// }

// class _OTPVerifyPageState extends State<OTPVerifyPage> {

//   final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
//   final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());

//   @override
//   void dispose() {
//     for (final controller in _controllers) {
//       controller.dispose();
//     }
//     for (final focusNode in _focusNodes) {
//       focusNode.dispose();
//     }
//     super.dispose();
//   }

//   void _handleTextChanged(int index, String value) {
//     if (value.isNotEmpty && index < _focusNodes.length - 1) {
//       _focusNodes[index + 1].requestFocus();
//     } else if (value.isEmpty && index > 0) {
//       _focusNodes[index - 1].requestFocus();
//     }
//   }

  
  
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
//                           imagePath: 'assets/images/otpcodeverification.png',
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
//                         const Text("OTP Verification",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
//                         const Text("We have sent the code verification to email",style: TextStyle(fontSize: 16,),),
//                         SizedBox(height: 15,),
                        
//                         Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               for (int index = 0; index < 4; index++)                              
//                               SizedBox(
//                                 height: 68,
//                                 width: 64,
//                                 child: TextField(
//                                   focusNode: _focusNodes[index],
//                                   controller: _controllers[index],
//                                   style: Theme.of(context).textTheme.headlineSmall,
//                                   keyboardType: TextInputType.number,
//                                   textAlign: TextAlign.center,
//                                   inputFormatters: [
//                                     LengthLimitingTextInputFormatter(1),
//                                     FilteringTextInputFormatter.digitsOnly
//                                   ],
                                  
//                                   onChanged: (value) => _handleTextChanged(index, value),   
                                                          
//                                 ),
//                               ),                                                        
//                             ],
//                           ),
//                         ),
                                                                   
//                         SizedBox(height: 20,),

//                         // UiHelper.CustomButton(() {                          
//                         //   Navigator.push(context, MaterialPageRoute(builder: (context) => OTPSuccessfulPage()));            
//                         // }, "Verify"),

//                         CustomButton(
//                         voidCallBack: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => OTPSuccessfulPage()),);                            
//                         },
//                         text: 'Verify', 
//                         backgroundColor:  Color.fromRGBO(95, 37, 133, 1.0), 
//                         color: Colors.white,
//                         height: 50,
//                         width: 300,
//                       ), 

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