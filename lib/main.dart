// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, curly_braces_in_flow_control_structures, unused_import, depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mybook/auth/auth.dart';
import 'package:mybook/components/provider.dart';
import 'package:mybook/screens/home_screen.dart';
import 'package:scroll_navigation/scroll_navigation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'components/language/multi_lang.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [

ChangeNotifierProvider(create: (_) => Getcurrentuser()),
ChangeNotifierProvider(create: (_) => LangPropHandler())

  ],
  // child: MaterialApp(home: LoginPage()),
  // child: MaterialApp(home: MyApp()),
  child: MaterialApp(home: LangMainPage()),
  ));
  // reloadApp();

    // context.read<Getcurrentuser>().getgenerlist();
    Getcurrentuser().getgenerlist();
}

 void reloadApp() {
    // Restart the Flutter app.
    // This will reload the app with the latest changes.
    SystemNavigator.pop();
    
  }
  