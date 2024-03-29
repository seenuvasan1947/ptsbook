// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mybook/components/language/data/lang_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Getcurrentuser with ChangeNotifier, DiagnosticableTreeMixin {
  static String? user = "";
  static String? selectlang= "en-IN";
  String? non_static_selectlang= "en-IN";
  static String? password = "";
  List<dynamic> GenerList = [];
  List<dynamic> contentlangList = [];
  List<dynamic>favbooklist=[];
  List<dynamic> lang_list=[];
  List<dynamic> lang_name_list=[];
  List<dynamic> lang_voice_list=[];
  List<dynamic> admin_list=[];
  var home_img='';
  bool heisvalid=false;

  String? get userName => user;

  void getuser() async {
    final prefs = await SharedPreferences.getInstance();
// prefs.setString('name', 'guest@gmail.com');
// prefs.setString('name', 'seenuthiruvpm@gmail.com');
   user = prefs.getString('name');
   password = prefs.getString('password');


// if(temp_user==''||temp_user==null){
//   user=='guest@gmail.com';
//   password='0000';

// }
// else{
//   user=temp_user;
//   password=temp_password;
// }



    notifyListeners();
  }

  Future<List<dynamic>> getgenerlist() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('metadata');

    DocumentSnapshot snapshot = await collection.doc('genres').get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    if (data != null && data.containsKey('book_genres')) {
      List<dynamic> arrayData = data['book_genres'];
      GenerList = arrayData;
      return arrayData;
    } else {
      return [];
    }
    // notifyListeners();
  }
void getcontentlanglist() async {

lang_name_list=LangData.LangName;
lang_list=LangData.appLang;
contentlangList=LangData.ContentLang;
lang_voice_list=LangData.VoiceList;

    // CollectionReference collection =
    //     FirebaseFirestore.instance.collection('metadata');

    // DocumentSnapshot snapshot = await collection.doc('content_lang').get();
    // Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    // if (data != null && data.containsKey('lang_list')&&data.containsKey('app_lang')&&data.containsKey('Lang_name')) {
    //   List<dynamic> langData = data['lang_list'];
    //   List<dynamic> applan=data['app_lang'];
    //   /* varible data given */
    //    lang_name_list=data['Lang_name'];
    //   contentlangList = langData;
    //   lang_list=applan;
    //   return langData;
    // } else {
    //   return [];
    // }
    // notifyListeners();
  }


  Future<List<dynamic>> getadminlist() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('metadata');

    DocumentSnapshot snapshot = await collection.doc('accessible_user').get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    if (data != null && data.containsKey('admin')) {
       admin_list = data['admin'];
      
      return admin_list;
    } else {
      return [];
    }
    // notifyListeners();
  }
  

void getselectedcontentlang() async {
        final prefs = await SharedPreferences.getInstance();

   var  temp_selectlang = prefs.getString('selectlang');
    if(temp_selectlang==''||temp_selectlang==null){
      selectlang="en-IN";
      non_static_selectlang="en-IN";
    }
    else{
      selectlang=temp_selectlang;
      non_static_selectlang=temp_selectlang;
    }


    

    notifyListeners();
  }

  Future<dynamic> gethomepageimg() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('metadata');

    DocumentSnapshot snapshot = await collection.doc('home_page_img').get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    if (data != null && data.containsKey('home_img_url')) {
       home_img = data['home_img_url'];
       print('12343212312');
      print(home_img);
      return home_img;
    } else {
      return [];
    }
    // notifyListeners();
  }


}


class LangPropHandler with ChangeNotifier, DiagnosticableTreeMixin {
  static var lang_index = 0;
  static String crnt_lang_code= 'ta';
  String non_static_crnt_lang_code='ta';
  static var index;
   static String? selectlang= "en-IN";
  //  get userName => lang_index;
  // String? get userEmail => crnt_emai;

  void getlangindex() async {
    
    final prefs = await SharedPreferences.getInstance();
    // prefs.setString('crnt_lang_code','ta');
   var crnt_lang_code_temp = prefs.getString('crnt_lang_code');
   print('234567');
   print(crnt_lang_code_temp);
    if(crnt_lang_code_temp==''||crnt_lang_code_temp==null){
      crnt_lang_code="ta";
      non_static_crnt_lang_code='ta';
      prefs.setString('crnt_lang_code', "ta");
    }
    else{
      crnt_lang_code=crnt_lang_code_temp;
      non_static_crnt_lang_code=crnt_lang_code_temp;
    }


    
    // password = prefs.getString('password');

    notifyListeners();
  }
  void getprop_selectedcontentlang() async {
        final prefs = await SharedPreferences.getInstance();

   var  temp_selectlang = prefs.getString('selectlang');
    if(temp_selectlang==''||temp_selectlang==null){
      selectlang="en-IN";
      prefs.setString('selectlang', "en-IN");
    }
    else{
      selectlang=temp_selectlang;
    }


    

    notifyListeners();
  }
}





