// ignore_for_file: camel_case_types, must_be_immutable, unnecessary_null_comparison, depend_on_referenced_packages, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:mybook/screens/user_screens/user_audio_book_screen/book_text_read_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:search_choices/search_choices.dart';
import '../../../components/language/data/lang_data.dart';
import '../../../components/language/lang_strings.dart';
import '../../../components/provider.dart';
import '../user_home_screens/home_screen.dart';
import '../user_home_screens/nav_bar_home_screen.dart';
import 'audioplayer.dart';
import 'package:provider/provider.dart';

// import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class ourbooklist extends StatefulWidget {
  String lable = '';
  bool freebook = false;
  ourbooklist(
      {super.key, required String this.lable, required bool this.freebook});

  @override
  State<ourbooklist> createState() => _ourbooklistState();
}

class _ourbooklistState extends State<ourbooklist> {
  final db = FirebaseFirestore.instance;
  late Uri tempurl;
  var selectedBook = 'abc';
  List bookNames = [];
  List<String> translatedBookNames = [];

  String book__name_over_all = '';
  String crnt_content_lang = '';

  Future<void> _launchUrl(Uri tempurl) async {
    if (!await launchUrl(tempurl, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $tempurl');
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<Getcurrentuser>().getselectedcontentlang();
    getContentLang();
    // fetchBookNames();
  }

  void getContentLang() async {
    final prefs = await SharedPreferences.getInstance();

    crnt_content_lang = await prefs.getString('selectlang')!;
    print('object');
    print(crnt_content_lang);

    if (crnt_content_lang == '') {
      print('*****');
      print(crnt_content_lang);
      setState(() {
        crnt_content_lang = 'en-IN';
      });
    } else {
      setState(() {
        crnt_content_lang = crnt_content_lang;
      });

      print('@@@@@');
      print(crnt_content_lang);
    }
    fetchBookNames();
  }

  Future<void> fetchBookNames() async {
    // getContentLang();
    int cont_lang_index = LangData.ContentLang.indexOf(crnt_content_lang);
    print(crnt_content_lang);
    print(cont_lang_index);
    final TranslateLanguage sourceLanguage = TranslateLanguage.english;
    final TranslateLanguage targetLanguage =
        LangData.translanglist[cont_lang_index];
    final onDeviceTranslator = OnDeviceTranslator(
        sourceLanguage: sourceLanguage, targetLanguage: targetLanguage);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('our_books')
        .where('gener', isEqualTo: widget.lable)
        .where('is_published', isEqualTo: true)
        .where('free_book', isEqualTo: widget.freebook)
        .get();

    /* 
       bookNames =bookNames =
       querySnapshot.docs.map((doc) => doc['Book_Name']).toList();
        */
    bookNames = bookNames =
        await querySnapshot.docs.map((doc) => doc.get('Book_Name')).toList();

    print('-------------------');
    print(bookNames);

            for (String name in bookNames) {
     final String response =
          await onDeviceTranslator.translateText(name);
            print('-------------------');
            print(name);
      translatedBookNames.add(response);
        print('-------------------');
      print('-------------------');
      print(translatedBookNames);
    }
    List<Future<String>> translationFutures = bookNames.map((name) async {
      final String response = await onDeviceTranslator.translateText(name);
      return response;
    }).toList();

    // Wait for all translations to complete
    translatedBookNames = await Future.wait(translationFutures);

    print('-------------------');
    print(translatedBookNames);
  }

  List<DropdownMenuItem<String>> buildDropdownMenuItems() {
    fetchBookNames();
    // getContentLang();
    return translatedBookNames.map<DropdownMenuItem<String>>((var value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
      
    }).toList();
    
  }

  Future<void> refreshdata() async {
    // fetchBookNames();
    setState(() {
      selectedBook = 'abc';
    });
  }

  Future<String> getTranslatedText(
      DocumentSnapshot doc, String fieldName) async {
    int cont_lang_index = LangData.ContentLang.indexOf(crnt_content_lang);
    final TranslateLanguage sourceLanguage = TranslateLanguage.english;
    final TranslateLanguage targetLanguage =
        LangData.translanglist[cont_lang_index];
    final onDeviceTranslator = OnDeviceTranslator(
        sourceLanguage: sourceLanguage, targetLanguage: targetLanguage);

    String originalText = doc.get(fieldName);

    if (fieldName == 'Book_Name') {
      book__name_over_all =
          await onDeviceTranslator.translateText(originalText);
    }

    final String response =
        await onDeviceTranslator.translateText(originalText);

    // Get the text from Firestore document based on the fieldName

    // Translate the text to Tamil (or any other target language)
    // Translation translation = await translator.translateText(
    //   text: originalText,
    //   sourceLanguage: 'en', // Assuming the source language is English
    //   targetLanguage: 'ta', // 'ta' represents Tamil
    // );

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.books_list.getString(context)),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => NavBarAtHomePage()),
              );
            },
            icon: Icon(Icons.arrow_back_sharp)),
      ),
      body: RefreshIndicator(
        onRefresh: refreshdata,
        child: Column(
          children: [
            const Divider(color: Colors.deepPurple, thickness: 2.2),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchChoices.single(
                items: buildDropdownMenuItems(),
                value: selectedBook,
                hint: AppLocale.select_a_book.getString(context),
                searchHint: AppLocale.search_for_a_book.getString(context),
                onChanged: (value) {
                  int selectedIndex = translatedBookNames.indexOf(value);
                  if (selectedIndex >= 0 && selectedIndex < bookNames.length) {}
                  setState(() {
                    selectedBook = bookNames[selectedIndex];
                  });
                },
                dialogBox: true,
                isExpanded: true,
              ),
            ),
            const Divider(color: Colors.deepPurple, thickness: 2.2),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                // stream: db
                //     .collection('our_books')
                //     .where("gener", isEqualTo: widget.lable  )

                //     .snapshots(),

                stream: selectedBook == 'abc'
                    ? db
                        .collection('our_books')
                        .where("gener", isEqualTo: widget.lable)
                        .where('is_published', isEqualTo: true)
                        .where('free_book', isEqualTo: widget.freebook)
                        .snapshots()
                    : db
                        .collection('our_books')
                        // .where("Book_Name", isEqualTo: selectedBook)
                        .where("gener", isEqualTo: widget.lable)
                        .where("Book_Name", isEqualTo: selectedBook)
                        .where('is_published', isEqualTo: true)
                        .where('free_book', isEqualTo: widget.freebook)
                        .snapshots(),

                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView(
                      padding:
                          const EdgeInsetsDirectional.symmetric(vertical: 2),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: snapshot.data!.docs.map((doc) {
                        return Card(
                          color: Colors.deepPurple[200],
                          child: InkWell(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(35.0),
                                bottom: Radius.circular(35.0)),
                            onTap: () async {
                              // final TranslateLanguage sourceLanguage =
                              //     TranslateLanguage.english;
                              // final TranslateLanguage targetLanguage =
                              //     TranslateLanguage.tamil;

                              // final onDeviceTranslator = OnDeviceTranslator(
                              //     sourceLanguage: sourceLanguage,
                              //     targetLanguage: targetLanguage);

                              // book__name_over_all = await onDeviceTranslator
                              //     .translateText(doc.get('Book_Name'));

                              await getTranslatedText(doc, 'Book_Name');

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => audplayer(
                                            rooturl: doc.get('root_path'),
                                            imageurl: doc.get('image_url'),
                                            bookname: book__name_over_all,
                                            number_of_epi:doc.get('no_of_episode'),
                                            // doc["${Getcurrentuser.selectlang}"]
                                            //     ['Book_Name'],
                                          )));
                            },
                            splashColor: Colors.pink,
                            child: Row(
                              children: [
                                SizedBox.square(
                                  dimension: 110.0,
                                  // child: Image.asset('assets/book.jpeg')
                                  child: Image.network(doc.get('image_url')),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(10),
                                ),
                                Column(
                                  children: [
                                    FutureBuilder<String>(
                                      future:
                                          getTranslatedText(doc, 'Book_Name'),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Text(doc.get('Book_Name')); // Display a loading indicator
                                        } else if (snapshot.hasError) {
                                          return 
                                          // Text(    'Error: ${snapshot.error}');
                                          Text(doc.get('Book_Name'));
                                        } else {
                                          return Text(snapshot
                                              .data!); // Display the translated text
                                        }
                                      },
                                    ),
                                    FutureBuilder<String>(
                                      future:
                                          getTranslatedText(doc, 'Author_name'),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Text(doc.get('Author_name')); // Display a loading indicator
                                        } else if (snapshot.hasError) {
                                          return 
                                          Text(doc.get('Author_name'));
                                          // Text('Error: ${snapshot.error}');
                                        } else {
                                          return Text(snapshot
                                              .data!); // Display the translated text
                                        }
                                      },
                                    ),
                                    // Text(doc.get('Book_Name')),
                                    // Text(doc.get('Author_name')),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.1,
            )
          ],
        ),
      ),
    );
  }
}
