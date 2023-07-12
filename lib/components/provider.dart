import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Getcurrentuser with ChangeNotifier, DiagnosticableTreeMixin {
  static String? user = "";
  static String? password = "";
  List<dynamic> arrayDataList = [];
  bool heisvalid=false;

  String? get userName => user;

  void getuser() async {
    final prefs = await SharedPreferences.getInstance();

    user = prefs.getString('name');
    password = prefs.getString('password');

    notifyListeners();
  }

  Future<List<dynamic>> getgenerlist() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('metadata');

    DocumentSnapshot snapshot = await collection.doc('genres').get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    if (data != null && data.containsKey('book_genres')) {
      List<dynamic> arrayData = data['book_genres'];
      arrayDataList = arrayData;
      return arrayData;
    } else {
      return [];
    }
    // notifyListeners();
  }




}

