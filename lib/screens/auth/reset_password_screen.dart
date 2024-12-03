// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:alzrelief/screens/auth/login_screen.dart';
import 'package:alzrelief/screens/auth/signup_screen.dart';
import 'package:alzrelief/util/image_logo_helper.dart';
import 'package:alzrelief/util/uihelper.dart';
import 'package:flutter/material.dart';


class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {

  TextEditingController resetCodeController = TextEditingController();
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
                          imagePath: 'assets/images/resetpassword.png',
                          borderColor: null,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                     padding: const EdgeInsets.only(
                      top: 15,
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
                        const Text("Reset Password",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                        SizedBox(height: 15,),
                        CustomTextField(controller:  resetCodeController,text:  "Reset Code",iconData:  Icons.lock_reset_outlined,toHide:  false,),
                        CustomTextField(controller:  passwordController,text:  "New Password",iconData:  Icons.password,toHide:  true,),
                        CustomTextField(controller:  confirmPasswordController,text:  "Confirm password",iconData:  Icons.password,toHide:  true,),
                        SizedBox(height: 20,),

                        CustomButton(
                        voidCallBack: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),);                            
                        },
                        text: 'Done', 
                        backgroundColor:  Color.fromRGBO(95, 37, 133, 1.0), 
                        color: Colors.white,
                        height: 50,
                        width: 300,
                      ), 

                        // UiHelper.CustomButton(() {
                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));            
                        // }, "Done"),

                        SizedBox(height: 10,),

                        Row(     
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Create new account?", style: TextStyle(fontSize: 16, color: Colors.black),),                            
                            TextButton(onPressed: () { 
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage()));            
                            }, 
                            child: const Text("Sign up", style: TextStyle(fontSize: 19, color: Color.fromRGBO(95, 37, 133, 1.0), fontWeight: FontWeight.w700),),
                            ),
                          ],                   
                        ),


                      ],
                    ),
                  )
                )                                                                                                
              ],
            ),
          ),
        ),



      ),
    );
  }
}