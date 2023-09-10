// ignore_for_file: use_build_context_synchronously, unnecessary_brace_in_string_interps

// import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:mybook/components/provider.dart';
import 'package:mybook/screens/user_screens/user_home_screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mybook/screens/user_screens/user_home_screens/lang_select_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';

import '../screens/user_screens/user_home_screens/nav_bar_home_screen.dart';
import '../screens/user_screens/user_home_screens/welcome_page_lang_select.dart';

bool validuser = false;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  final newuser = null;
 var dateNo=0;
 bool ispur=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
          title: "Ptsbook",
          onSignup: (data) async {
            
            try {
              final newuser = await _auth.createUserWithEmailAndPassword(
                  email: data.name!.toLowerCase().toString(),
                  password: data.password.toString());
                  DocumentSnapshot us =
          await FirebaseFirestore.instance.collection('metadata').doc('subscription_days').get();

      if (us.exists) {
        // setState(() {
        //   dataNo = us['subscription_silver'] as int;

        // });
        dateNo = us['new_user'] as int;

        print(dateNo);
      }

              FirebaseFirestore.instance
                  .collection("users")
                  .doc(data.name!.toLowerCase())
                  .set({
                'email': data.name!.toLowerCase(),
                'password': data.password,
                'name':data.additionalSignupData!["uname"],
                'country':data.additionalSignupData!["ucountry"],
                'phone':data.additionalSignupData!["uphonenumber"],
                'no_of_days':dateNo,
                'purchaseDate':DateTime.now(),
                'purchased':dateNo==0 ? false:true,
                'validDate':DateTime.now().add(Duration(days: dateNo)),


              });
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('name', data.name!.toLowerCase().toString());
              await prefs.setString('password', data.name.toString());
              await prefs.setBool('is_login', true);

              if (newuser != null) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => welcomepropPage()));
              }
            } catch (e) {
              print(e);
            }
          },

          onLogin: (data) async {
            final prefs = await SharedPreferences.getInstance();
            var errorMessage;
            try {
              UserCredential userCredential = await _auth
                  .signInWithEmailAndPassword(
                      email: data.name.toLowerCase().toString(),
                      password: data.password.toString());
           User? user = userCredential.user;       
              FirebaseFirestore.instance
                  .collection("users_login")
                  .doc(data.name.toLowerCase())
                  .set({
                'email': data.name.toLowerCase(),
                'password': data.password,
              });
              if (userCredential != null) {
                
                
                    await prefs.setString('name', data.name.toLowerCase().toString());
                     await prefs.setBool('is_login', true);
                     
                // await prefs.setString('password', data.name.toString());
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) =>  welcomepropPage()));
              }
              else{
                 await prefs.setString('name', 'guest@gmail.com');
                  await prefs.setBool('is_login', false);
                ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'You are login as guest'),
                ),
              );
              }
            } catch (e) {
               if (e is FirebaseAuthException && e.code == 'user-not-found') {
                await prefs.setString('name', 'guest@gmail.com');
                 await prefs.setBool('is_login',false);
                ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'You are login as guest'),
                ),
              );
      // setState(() {
      //   errorMessage = 'User not found. Please check your email.';
        
      // });
    }
    else {
      setState(() {
        errorMessage = 'Invalid email or password.';
      });
    }
              print(errorMessage);
            }
          },
          onRecoverPassword: (data) async {
            try {
              await FirebaseAuth.instance.sendPasswordResetEmail(email: data.toLowerCase());
              // Password reset email sent successfully
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Password reset email sent. Please check your inbox.'),
                ),
              );
            } catch (error) {
              // Error occurred while sending password reset email
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Failed to send password reset email. Please try again.'),
                ),
              );
            }
          },

          onSubmitAnimationCompleted: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => welcomepropPage()),
              ),
              
              additionalSignupFields: [const UserFormField(keyName: "uname",displayName: "Name",userType: LoginUserType.email)
              ,const UserFormField(keyName: "ucountry",displayName: "Country",),
              const UserFormField(keyName: "uphonenumber",displayName: "Phone Number",)

              ],
              
              ),
    );
  }
}

/* 

  void resetPassword(BuildContext context, LoginData data) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: data.name);
      // Password reset email sent successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset email sent. Please check your inbox.'),
        ),
      );
    } catch (error) {
      // Error occurred while sending password reset email
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send password reset email. Please try again.'),
        ),
      );
    }
  }

 */