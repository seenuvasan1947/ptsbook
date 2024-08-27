import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:mybook/components/functions/aditional_function_lang.dart';

import '../language/data/lang_data.dart';
import 'shared_pref_functions.dart';

Future<String> getTranslatedText(String string_to_conver_excel_data) async {
  final String response;
  String book__name_over_all = '';
  String crnt_content_lang = await getContentLang();
  int cont_lang_index = LangData.ContentLang.indexOf(crnt_content_lang);
  final TranslateLanguage sourceLanguage = TranslateLanguage.english;
  final TranslateLanguage targetLanguage =
      LangData.translanglist[cont_lang_index];
  final onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: sourceLanguage, targetLanguage: targetLanguage);

  // String originalText = doc.get(fieldName);

  // if (string_to_conver_excel_data == 'Book_Name') {
  book__name_over_all = response =
      await onDeviceTranslator.translateText(string_to_conver_excel_data);
  // }

  // final String response =
  //     await onDeviceTranslator.translateText(string_to_conver_excel_data);

  // Get the text from Firestore document based on the fieldName

  // Translate the text to Tamil (or any other target language)
  // Translation translation = await translator.translateText(
  //   text: originalText,
  //   sourceLanguage: 'en', // Assuming the source language is English
  //   targetLanguage: 'ta', // 'ta' represents Tamil
  // );

  return response;
}

Future<void> ttspropset() async {
  FlutterTts flutterTts = FlutterTts();
  String crnt_content_lang = await getContentLang();
  String voice_selected = await getvoice();

  await flutterTts.setSpeechRate(0.25);
  await flutterTts.setPitch(1);
  await flutterTts.setLanguage(crnt_content_lang);
  print('object');
  print('voice ${voice_selected}');
  print(crnt_content_lang);
// List<String> abc= LangData.VoiceListVarious[0];
  int cont_lang_index = LangData.ContentLang.indexOf(crnt_content_lang);

  print(LangData.VoiceList[cont_lang_index]);
  await flutterTts.setVoice({
    // "name": LangData.VoiceList[cont_lang_index],
    "name": voice_selected,
    // "name": LangData.VoiceListVarious[cont_lang_index][0],
    "locale": crnt_content_lang
  });
}

// List<DropdownMenuItem<String>> dropdown_aud_player(){

//   LangData.VoiceListVarious[LangData.ContentLang.indexOf(crnt_content_lang)] .map((item) => DropdownMenuItem<String>(
//     value: item,
//     child: Text(item),
//   )).toList(),

// }

Future<List<String>> data_dropdown_aud_play() async {
  String crnt_content_lang = await getContentLang();

  List<String> aud_drop_list = LangData
      .VoiceListVarious[LangData.ContentLang.indexOf(crnt_content_lang)];
// await setstringvalue("voice",aud_drop_list[1]);
  return aud_drop_list;
}

// Text aud_text_widget(){

//   return Text('data');
// }

Future<String> getvoice() async {
  String voice_selected = await getstringvalue("voice");
  String crnt_content_lang = await getContentLang();
  List<String> aud_drop_list = LangData
      .VoiceListVarious[LangData.ContentLang.indexOf(crnt_content_lang)];

  if (voice_selected == '' || voice_selected == null) {
    voice_selected = aud_drop_list[0];
    return voice_selected;
  } else {
    voice_selected = voice_selected;
    return voice_selected;
  }
}

FutureBuilder aud_text_widget() {
  return FutureBuilder(
      future: getvoice(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        else {
          return CircularProgressIndicator();
        }
      });
}
