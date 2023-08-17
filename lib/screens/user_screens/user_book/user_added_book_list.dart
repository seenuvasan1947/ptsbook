import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../../components/language/data/lang_maplocals.dart';
import '../../../components/language/lang_strings.dart';
import '../../../components/provider.dart';
import 'user_book_read_page.dart';

class booklist extends StatefulWidget {
  const booklist({super.key});

  @override
  State<booklist> createState() => _booklistState();
}

class _booklistState extends State<booklist> {
  final db = FirebaseFirestore.instance;

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
          title: Text(AppLocale.books_list.getString(context)),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: db.collection('books').snapshots(),
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
