// ignore_for_file: prefer_const_constructors


// import 'package:flight/saple.dart';


import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/auth.dart';
import '../../components/language/data/lang_data.dart';
import '../user_screens/user_home_screens/lang_select_page.dart';
import '../user_screens/user_home_screens/nav_bar_home_screen.dart';
import '../user_screens/user_home_screens/welcome_page_lang_select.dart';

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
    // lang_model_manage();
     login_nav_disider();
  
  }





lang_model_manage()async{
  
  final modelManager = OnDeviceTranslatorModelManager();

  for (var i=0;i<LangData.translanglist.length;i++){

final bool response = await modelManager.isModelDownloaded(LangData.translanglist[i].bcpCode);
print('~~~~~~~~~~');
print(response);
  if(response ==false){
//  final bool response = await modelManager.downloadModel(LangData.translanglist[i].bcpCode);

// print('~~~~~~~~~~');
// print(response);

  }


  }
  
 
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


 Future.delayed(Duration(seconds: 1)).then((value) {
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyApp()));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
      
      // ignore: unrelated_type_equality_checks


      user_login==true? NavBarAtHomePage():LoginPage()));
      // user_login==true? welcomepropPage():LoginPage()));


      // Navigator.popAndPushNamed(context, demo() as String);
    });
  
}

/*  Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  SettingsPage(is_welcome_page: false),
                              )); */
  
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