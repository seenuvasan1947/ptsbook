// ignore_for_file: prefer_const_constructors


// import 'package:flight/saple.dart';


import 'package:flutter/material.dart';
import 'package:mybook/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/auth.dart';
import '../nav_bar_home_screen.dart';

bool  user_login=false;
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
   login_nav_disider();
  }

void login_nav_disider() async{


final prefs = await SharedPreferences.getInstance();

var   temp_user_login = prefs.getBool('is_login');

if(temp_user_login==''||temp_user_login==null){
  user_login=false;
}
else{
  user_login=true;
}


 Future.delayed(Duration(seconds: 3)).then((value) {
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyApp()));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
      
      // ignore: unrelated_type_equality_checks
      user_login==true? NavBarAtHomePage():LoginPage()));
      // Navigator.popAndPushNamed(context, demo() as String);
    });
  
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SizedBox(
        // width: double.maxFinite,
        // height: double.maxFinite,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
           

          
            Image(
              image: AssetImage('assets/splashscreen.png'),
              fit: BoxFit.cover,
            )
          ],
        ),
      ),
    );
  }
}