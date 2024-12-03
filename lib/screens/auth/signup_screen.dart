
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables


import 'package:alzrelief/screens/auth/otp_screen1.dart';
import 'package:alzrelief/util/image_logo_helper.dart';
import 'package:alzrelief/util/uihelper.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
        resizeToAvoidBottomInset: false,
      
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
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
                          imagePath: 'assets/images/signup.png',
                          borderColor: null,
                        ),
                      ),
                    ],
                  ),
                ),                                  
                                                           
                Expanded(
                  child: Container(
            
                    padding: const EdgeInsets.only(
                      top: 10,
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
                    
            
                    child: Column(  
                      children: [
                        const Text("Sign Up",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                        const SizedBox(height: 10,),
                                
                        CustomTextField(controller: nameController, text: "Full name", iconData: Icons.person,toHide: false,),
                        CustomTextField(controller: emailController,text:  "Your email address",iconData:  Icons.mail,toHide:  false, ),
                        CustomTextField(controller:  passwordController,text:  "Password",iconData:  Icons.password,toHide:  true, ),
                        CustomTextField(controller:  confirmPasswordController,text:  "Confirm password",iconData:  Icons.password,toHide:  true,),
                        SizedBox(height: 15,),

                        CustomButton(
                        voidCallBack: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => OTPEmailPage()),
                            );                            
                        },
                        text: 'Sign Up', 
                        backgroundColor:  Color.fromRGBO(95, 37, 133, 1.0), 
                        color: Colors.white,
                        height: 50,
                        width: 300,
                      ), 

                        // UiHelper.CustomButton(() {
                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => OTPEmailPage()));          
                        // }, "Sign Up"), 

                      ]
                    )
                  ),
                )
              ],
            ),
          ),
        ),
        
      
      
      
      ),
    );
  }
}