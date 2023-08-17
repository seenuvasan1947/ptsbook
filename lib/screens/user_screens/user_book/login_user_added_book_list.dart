// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:mybook/components/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/language/data/lang_maplocals.dart';
import '../../../components/language/lang_strings.dart';
import 'user_book_read_page.dart';

// import 'package:provider/provider.dart';
class mybooklist extends StatefulWidget {
  const mybooklist({super.key});

  @override
  State<mybooklist> createState() => _mybooklistState();
}

class _mybooklistState extends State<mybooklist> {
  final db = FirebaseFirestore.instance;
  final prefs = SharedPreferences.getInstance();

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
      home: Scaffold(
        appBar: AppBar(
          title: Text(AppLocale.my_books_list.getString(context)),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: db
                    .collection('books')
                    .where("poster_name", isEqualTo: '${Getcurrentuser.user}')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: snapshot.data!.docs.map((doc) {
                        return Card(
                          child: ListTile(
                            title: Text(doc['book_name']),
                            subtitle: Text(doc['author_name']),
                            trailing: IconButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection("books")
                                      .doc(doc['book_name'])
                                      .delete();
                                },
                                icon: const Icon(Icons.remove)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login_Book_Read(
                                            bookname: doc['book_name'],
                                            authorname: doc['author_name'],
                                            shortdisc: doc['short_discription'],
                                            longdisc: doc['long_discription'],
                                          )));

                              /* 
                            
                            doc['book_name'],doc['author_name'],doc['short_discription'],doc['long_discription']
                             */
                            },
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
