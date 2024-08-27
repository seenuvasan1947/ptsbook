// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_function_type_syntax_for_parameters, depend_on_referenced_packages, use_build_context_synchronously




import 'package:flutter/material.dart';
import 'package:mybook/components/functions/operational_function.dart';

import 'package:mybook/components/language/data/excell_data.dart';


import 'package:provider/provider.dart';

import '../../screens/user_screens/user_audio_book_screen/audioplayer.dart';


// import '../components/language/lang_strings.dart';
// import '../../admin_screens/admin_home_page.dart';
import '../../screens/user_screens/user_home_screens/home_screen.dart';

// import '../user_audio_book_screen/audioplayer.dart';
// import '../user_audio_book_screen/book_text_read_page.dart';
// import '../user_audio_book_screen/our_books_list.dart';

// import 'lang_select_page.dart';
// import 'nav_bar_home_screen.dart';

  
  ScrollController _scrollController = ScrollController();
  

  Consumer<ExcellData> booksList({required bool ishome}) {
    
    return Consumer<ExcellData>(



                       
                            // stream: db
                            //     .collection('our_books')
                            //     .where("gener", isEqualTo: widget.lable  )
                        
                            //     .snapshots(),
                        
                          
                            builder: (context, excelldata,child) {
                              if (excelldata.bookname==[]) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.91,
                                  child: ListView.builder(
                                    controller: ishome==true? _scrollController:null,
                                    padding:
                                        const EdgeInsetsDirectional.symmetric(
                                            vertical: 2),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: excelldata.bookname.length,
                                    itemBuilder: (BuildContext context, int index){
                                    // children: snapshot.data!.docs.map((doc) {
                                      return Card(
                                        color: Colors.deepPurple[200],
                                        child: InkWell(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(35.0),
                                              bottom: Radius.circular(35.0)),
                                          onTap: () async {
                                           String response= await getbookaut(
                                                          excelldata.bookname[index],'book_name');
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        audplayer(
                                                          rooturl: excelldata.file_url[index],
                                                          imageurl: excelldata.imageurl[index],
                                                          // bookname: book__name_over_all,
                                                          bookname: response,
                                                          number_of_epi: excelldata.no_of_episode[index],
                                                          // doc["${Getcurrentuser.selectlang}"]
                                                          //     ['Book_Name'],
                                                        )));
                                          },
                                          splashColor: Colors.pink,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                SizedBox.square(
                                                  dimension: 110.0,
                                                  // child: Image.asset('assets/book.jpeg')
                                                  child: Image.network(
                                                     excelldata.imageurl[index]),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.all(10),
                                                ),
                                                Column(
                                                  children: [
                                                    // Text(
                                                    //     doc.get('Book_Name')),
                        
                                                    // FutureBuilder<String>(
                                                    //   future: getTranslatedText(
                                                    //       excelldata.bookname[index]),
                                                    //   builder:
                                                    //       (context, snapshot) {
                                                    //     if (snapshot
                                                    //             .connectionState ==
                                                    //         ConnectionState
                                                    //             .waiting) {
                                                    //       return Text(
                                                    //     excelldata.bookname[index]); // Display a loading indicator
                                                    //     } else if (snapshot
                                                    //         .hasError) {
                                                    //       return 
                                                    //       // Text('Error: ${snapshot.error}');
                                                    //       Text(
                                                    //     excelldata.bookname[index]);
                                                    //     } else {
                                                    //       return Text(snapshot
                                                    //           .data!); // Display the translated text
                                                    //     }
                                                    //   },
                                                    // ),
                        


  FutureBuilder<String>(
                                                      future: getbookaut(
                                                          excelldata.bookname[index],'book_name'),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return Text(
                                                        excelldata.bookname[index]); // Display a loading indicator
                                                        } else if (snapshot
                                                            .hasError) {
                                                          return 
                                                          // Text('Error: ${snapshot.error}');
                                                          Text(
                                                        excelldata.bookname[index]);
                                                        } else {
                                                          return Text(snapshot
                                                              .data!); // Display the translated text
                                                        }
                                                      },
                                                    ),



                                                    FutureBuilder<String>(
                                                      future: getbookaut(
                                                         excelldata.authorname[index],'author_name'),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return Text(
                                                        excelldata.authorname[index]); // Display a loading indicator
                                                        } else if (snapshot
                                                            .hasError) {
                                                          return 
                                                          // Text(    'Error: ${snapshot.error}');
                                                          Text(
                                                        excelldata.authorname[index]);
                                                        } else {
                                                          return Text(snapshot
                                                              .data!); // Display the translated text
                                                        }
                                                      },
                                                    ),
                        
                                                    // Text(doc
                                                    //     .get('Author_name')),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    // }).toList(),
                                  ),
                                );
                              }
                            },
                          
                        );
  }
