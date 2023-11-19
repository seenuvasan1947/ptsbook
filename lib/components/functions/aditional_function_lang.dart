import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'shared_pref_functions.dart';

Future<String> getContentLang() async {
  final prefs = await SharedPreferences.getInstance();
  String crnt_content_lang = '';
  crnt_content_lang = await prefs.getString('selectlang')!;
  print('object');
  print(crnt_content_lang);

  if (crnt_content_lang == '') {
    print('*****');
    print(crnt_content_lang);

    crnt_content_lang = 'en-IN';
  } else {
    crnt_content_lang = crnt_content_lang;

    print('@@@@@');
    print(crnt_content_lang);
  }
  return crnt_content_lang;
}

Future<void> requestPermission() async {
  bool _hasPermission = false;
  final permissionStatus = await Permission.storage.status;
  if (permissionStatus.isDenied) {
// final status = await Permission.manageExternalStorage.request();
    final status = await Permission.storage.request();

    _hasPermission = status.isGranted;
  } else {
    _hasPermission = permissionStatus.isGranted;
  }
}

Future<bool> check_he_is_guest() async {
  final prefs = await SharedPreferences.getInstance();
  bool heisguest = true;
  String? user = prefs.getString('name');

  if (user != 'guest@gmail.com') {
    heisguest = false;
    return heisguest;
  } else {
    heisguest = true;
    return heisguest;
  }
}

Future<bool> check_he_is_purchased() async {
  bool? ispurchased = await getboolvalue("ispurchased");

  if (ispurchased == true) {
    // heisguest = true;
    return true;
  } else if (ispurchased == false) {
    return false;
  } else {
    // heisguest = false;
    return false;
  }
}
