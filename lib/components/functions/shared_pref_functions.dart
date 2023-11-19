
import 'package:shared_preferences/shared_preferences.dart';


/* set values */


/* set int */

setintvalue(String key,int value)async{

  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt(key, value);
}

/* set double */

setdoublevalue(String key,double value)async{

  final prefs = await SharedPreferences.getInstance();
  await prefs.setDouble(key, value);
}



/* set bool */

setboolvalue(String key,bool value)async{

  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key, value);
}


/* set string  */

setstringvalue(String key,String value)async{

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

/* set string list  */

setstringlistvalue(String key,List<String> value)async{

  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(key,value);
  
}







/* get values */


/* set int */

  getintvalue(String key)async{

  final prefs = await SharedPreferences.getInstance();
 int? value=  await prefs.getInt(key);
 return value;
}

/* set double */

getdoublevalue(String key)async{

  final prefs = await SharedPreferences.getInstance();
  double? value= await prefs.getDouble(key);
  return value;
}



/* set bool */

getboolvalue(String key)async{

  final prefs = await SharedPreferences.getInstance();
  bool? value=await prefs.getBool(key);
  return value;
}


/* set string  */

getstringvalue(String key)async{

  final prefs = await SharedPreferences.getInstance();
  String? value= await prefs.getString(key);
  return value;
}

/* set string list  */

getstringlistvalue(String key)async{

  final prefs = await SharedPreferences.getInstance();
List<String>? value=  await prefs.getStringList(key);
return value;
  
}





