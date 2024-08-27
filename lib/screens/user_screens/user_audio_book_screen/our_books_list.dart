// ignore_for_file: camel_case_types, must_be_immutable, unnecessary_null_comparison, depend_on_referenced_packages, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:mybook/components/models/our_book_data_model.dart';

import 'package:search_choices/search_choices.dart';
import '../../../components/functions/aditional_function_lang.dart';
import '../../../components/functions/null_value_assign.dart';
import '../../../components/functions/oubook_dropdown.dart';
import '../../../components/language/data/excell_data.dart';
import '../../../components/language/lang_strings.dart';
import '../../../components/provider.dart';
import '../../../components/reusable_widget/book_list_widget.dart';
import '../user_home_screens/nav_bar_home_screen.dart';
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
  // List bookNames = [];
  

  String book__name_over_all = '';
  
   Ourbookmodel ourbookdata= ourbookemptyassign();

  @override
  void initState() {
    super.initState();
    context.read<Getcurrentuser>().getselectedcontentlang();
    Provider.of<ExcellData>(context, listen: false).fetchlistforrender(widget.lable);
    getContentLang();
    // fetchBookNames();
    // fetchinitdata();

  }

  void fetchinitdata(List<String> bookname) async{

       ourbookdata=await        fetchBookNames(bookname);
    

  }
  
  Future<void> refreshdata() async {
    // fetchBookNames();
    setState(() {
      selectedBook = 'abc';
    });
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
              child: Consumer<ExcellData>(
                builder:  (context, excelldata,child){
                  if (excelldata.bookname==[]) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                else{
                                  return SearchChoices.single(
                  items: buildDropdownMenuItems(excelldata.bookname),
                  value: selectedBook,
                  hint: AppLocale.select_a_book.getString(context),
                  searchHint: AppLocale.search_for_a_book.getString(context),
                  onChanged: (value) {
                    /* function */

                   fetchinitdata(excelldata.bookname);
                    
                    int selectedIndex = ourbookdata.translatedBookNames.indexOf(value);
                    if (selectedIndex >= 0 && selectedIndex < ourbookdata.bookNames.length) {}
                    setState(() {
                      selectedBook = ourbookdata.bookNames[selectedIndex];
                    });
                  },
                  dialogBox: true,
                  isExpanded: true,
                );
                                }
                },
                // child: 
              ),
            ),
            const Divider(color: Colors.deepPurple, thickness: 2.2),
          
            Expanded(
          
              child: booksList(ishome: false)            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.1,
            )
          ],
        ),
      ),
    );
  }
  
  
}
