// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, curly_braces_in_flow_control_structures, unused_import, depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mybook/auth/auth.dart';
import 'package:mybook/components/provider.dart';
import 'package:mybook/screens/user_screens/user_home_screens/home_screen.dart';



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'components/language/multi_lang.dart';
import 'screens/admin_screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [

ChangeNotifierProvider(create: (_) => Getcurrentuser()),
ChangeNotifierProvider(create: (_) => LangPropHandler())

  ],
  // child: MaterialApp(home: LoginPage()),
  // child: MaterialApp(home: SplashScreen()),
  child: MaterialApp(home: LangMainPage()),
  ));
  // reloadApp();

    // context.read<Getcurrentuser>().getgenerlist();
    Getcurrentuser().getgenerlist();
}


  