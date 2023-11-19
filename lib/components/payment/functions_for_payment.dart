// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mybook/components/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../screens/user_screens/user_home_screens/nav_bar_home_screen.dart';
import '../functions/aditional_function_lang.dart';
import '../functions/shared_pref_functions.dart';
import '../language/lang_strings.dart';

Future<bool> check_valid() async {
  bool heisvalid = false;
  final prefs = await SharedPreferences.getInstance();

  String? user = prefs.getString('name');

  if (user != 'guest@gmail.com') {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(user).get();
    print(userDoc.get('purchased'));
    if (userDoc == null || userDoc.exists == false) {
      heisvalid = false;
      return heisvalid;
    } else if (userDoc.exists == true) {
      bool isPurchased = userDoc.get('purchased');
      final isvalid = userDoc.get('validDate') as Timestamp;
      final validDate = isvalid.toDate();
      final now = DateTime.now();
      //  DateTime isvalid =userDoc.get('validDate') ;
      //  DateTime now=DateTime.now();
      if (isPurchased == true && now.isBefore(validDate)) {
        heisvalid = true;
        print(heisvalid);

        heisvalid = true;
        return heisvalid;
      } else {
        heisvalid = false;
        print(heisvalid);

        heisvalid = false;
        return heisvalid;
      }
    }
    print('valid check');
  } else {
    heisvalid = false;
    return heisvalid;
  }
  return heisvalid;
}

Future<bool> availCode(BuildContext context, String code) async {
  List<dynamic> code_list = [];
  List<dynamic> date_for_code_list = [];
  List<dynamic> user_for_code_list = [];

  bool is_code_Purchased = false; //replecement of _ispurchased

  bool heisguest = await check_he_is_guest();

  final prefs = await SharedPreferences.getInstance();
  final db = FirebaseFirestore.instance;
  String? user = prefs.getString('name');
  CollectionReference collection =
      FirebaseFirestore.instance.collection('metadata');

  DocumentSnapshot snapshot = await collection.doc('coupon_code_data').get();
  Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
  if (data != null &&
      data.containsKey('coupon_code_list') &&
      data.containsKey('no_of_days') &&
      data.containsKey(code)) {
    code_list = data['coupon_code_list'];
    date_for_code_list = data['no_of_days'];
    user_for_code_list = data[code];
    print(code_list);

    // if (code == '' || code == null||code.isEmpty==true) {
    //   Fluttertoast.showToast(
    //     msg: 'enter code',
    //     toastLength: Toast.LENGTH_LONG,
    //     backgroundColor: Colors.pink.shade200,
    //     textColor: Colors.black,
    //     gravity: ToastGravity.CENTER,
    //     fontSize: 20.0,
    //   );
    // } else

    if (heisguest == false &&
        code_list.contains(code) == true &&
        user_for_code_list.contains(user) == false) {
      FirebaseFirestore.instance
          .collection('metadata')
          .doc('coupon_code_data')
          .update({
        code: FieldValue.arrayUnion([user])
      });
      int dataNo = date_for_code_list[code_list.indexOf(code)];
      DateTime purchaseDate = DateTime.now();

      DateTime validDate = purchaseDate.add(Duration(days: dataNo));

      await db.collection('users').doc(Getcurrentuser.user).update({
        'purchased': true,
        'purchaseDate': purchaseDate,
        'validDate': validDate,
        'no_of_days': dataNo
      });
      Fluttertoast.showToast(
        msg: AppLocale.code_redemed.getString(context),
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.pink.shade200,
        textColor: Colors.black,
        gravity: ToastGravity.CENTER,
        fontSize: 20.0,
      );
      // Navigator.pop(context);

      is_code_Purchased = true;
setboolvalue("ispurchased",is_code_Purchased);
      check_valid();
      if (is_code_Purchased == true) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => NavBarAtHomePage()));
      }
    } else if (heisguest == true) {
      Fluttertoast.showToast(
        msg: AppLocale.guest_user_not_able_to_avail.getString(context),
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.pink.shade200,
        textColor: Colors.black,
        gravity: ToastGravity.CENTER,
        fontSize: 20.0,
      );
      is_code_Purchased=false;
      setboolvalue("ispurchased",is_code_Purchased);
    } else if (user_for_code_list.contains(user) == true) {
      Fluttertoast.showToast(
        msg: AppLocale.code_already_redemed_by_you.getString(context),
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.pink.shade200,
        textColor: Colors.black,
        gravity: ToastGravity.CENTER,
        fontSize: 20.0,
      );
      is_code_Purchased=false;
      setboolvalue("ispurchased",is_code_Purchased);
    } 
    // admin_list[admin_list.indexOf('seenu')];
  } else if (code_list.contains(code) == false) {
    Fluttertoast.showToast(
      msg: AppLocale.code_is_not_valid.getString(context),
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.pink.shade200,
      textColor: Colors.black,
      gravity: ToastGravity.CENTER,
      fontSize: 20.0,
    );
    is_code_Purchased=false;
    setboolvalue("ispurchased",is_code_Purchased);
  }

  // if(heisguest==false&&user)
  return is_code_Purchased;
}
