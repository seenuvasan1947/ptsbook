import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:mybook/components/language/data/file_handler.dart';
import 'package:mybook/components/language/data/model.dart';
import 'package:excel/excel.dart';
import 'package:http/http.dart' as http;

class ExcellData extends ChangeNotifier {
  List<String> _bookname = [];
  List<String> _authorname = [];
  List<int> _no_of_episode = [];
  List<DateTime> _published_date = [];
  List<String> _file_url = [];
  List<String> _imageurl = [];
  List<String> _bookid = [];

  List<String> get bookname => _bookname;
  List<String> get authorname => _authorname;
  List<int> get no_of_episode => _no_of_episode;
  List<DateTime> get published_date => _published_date;
  List<String> get file_url => _file_url;
  List<String> get imageurl => _imageurl;
  List<String> get bookid => _bookid;

  Future<DataLists> fetchlistforrender(String gener) async {
    // Directory filedir=  await Filehandler.getfile();
    _bookname = [];
    _authorname = [];
    _no_of_episode = [];
    _published_date = [];
    _file_url = [];
    _imageurl = [];
    _bookid = [];

    //  _bookname.clear();
    //  _authorname.clear();
    //     _no_of_episode.clear();
    //    _published_date.clear();
    //    _file_url.clear();
    //    _imageurl.clear();
    //     _bookid.clear();
    String excelpath =
        "https://github.com/seenuvasan1947/ptsbook-data/raw/main/metadata/ptsbook_data.xlsx";
    // ByteData data = await File(filedir.path).readAsBytes();
    final response = await http.get(Uri.parse(excelpath));
    List<int> bytes = response.bodyBytes;
    // List<int> bytes = await File('${filedir.path}/ptsbook_data.xlsx').readAsBytes();
    var excel = await Excel.decodeBytes(Uint8List.fromList(bytes));

    // Get the specified sheets
    var table1 = await excel.tables[gener];
    // var table2 = await excel.tables['Sheet2'];

    List<String> columnValues1 = [''];
    List<String> columnValues2 = [''];
    List<String> columnValues3 = [''];
    List<String> columnValues4 = [''];
    List<String> columnValues5 = [''];
    List<String> columnValues6 = [''];
    List<String> columnValues7 = [''];

    for (var row in table1!.rows) {
      columnValues1.add(row.elementAt(0)!.value.toString());
    }
    for (var i = 2; i < columnValues1.length; i++) {
      _bookname.add(columnValues1[i]);
    }

    for (var row in table1!.rows) {
      columnValues2.add(row.elementAt(1)!.value.toString());
    }
    for (var i = 2; i < columnValues2.length; i++) {
      _authorname.add(columnValues2[i]);
    }

    for (var row in table1!.rows) {
      columnValues3.add(row.elementAt(2)!.value.toString());
    }
    for (var i = 2; i < columnValues3.length; i++) {
      _file_url.add(columnValues3[i]);
    }

    for (var row in table1!.rows) {
      columnValues4.add(row.elementAt(3)!.value.toString());
    }
    for (var i = 2; i < columnValues4.length; i++) {
      _imageurl.add(columnValues4[i]);
    }

    for (var row in table1!.rows) {
      columnValues7.add(row.elementAt(6)!.value.toString());
    }
    for (var i = 2; i < columnValues7.length; i++) {
      _bookid.add(columnValues7[i]);
      print(columnValues7[i]);
    }

    /* other data type */

    for (var row in table1!.rows) {
      columnValues5.add(row.elementAt(4)!.value.toString());
    }
    for (var i = 2; i < columnValues5.length; i++) {
      print(columnValues5[i]);

      // print(DateTime.now());
      _no_of_episode.add(int.parse(columnValues5[i]));
      print(_no_of_episode);
    }

    for (var row in table1!.rows) {
      columnValues6.add(row.elementAt(5)!.value.toString());
    }
    for (var i = 2; i < columnValues6.length; i++) {
      print(columnValues6[i]);
      // _published_date.add(DateTime.parse(columnValues6[i]));
      print(_published_date);
    }

    notifyListeners();
    return DataLists(bookname, authorname, no_of_episode, published_date,
        file_url, imageurl);
  }
}
