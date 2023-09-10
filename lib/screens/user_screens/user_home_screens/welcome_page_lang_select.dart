import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/language/lang_strings.dart';
import '../../../components/provider.dart';
import '../../../components/provider.dart';
import '../../../components/language/data/lang_data.dart';
import 'home_screen.dart';
import 'package:provider/provider.dart';

import 'nav_bar_home_screen.dart';

class welcomepropPage extends StatefulWidget {

  welcomepropPage({super.key});

  @override
  State<welcomepropPage> createState() => _welcomepropPageState();
}

class _welcomepropPageState extends State<welcomepropPage> {
  List<String> contentlanglist = LangData.ContentLang;
  String contentlang_selectedValue = 'en-IN';
  String applang_selectedValue = 'ta';
  bool is_app_lang_selected = false;
  bool is_content_lang_selected = false;
  String crnt_app_lang = '';
  String crnt_content_lang = '';

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<LangPropHandler>().getlangindex();
    context.read<LangPropHandler>().getprop_selectedcontentlang();
  
    
      Fluttertoast.showToast(
          msg: 'select both language for continue',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.pink.shade200,
          textColor: Colors.black,
          gravity: ToastGravity.CENTER,
          fontSize: 20.0,
        );
            
    

  }

  Future<void> setcontentlang(String selectedlang) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('selectlang', selectedlang);
    print(prefs.getString('selectlang'));
    isselected = true;
  }

  
  @override
  Widget build(BuildContext context) {
    return Consumer<LangPropHandler>(
        builder: ((context, LangPropHandler, child) => Scaffold(
              appBar: AppBar(
                title: Text(AppLocale.languages.getString(context)),
              ),
              body: Center(
                child: Column(
                  children: [
                    
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.8,
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.1,
                            ),
                            ExpansionTile(
                              title: Text(
                                  AppLocale.app_language.getString(context)),
                              children: [
                                Scrollbar(
                                  thumbVisibility: true,
                                  // Set this to true to always show the scrollbar
                                  controller: _scrollController,
                                  child: ListView.builder(
                                      controller: _scrollController,
                                      itemBuilder: (context, Index) {
                                        return ListTile(
                                          splashColor: Colors.cyan,
                                          selectedColor: Colors.deepPurple,
                                          selectedTileColor:
                                              Colors.indigoAccent,
                                          onTap: () async {
                                            // set_app_lang();
                                            setState(() {
                                              localization.translate(
                                                  LangData.appLang[Index]);
                                            });

                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setString('crnt_lang_code',
                                                LangData.appLang[Index]);
// print(prefs.getString('crnt_lang_code'));

                                            setState(() {
                                              is_app_lang_selected = true;
                                            });
                                           
                                            ExpansionTileController.of(context)
                                                .collapse();
                                           
                                             Fluttertoast.showToast(
          msg: 'app lang ${LangData.ContentLang[Index]} is selected',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.pink.shade200,
          textColor: Colors.black,
          gravity: ToastGravity.CENTER,
          fontSize: 20.0,

        );
                                           
                                          },
                                          title: Text(LangData.appLang[Index]),
                                          subtitle:
                                              Text(LangData.LangName[Index]),
                                        );
                                      },
                                      itemCount: LangData.appLang.length,
                                      shrinkWrap: true),
                                ),
                                // ScrollHandle(),
                              ],
                            ),
                           
                            ExpansionTile(
                              title: Text(AppLocale.content_language
                                  .getString(context)),
                              children: [
                                Scrollbar(
                                  thumbVisibility: true,
                                  // Set this to true to always show the scrollbar
                                  controller: _scrollController,
                                  child: ListView.builder(
                                      controller: _scrollController,
                                      itemBuilder: (context, Index) {
                                        return ListTile(
                                          splashColor: Colors.cyan,
                                          selectedColor: Colors.deepPurple,
                                          selectedTileColor:
                                              Colors.indigoAccent,
                                          onTap: () async {
                                            // set_app_lang();
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setString('selectlang',
                                                LangData.ContentLang[Index]);
                                            setcontentlang(
                                                LangData.ContentLang[Index]);
                                            // isselected == true
                                            //     ? ScaffoldMessenger.of(context)
                                            //         .showSnackBar(
                                            //         SnackBar(
                                            //           content: Text(
                                            //               'content lang ${LangData.ContentLang[Index]} is selected'),
                                            //         ),
                                            //       )
                                            //     : null;
                                            setState(() {
                                              is_content_lang_selected = true;
                                            });
                                               
                                            ExpansionTileController.of(context)
                                                .collapse();
                                        
                                            Fluttertoast.showToast(
          msg: 'content lang ${LangData.ContentLang[Index]} is selected',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.pink.shade200,
          textColor: Colors.black,
          gravity: ToastGravity.CENTER,
          fontSize: 20.0,
        );
                                           
                                          },
                                          title:
                                              Text(LangData.ContentLang[Index]),
                                          subtitle:
                                              Text(LangData.LangName[Index]),
                                        );
                                      },
                                      itemCount: LangData.ContentLang.length,
                                      shrinkWrap: true),
                                ),
                                // ScrollHandle(),
                              ],
                            ),
                           
                                 Divider(
                        color: Colors.purple[200],
                        thickness: 3,
                      ),
                      SizedBox(height: MediaQuery.sizeOf(context).height*0.08,),
                                  ElevatedButton(
                            onPressed: () {  is_app_lang_selected&&is_content_lang_selected==true?
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>

                                          // ignore: unrelated_type_equality_checks
                                          NavBarAtHomePage())):   
      Fluttertoast.showToast(
          msg: 'select both language for continue',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.pink.shade200,
          textColor: Colors.black,
          gravity: ToastGravity.CENTER,
          fontSize: 20.0,
        );;
                            },
                            child: Text('Go'),
                          )
                          ],
                        ),
                      ),
                    ),
                  
                  ],
                ),
              ),
            )));
  }
}

class ScrollHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        Scrollable.ensureVisible(
          context,
          duration: Duration(milliseconds: 200),
          alignment: 0.5,
        );
      },
      child: Container(
        width: 30,
        height: 6,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}

