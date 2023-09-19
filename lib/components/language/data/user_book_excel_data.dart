import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mybook/components/language/data/file_handler.dart';
import 'package:mybook/components/language/data/model.dart';
import 'package:excel/excel.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
class UserExcellData  extends ChangeNotifier{

    List<String> _bookname = [];
    List<String> _authorname = [];
    
    List<String> _shortdisc = [];
     List<String> _longdisc = [];

List<String> get bookname =>_bookname;
List<String> get authorname =>_authorname;

List<String> get shortdisc =>_shortdisc;
List<String> get longdisc =>_longdisc;

  Future<UserDataLists> fetchuserexcellistforrender() async{

    // Directory filedir=  await Filehandler.getfile();
    _bookname = [];
   _authorname = [];
   _shortdisc = [];
      _longdisc = [];
     
    

Directory? dir = await getExternalStorageDirectory();
File excelpath =File('${dir!.path}/userexcel.xlsx');
// String excelpath="https://github.com/seenuvasan1947/ptsbook-data/raw/main/metadata/ptsbook_data.xlsx";
    // ByteData data = await File(excelpath.path).readAsBytes();
    // final response = await http.get(Uri.parse(excelpath));
    // List<int> bytes=response.bodyBytes;
    List<int> bytes = await excelpath.readAsBytes();
    var excel = await Excel.decodeBytes(Uint8List.fromList(bytes));

    // Get the specified sheets
    var table1 = await excel.tables['Sheet1'];
    // var table2 = await excel.tables['Sheet2'];
 
     
 for (var row in table1!.rows) {

      _bookname.add(row.elementAt(0)!.value.toString());
       _authorname.add(row.elementAt(1)!.value.toString());
       _shortdisc.add(row.elementAt(2)!.value.toString());
        _longdisc.add(row.elementAt(3)!.value.toString());
      print(_bookname);
    }

notifyListeners();
    return UserDataLists(bookname, authorname, shortdisc, longdisc);
  }
  
}