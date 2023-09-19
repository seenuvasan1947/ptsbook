// ignore_for_file: camel_case_types

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:mybook/components/re_usable_widget.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mybook/components/provider.dart';

import '../../../components/language/data/lang_maplocals.dart';
import '../../../components/language/lang_strings.dart';


import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:excel/excel.dart';

class bookaddscreen extends StatefulWidget {
  const bookaddscreen({super.key});

  @override
  State<bookaddscreen> createState() => _bookaddscreenState();
}

class _bookaddscreenState extends State<bookaddscreen> {

final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  void initState() {
    // TODO: implement initState
        lang_init_local().lang_init();
    localization.onTranslatedLanguage = _onTranslatedLanguage;
    localization.translate(LangPropHandler.crnt_lang_code);
    super.initState();

  }
    void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }
   String book_name='';
   String author_name='';
   String short_discription='';
   String long_discription='';
  final db = FirebaseFirestore.instance;
  Future<void> adddata() async {
    Excel? excel;
    Sheet? sheet;
    final Directory? appDocumentsDirectory = await getExternalStorageDirectory();


  // Define the file path for the Excel file
  // final String excelFilePath = '${appDocumentsDirectory!.path}/userexcel.xlsx';

final file = File('${appDocumentsDirectory!.path}/userexcel.xlsx');
  // Create an Excel workbook
  // final excel1= await Excel.createExcel();
if (!await file.exists()) {
    print('File does not exist at path: $file');
    // excel = Excel.createExcel();
    // file.create();
  final excel= await Excel.createExcel();
   sheet = await excel.tables['Sheet1'];
     final cellData = [
    [book_name, author_name, short_discription,long_discription],
    // ['John', '30', 'New York'],
    // ['Alice', '25', 'Los Angeles'],
    // ['Bob', '35', 'Chicago'],
  ];
   for (final row in cellData) {
    sheet!.appendRow(row);
  }

  // Save the workbook to a file
    // final file = File('${appDocumentsDirectory!.path}/userexcel.xlsx');
  file.writeAsBytesSync(excel.encode()!);
    return;
  }
  else{
     excel = Excel.decodeBytes(file.readAsBytesSync());

 sheet = await excel.tables['Sheet1'];
  // Define cell values
  final cellData = [
    [book_name, author_name, short_discription,long_discription],
    // ['John', '30', 'New York'],
    // ['Alice', '25', 'Los Angeles'],
    // ['Bob', '35', 'Chicago'],
  ];

  // Populate the worksheet with cell values
  for (final row in cellData) {
    sheet!.appendRow(row);
  }

  // Save the workbook to a file
    // final file = File('${appDocumentsDirectory!.path}/userexcel.xlsx');
  file.writeAsBytesSync(excel.encode()!);

  }
    // excel = Excel.createExcel();

  // final sheet = excel['Sheet1'];


//  sheet = await excel.tables['Sheet1'];
//   // Define cell values
//   final cellData = [
//     [book_name, author_name, short_discription,long_discription],
//     // ['John', '30', 'New York'],
//     // ['Alice', '25', 'Los Angeles'],
//     // ['Bob', '35', 'Chicago'],
//   ];

//   // Populate the worksheet with cell values
//   for (final row in cellData) {
//     sheet!.appendRow(row);
//   }

//   // Save the workbook to a file
//     // final file = File('${appDocumentsDirectory!.path}/userexcel.xlsx');
//   file.writeAsBytesSync(excel.encode()!);
  // You can save `excelBytes` to a file or send it as needed.

  print('Excel file generated.');
  }
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: localization.supportedLocales,
              localizationsDelegates: localization.localizationsDelegates,
              
      home: Scaffold(
        body: SingleChildScrollView(
          child: AlertDialog(
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close))
            ],
            title:  Text(AppLocale.book_add.getString(context)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                    enableIMEPersonalizedLearning: true,
                    autocorrect: true,
                    obscureText: false,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      book_name = value;
                      //Do something with the user input.
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: AppLocale.book_name.getString(context))),
                const SizedBox(
                  height: 30.0,
                ),
                TextField(
                    obscureText: false,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      author_name = value;
                      //Do something with the user input.
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: AppLocale.enter_author_name.getString(context))),
                const SizedBox(
                  height: 30.0,
                ),
                TextField(
                    obscureText: false,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      short_discription = value;
                      //Do something with the user input.
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: AppLocale.enter_short_dicription_of_the_book.getString(context))),
                const SizedBox(
                  height: 30.0,
                ),
                TextField(
                    minLines: 7,
                    maxLines: 20,
                    obscureText: false,
                    keyboardType: TextInputType.multiline,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      long_discription = value;
                      //Do something with the user input.
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: AppLocale.enter_long_discription_of_the_book.getString(context))),
                const SizedBox(
                  height: 30.0,
                ),
                ElevatedButton(
                    onPressed: () async{
                     await adddata();
                      Navigator.pop(context);
                    },
                    child: Text(AppLocale.save.getString(context))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
