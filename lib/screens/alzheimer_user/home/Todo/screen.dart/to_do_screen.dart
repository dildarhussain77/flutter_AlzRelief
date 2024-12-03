import 'package:flutter/material.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("To Do List",style: TextStyle(color: Colors.white),),
          backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
        ),

        body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(

            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.grey,
              height: 1,
              thickness: 1,
            );
          },
          itemCount: 5
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
          onPressed: () {
            showDialog(
              context: context, 
              builder: (context){
                double sh = MediaQuery.sizeOf(context).height;
                double sw = MediaQuery.sizeOf(context).width;

                return Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: SizedBox(
                    height: sh * 0.5, 
                    width: sw * 0.8,

                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: sh * 0.02 ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text("Create New Task", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                          ),

                          SizedBox(height: 15,),

                          Text("What has to be done?", style: TextStyle(color: Colors.black),),
                          CustomTextField(hint: "Enter Task",),
                          SizedBox(height: 40,),
                          Text("Due Date", style: TextStyle(color: Colors.black),),

                          CustomTextField(
                            hint: "Pick a Date",
                            readOnly: true,
                            icon: Icons.calendar_today,
                            onTap: () {},
                          ),
                          SizedBox(height: 10,),
                          CustomTextField(
                            hint: "Pick a Time",
                            readOnly: true,
                            icon: Icons.timer,
                            onTap: () {},
                          ),
                          SizedBox(height: 30,),

                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton( 
                              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),),                                                      
                              onPressed: (){ }, 
                              child: Text("Create",style: TextStyle(color: Colors.white),),
                            ),
                          )

                        ],
                      ),
                    ),

                  ),
                );

              }
            );

          },
          child: Icon(
            Icons.add,
            size: 35,
            color: Colors.white,
          ),
        ),
      )    
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key, required this.hint, this.icon, this.onTap, this.readOnly = false
  });
  final String hint;
  final IconData? icon;
  final void Function()? onTap;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: TextField(
        readOnly: readOnly,
      
        decoration: InputDecoration(
          suffixIcon: InkWell( 
            onTap: onTap,
            child: Icon(icon)
          ),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey,fontSize: 14)
        ),
      ),
    );
  }
}