
import 'package:alzrelief/screens/user1%20alzheimer/Activity_Manager/expenses%20manager/expenses_data.dart';
// import 'package:alzrelief/screens/sign%20in%20with%20google/sign_in_with_google_Role.dart';
import 'package:alzrelief/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   //WidgetsFlutterBinding.ensureInitialized();
  //await initNotification();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {    
      return ChangeNotifierProvider(
      create: (context) => ExpenseData(),
      child: MaterialApp(      
        theme: ThemeData(        
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashPage(),
      ),
    );
    
  }
}
