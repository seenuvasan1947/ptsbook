  import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:mybook/components/functions/aditional_function_lang.dart';

import '../language/data/lang_data.dart';

Future<String> getTranslatedText(
       String string_to_conver_excel_data) async {
      final String response;
      String book__name_over_all = '';
      String crnt_content_lang=await getContentLang();
    int cont_lang_index = LangData.ContentLang.indexOf(crnt_content_lang);
    final TranslateLanguage sourceLanguage = TranslateLanguage.english;
    final TranslateLanguage targetLanguage =
        LangData.translanglist[cont_lang_index];
    final onDeviceTranslator = OnDeviceTranslator(
        sourceLanguage: sourceLanguage, targetLanguage: targetLanguage);

    // String originalText = doc.get(fieldName);

    // if (string_to_conver_excel_data == 'Book_Name') {
      book__name_over_all = response=
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
     String crnt_content_lang=await getContentLang();
    await flutterTts.setSpeechRate(0.25);
    await flutterTts.setPitch(1);
    await flutterTts.setLanguage(crnt_content_lang);
    print('object');
    print(crnt_content_lang);

    int cont_lang_index = LangData.ContentLang.indexOf(crnt_content_lang);

    print(LangData.VoiceList[cont_lang_index]);
    await flutterTts.setVoice({
      "name": LangData.VoiceList[cont_lang_index],
      "locale": crnt_content_lang
    });
  }



  