// ignore_for_file: use_build_context_synchronously, unnecessary_brace_in_string_interps

// import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:mybook/components/provider.dart';
import 'package:mybook/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';

bool validuser = false;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  final newuser = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
          title: "Mybook",
          onSignup: (data) async {
            try {
              final newuser = await _auth.createUserWithEmailAndPassword(
                  email: data.name.toString(),
                  password: data.password.toString());
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(data.name)
                  .set({
                'email': data.name,
                'password': data.password,
                'name':data.additionalSignupData!["uname"],
                'country':data.additionalSignupData!["ucountry"],
                'phone':data.additionalSignupData!["uphonenumber"],
              });
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('name', data.name.toString());
              await prefs.setString('password', data.name.toString());

              if (newuser != null) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MyApp()));
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
                      email: data.name.toString(),
                      password: data.password.toString());
           User? user = userCredential.user;       
              FirebaseFirestore.instance
                  .collection("users_login")
                  .doc(data.name)
                  .set({
                'email': data.name,
                'password': data.password,
              });
              if (userCredential != null) {
                
                
                    await prefs.setString('name', data.name.toString());
                     
                // await prefs.setString('password', data.name.toString());
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MyApp()));
              }
            } catch (e) {
               if (e is FirebaseAuthException && e.code == 'user-not-found') {
                await prefs.setString('name', 'guest');
                ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
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
              await FirebaseAuth.instance.sendPasswordResetEmail(email: data);
              // Password reset email sent successfully
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Password reset email sent. Please check your inbox.'),
                ),
              );
            } catch (error) {
              // Error occurred while sending password reset email
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Failed to send password reset email. Please try again.'),
                ),
              );
            }
          },

          onSubmitAnimationCompleted: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => MyApp()),
              ),
              
              additionalSignupFields: [UserFormField(keyName: "uname",displayName: "Name",userType: LoginUserType.email)
              ,UserFormField(keyName: "ucountry",displayName: "Country",),
              UserFormField(keyName: "uphonenumber",displayName: "Phone Number",)

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