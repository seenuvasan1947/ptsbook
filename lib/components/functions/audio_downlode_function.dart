






 import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mybook/components/functions/aditional_function_lang.dart';
import 'package:mybook/components/functions/operational_function.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<void> downloadAudio(String textUrl, int episode,String bookname) async {
 await   requestPermission();
    // if(Permission.storage.isGranted==true){
   await ttspropset();
    String crnt_content_lang=await getContentLang();
String? _downloadedFilePath;
var downloaded_file_name = '';
 bool is_dowloading = false;
      FlutterTts flutterTts = FlutterTts();

    if (await Permission.storage.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.

      Fluttertoast.showToast(
        msg: 'you audio downloading please wait',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: const Color.fromARGB(255, 109, 96, 169),
        textColor: const Color.fromARGB(255, 15, 0, 0),
        gravity: ToastGravity.CENTER,
        fontSize: 20.0,
      );
      // }
      Directory? dir = await getExternalStorageDirectory();
      final url = Uri.parse(textUrl);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // final file = File('${directory!.path}/Music/ptsbook/audio.mp3');
// ignore: use_build_context_synchronously
        Directory devicefiledir =
            Directory(path.join('${dir!.path}', bookname));
        if (!(await devicefiledir.exists())) {
          await devicefiledir.create(recursive: true);
          print('Directory created at $devicefiledir');
        } else {
          print('Directory already exists at $devicefiledir');
        }
        final FilePath =
            '${bookname}/${bookname}_${episode + 1}.mp3';
        flutterTts.synthesizeToFile(response.body, FilePath);

        Directory filedir = Directory('/storage/emulated/0/Music/ptsbook');
        if (!(await filedir.exists())) {
          await filedir.create(recursive: true);
          print('Directory created at $filedir');
        } else {
          print('Directory already exists at $filedir');
        }
        downloaded_file_name = '${bookname}_${crnt_content_lang}_${episode + 1}';
        var file_home =
            File('/storage/emulated/0/Music/ptsbook/$downloaded_file_name.mp3');
        print('0000');
        print(file_home);
        print('11111');

        File file = File('${dir.path}/${FilePath}');
        print(file);
        flutterTts.setCompletionHandler(() async {
          file_home.create().then((value) => print(value));
          //  await file.copy('$file_home');
          var filedata = await file.readAsBytes();
          await file_home.writeAsBytes(filedata);
          Fluttertoast.showToast(
            msg: 'you audio downloaded at $_downloadedFilePath',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: const Color.fromARGB(255, 109, 96, 169),
            textColor: const Color.fromARGB(255, 15, 0, 0),
            gravity: ToastGravity.CENTER,
            fontSize: 20.0,
          );
          await file.delete();
// await file_home.writeAsString(response.body);
          
            is_dowloading = true;
          
        });


        
          _downloadedFilePath = 'Music/ptsbook/$downloaded_file_name.mp3';
        
        print('sucessssssssss');
        is_dowloading == true
            ? Fluttertoast.showToast(
                msg: 'you audio downloaded at $_downloadedFilePath',
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: const Color.fromARGB(255, 109, 96, 169),
                textColor: const Color.fromARGB(255, 15, 0, 0),
                gravity: ToastGravity.CENTER,
                fontSize: 20.0,
              )
            : Text('');
        
          is_dowloading = false;
     
      } else {
       
          is_dowloading = false;
 
        throw Exception('Failed to download audio');
      }
    }
  }
