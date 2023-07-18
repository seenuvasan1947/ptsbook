import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Getcurrentuser with ChangeNotifier, DiagnosticableTreeMixin {
  static String? user = "";
  static String? selectlang= "en-IN";
  static String? password = "";
  List<dynamic> arrayDataList = [];
  List<dynamic> contentlangList = [];
  List<dynamic>favbooklist=[];
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
Future<List<dynamic>> getcontentlanglist() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('metadata');

    DocumentSnapshot snapshot = await collection.doc('content_lang').get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    if (data != null && data.containsKey('lang_list')) {
      List<dynamic> langData = data['lang_list'];
      contentlangList = langData;
      return langData;
    } else {
      return [];
    }
    // notifyListeners();
  }

void getselectedcontentlang() async {
        final prefs = await SharedPreferences.getInstance();

    selectlang = prefs.getString('selectlang');
    

    notifyListeners();
  }



}


class LangPropHandler with ChangeNotifier, DiagnosticableTreeMixin {
  static var lang_index = 0;
  static String crnt_lang_code= 'ta';
  static var index;
  //  get userName => lang_index;
  // String? get userEmail => crnt_emai;

  void getlangindex( ) async {
    
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('crnt_lang_code','');
   var crnt_lang_code_temp = prefs.getString('crnt_lang_code')!;
   print('234567');
   print(crnt_lang_code_temp);
    if(crnt_lang_code_temp==''||crnt_lang_code_temp==null){
      crnt_lang_code="en";
    }
    else{
      crnt_lang_code=crnt_lang_code_temp;
    }


    
    // password = prefs.getString('password');

    notifyListeners();
  }
}





