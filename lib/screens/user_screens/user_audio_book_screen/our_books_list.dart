// ignore_for_file: camel_case_types, must_be_immutable, unnecessary_null_comparison, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mybook/screens/user_screens/user_audio_book_screen/book_text_read_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:search_choices/search_choices.dart';
import '../../../components/language/lang_strings.dart';
import '../../../components/provider.dart';
import '../user_home_screens/home_screen.dart';
import '../user_home_screens/nav_bar_home_screen.dart';
import 'audioplayer.dart';
import 'package:provider/provider.dart';

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

  Future<void> _launchUrl(Uri tempurl) async {
    if (!await launchUrl(tempurl, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $tempurl');
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<Getcurrentuser>().getselectedcontentlang();

    fetchBookNames();
  }

  Future<void> fetchBookNames() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('our_books')
        .where('gener', isEqualTo: widget.lable)
        .where('is_published', isEqualTo: true)
        .where('free_book', isEqualTo: widget.freebook)
        .get();

    setState(() {
      /* 
       bookNames =bookNames =
       querySnapshot.docs.map((doc) => doc['Book_Name']).toList();
        */
      bookNames = bookNames = querySnapshot.docs
          .map((doc) => doc["${Getcurrentuser.selectlang}"]['Book_name'])
          .toList();
    });
  }

  List<DropdownMenuItem<String>> buildDropdownMenuItems() {
    return bookNames.map<DropdownMenuItem<String>>((var value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  Future<void> refreshdata() async {
    fetchBookNames();
    selectedBook = 'abc';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(AppLocale.books_list.getString(context)),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
             Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NavBarAtHomePage()),
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
                  setState(() {
                    selectedBook = value;
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
                        .where("${Getcurrentuser.selectlang}.Book_name",
                            isEqualTo: selectedBook)
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

                          // color: Index==0? Colors.indigoAccent:Color.fromARGB(255, 64, 251, 148),
                          child: InkWell(
                            onTap: () {
                              // var urllan = doc.get('Blog_Link');
                              // tempurl = Uri.parse(urllan);

                              // if (tempurl != '' &&
                              //     urllan != '' &&
                              //     tempurl != null &&
                              //     urllan != null) {
                              //   _launchUrl(tempurl);
                              // } else {
                              //   Fluttertoast.showToast(
                              //                   msg: AppLocale
                              //                       .blog_link_not_found
                              //                       .getString(context),
                              //                   toastLength: Toast.LENGTH_LONG,
                              //                   backgroundColor:
                              //                       Colors.pink.shade200,
                              //                   textColor: Colors.black,
                              //                   gravity: ToastGravity.CENTER,
                              //                   fontSize: 20.0,
                              //                 );
                              // }
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
                                    Text(doc["${Getcurrentuser.selectlang}"]
                                        ['Book_name']),
                                    Text(doc["${Getcurrentuser.selectlang}"]
                                        ['author_name']),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => book_read(
                                                        book_text_file:
                                                            doc["${Getcurrentuser.selectlang}"]
                                                                ['Text_File'],
                                                        book_name: doc[
                                                                "${Getcurrentuser.selectlang}"]
                                                            ['Book_name'])));
                                          },
                                          icon: const Icon(Icons.menu_book,
                                              color: Colors.red),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            if (doc["${Getcurrentuser.selectlang}"]
                                                        ['Audio_File'] !=
                                                    '' &&
                                                doc["${Getcurrentuser.selectlang}"]
                                                        ['Audio_File'] !=
                                                    null) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          audplayer(
                                                            audiourl: doc[
                                                                    "${Getcurrentuser.selectlang}"]
                                                                ['Audio_File'],
                                                            imageurl: doc.get(
                                                                'image_url'),
                                                            bookname: doc[
                                                                    "${Getcurrentuser.selectlang}"]
                                                                ['Book_name'],
                                                          )));
                                            } else {
                                              Fluttertoast.showToast(
                                                msg: AppLocale
                                                    .audio_file_not_found
                                                    .getString(context),
                                                toastLength: Toast.LENGTH_LONG,
                                                backgroundColor:
                                                    Colors.pink.shade200,
                                                textColor: Colors.black,
                                                gravity: ToastGravity.CENTER,
                                                fontSize: 20.0,
                                              );
                                            }
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        audplayer(
                                                          audiourl: doc[
                                                                  "${Getcurrentuser.selectlang}"]
                                                              ['Audio_File'],
                                                          imageurl: doc
                                                              .get('image_url'),
                                                          bookname:
                                                              doc["${Getcurrentuser.selectlang}"]
                                                                  ['Book_name'],
                                                        )));
                                          },
                                          icon: const Icon(
                                              Icons.audiotrack_rounded,
                                              color: Colors.purple),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            var urllan = doc.get('Video_Link');
                                            tempurl = Uri.parse(urllan);
                                            if (tempurl != '' &&
                                                urllan != '' &&
                                                tempurl != null &&
                                                urllan != null) {
                                              _launchUrl(tempurl);
                                            } else {
                                             Fluttertoast.showToast(
                                                msg: AppLocale
                                                    .video_link_not_found
                                                    .getString(context),
                                                toastLength: Toast.LENGTH_LONG,
                                                backgroundColor:
                                                    Colors.pink.shade200,
                                                textColor: Colors.black,
                                                gravity: ToastGravity.CENTER,
                                                fontSize: 20.0,
                                              );
                                            }
                                            // _launchUrl(tempurl);
                                          },
                                          icon: const Icon(
                                            FontAwesomeIcons.youtube,
                                            color: Color.fromARGB(
                                                255, 172, 48, 48),
                                          ),
                                        ),
                                        // IconButton(
                                        //   onPressed: () {
                                        //     var urllan = doc.get('Blog_Link');
                                        //     tempurl = Uri.parse(urllan);
                                        //     if (tempurl != '' &&
                                        //         urllan != '' &&
                                        //         tempurl != null &&
                                        //         urllan != null) {
                                        //       _launchUrl(tempurl);
                                        //     } else {
                                        //       ScaffoldMessenger.of(context)
                                        //           .showSnackBar(
                                        //         const SnackBar(
                                        //           content: Text(
                                        //               'blog link not found'),
                                        //         ),
                                        //       );
                                        //     }
                                        //   },
                                        //   icon: const Icon(
                                        //       Icons.language_rounded,
                                        //       color: Colors.black26),
                                        // ),
                                      ],
                                    )
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
       
          ],
        ),
      ),
    );
  }
}
