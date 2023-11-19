import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

import '../language/data/lang_data.dart';
import '../models/our_book_data_model.dart';
import 'aditional_function_lang.dart';

List<String> translatedBookNames = [];

Future<Ourbookmodel> fetchBookNames(booknamelist) async {
    // getContentLang();
      List bookNames = [];
    String crnt_content_lang=await getContentLang();
    int cont_lang_index = LangData.ContentLang.indexOf(crnt_content_lang);
    print(crnt_content_lang);
    print(cont_lang_index);
    final TranslateLanguage sourceLanguage = TranslateLanguage.english;
    final TranslateLanguage targetLanguage =
        LangData.translanglist[cont_lang_index];
    final onDeviceTranslator = OnDeviceTranslator(
        sourceLanguage: sourceLanguage, targetLanguage: targetLanguage);


bookNames=booknamelist;
            for (String name in bookNames) {
     final String response =
          await onDeviceTranslator.translateText(name);
            
      translatedBookNames.add(response);
       
    }
    List<Future<String>> translationFutures = bookNames.map((name) async {
      final String response = await onDeviceTranslator.translateText(name);
      return response;
    }).toList();

    // Wait for all translations to complete
    translatedBookNames = await Future.wait(translationFutures);

    return Ourbookmodel(bookNames,translatedBookNames);
  }

  List<DropdownMenuItem<String>> buildDropdownMenuItems(List<String> bookname) {


    fetchBookNames(bookname);
    
    // getContentLang();
    return translatedBookNames.map<DropdownMenuItem<String>>((var value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
      
    }).toList();
    
  }
