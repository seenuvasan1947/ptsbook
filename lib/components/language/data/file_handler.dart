import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Filehandler {

static Future<Directory>  getfile()async {
  Directory devicefiledir=Directory('');
    final prefs = await SharedPreferences.getInstance();
  Dio dio = Dio();
    

var filepath="https://github.com/seenuvasan1947/ptsbook-data/raw/main/metadata/ptsbook_data.xlsx";


   final response = await http.get(Uri.parse(filepath));

// response.contentLength;



         Directory? dir = await getExternalStorageDirectory();
   

      if (response.statusCode == 200) {
        print(response.contentLength);
        print(await prefs.getInt('excelsize'));
        devicefiledir = Directory(path.join('${dir!.path}','metadata','data'));
        if (!(await devicefiledir.exists())) {
          await devicefiledir.create(recursive: true);
           
          
            await prefs.setInt('excelsize',response.contentLength!);
            
            await dio.download(filepath, '${devicefiledir.path}'+'/ptsbook_data.xlsx');

          print('Directory created at $devicefiledir');
        } else if(await prefs.getInt('excelsize')!=response.contentLength) {
              await dio.download(filepath, '${devicefiledir.path}'+'/ptsbook_data.xlsx');
          print('Directory already exists at $devicefiledir');
        }

                 

  }
  return devicefiledir;
  
}}