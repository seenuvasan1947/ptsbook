// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:mybook/components/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/language/data/lang_maplocals.dart';
import '../../../components/language/data/user_book_excel_data.dart';
import '../../../components/language/lang_strings.dart';
import 'user_book_read_page.dart';
import 'package:provider/provider.dart';

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
    Provider.of<UserExcellData>(context, listen: false).fetchuserexcellistforrender();
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
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: Consumer<UserExcellData>(
                    builder: (context, excelldata, child) {
                  if (excelldata.bookname == []) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.91,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: excelldata.bookname.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            color: Colors.deepPurple[200],
                            child: ListTile(
                              title: Text(excelldata.bookname[index]),
                              subtitle: Text(excelldata.authorname[index]),
                              // trailing: IconButton(
                              //     onPressed: () async {
                              //       await FirebaseFirestore.instance
                              //           .collection("books")
                              //           .doc(doc['book_name'])
                              //           .delete();
                              //     },
                              //     icon: const Icon(Icons.remove)),
                              splashColor: Colors.pink,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login_Book_Read(
                                              bookname:
                                                  excelldata.bookname[index],
                                              authorname:
                                                  excelldata.authorname[index],
                                              shortdisc:
                                                  excelldata.shortdisc[index],
                                              longdisc:
                                                  excelldata.longdisc[index],
                                            )));

                                /* 
                                
                                doc['book_name'],doc['author_name'],doc['short_discription'],doc['long_discription']
                                 */
                              },
                            ),
                          );
                        },
                      ),
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
