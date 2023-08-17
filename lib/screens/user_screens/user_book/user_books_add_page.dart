// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:mybook/components/re_usable_widget.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mybook/components/provider.dart';

import '../../../components/language/data/lang_maplocals.dart';
import '../../../components/language/lang_strings.dart';


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
  Future<String?> adddata() async {
    FirebaseFirestore.instance.collection("books").doc(book_name).set({
      'poster_name': Getcurrentuser.user,
      'book_name': book_name,
      'author_name': author_name,
      'short_discription': short_discription,
      'long_discription': long_discription,
    });
    Navigator.of(context).pop();
    return null;
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
                    onPressed: () {
                      adddata();
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
