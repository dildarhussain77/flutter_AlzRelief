import 'package:flutter/material.dart';


class CustomTextField extends StatelessWidget {

  final TextEditingController controller;
  final String text;
  final IconData iconData;
  final bool toHide;

  const CustomTextField({super.key, 
    required this.controller,
    required this.text,
    required this.iconData,
    required this.toHide, 
    //required IconData icon, required String hint, required Future<Null> Function() onTap, required bool readOnly,
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      child: TextField(
        controller: controller,
        obscureText: toHide,
        decoration: InputDecoration(
          hintText: text,
          suffixIcon: Icon(iconData),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final VoidCallback voidCallBack;
  final String text;
  final Color? color;
  final Color backgroundColor;
  final double height, width;

  const CustomButton({super.key, 
    required this.voidCallBack,
    required this.text,
    this.color, required this.backgroundColor, required this.height, required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: voidCallBack,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color, 
            fontSize: 20),
        ),
      ),
    );
  }
}







class UiHelper {

  

  // static CustomTextField(TextEditingController controller, String text, IconData iconData, bool toHide,){

  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
  //     child: TextField(

  //     controller: controller,
  //     obscureText: toHide,
  //     decoration: InputDecoration(
  //       hintText: text,
  //       suffixIcon: Icon(iconData),
            
        
  //       border: OutlineInputBorder(
          
  //         borderRadius: BorderRadius.circular(25)
          
  //       )
  //     ),
  //     ),
  //   );
  // }

  // static CustomButton(VoidCallback voidCallBack, String text, {Color? color}){
    

  //   return SizedBox(height: 50, width: 300,  child: ElevatedButton(onPressed: (){
      
  //     voidCallBack();
  //   },
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: color ?? Color.fromRGBO(95, 37, 133, 1.0),
  //       shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(25),
        
  //     ), 
     
  //     ),
  //     child: Text(text, style: TextStyle(color: Colors.white, fontSize: 20),)),);
  // }



  //   static CustomButton2(VoidCallback voidCallBack, String text, {Color? color}){
    

  //   return SizedBox(height: 35, width: 120,  child: ElevatedButton(onPressed: (){
      
  //     voidCallBack();
  //   },
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: color ?? Colors.white,
  //       shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(25),
        
  //     ), 
     
  //     ),
  //     child: Text(text, style: TextStyle(color: Color.fromRGBO(95, 37, 133, 1.0), fontSize: 18),)),);
  // }

}