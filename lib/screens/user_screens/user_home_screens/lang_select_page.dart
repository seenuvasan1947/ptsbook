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

class SettingsPage extends StatefulWidget {
 
  SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
   
    getAppLang();
    getContentLang();
   
    

  }

  Future<void> setcontentlang(String selectedlang) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('selectlang', selectedlang);
    print(prefs.getString('selectlang'));
    isselected = true;
  }

  void getAppLang() async {
    final prefs = await SharedPreferences.getInstance();

    crnt_app_lang = await prefs.getString('crnt_lang_code')!;

    if (crnt_app_lang == '') {
      print('*****');
      print(crnt_app_lang);
      setState(() {
        crnt_app_lang = 'ta';
      });
    } else {
      setState(() {
        crnt_app_lang = crnt_app_lang;
      });

      print('@@@@@');
      print(crnt_app_lang);
    }

    getContentLang();
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
                    // DropdownButton<String>(
                    //   value: contentlang_selectedValue,
                    //   onChanged: (String? newValue) async {
                    //     setState(() {
                    //       contentlang_selectedValue = newValue!;
                    //     });
                    //     setcontentlang(contentlang_selectedValue);
                    //                               isselected == true
                    //                                   ? ScaffoldMessenger.of(context)
                    //                                       .showSnackBar(
                    //                                       SnackBar(
                    //                                         content: Text(
                    //                                             'content lang $contentlang_selectedValue is selected'),
                    //                                       ),
                    //                                     )
                    //                                   : null;
                    //   },
                    //   items: LangData.ContentLang.map((String value) {
                    //     return DropdownMenuItem<String>(
                    //       value: value,
                    //       child: Column(children: [Text(value),Text(value)],)
                    //     );
                    //   }).toList(),
                    // ),
                    // DropdownButton<String>(
                    //   value: applang_selectedValue,
                    //   onChanged: (String? newValue) async {
                    //     setState(() {
                    //       applang_selectedValue = newValue!;
                    //     });
                    //     final prefs = await SharedPreferences.getInstance();
                    //     prefs.setString('crnt_lang_code', applang_selectedValue);

                    //     localization.translate(applang_selectedValue);
                    //   },
                    //   items: LangData.appLang.map((String value) {
                    //     return DropdownMenuItem<String>(
                    //         value: value,
                    //         child: Column(
                    //           children: [
                    //             // for(var i=0;i<LangData.LangName.length;i++)
                    //             Text(
                    //                 LangData.LangName[LangData.appLang.indexOf(value)]),
                    //             Text(value)
                    //           ],
                    //         ));
                    //   }).toList(),
                    // ),
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
                                            getAppLang();
                                             Fluttertoast.showToast(
          msg: 'app lang ${LangData.ContentLang[Index]} is selected',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.pink.shade200,
          textColor: Colors.black,
          gravity: ToastGravity.CENTER,
          fontSize: 20.0,

        );
                                            Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            NavBarAtHomePage()));
                                           
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
                           
                                Text(AppLocale.current_app_language
                                    .getString(context)),
                              
                           
                                 Text(crnt_app_lang),
                             
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
                                            getContentLang();
                                            Fluttertoast.showToast(
          msg: 'content lang ${LangData.ContentLang[Index]} is selected',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.pink.shade200,
          textColor: Colors.black,
          gravity: ToastGravity.CENTER,
          fontSize: 20.0,
        );
                                            Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            NavBarAtHomePage()));
                                             
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
                             Text(AppLocale.current_content_language
                                    .getString(context)),
                               Text(crnt_content_lang)
                               
                               
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


// import 'package:flutter/material.dart';

// /// Flutter code sample for [ExpansionTile] and [ExpansionTileController].

// void main() {
//   runApp(const ExpansionTileControllerApp());
// }

// class ExpansionTileControllerApp extends StatefulWidget {
//   const ExpansionTileControllerApp({super.key});

//   @override
//   State<ExpansionTileControllerApp> createState() =>
//       _ExpansionTileControllerAppState();
// }

// class _ExpansionTileControllerAppState
//     extends State<ExpansionTileControllerApp> {
//   final ExpansionTileController controller = ExpansionTileController();

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(useMaterial3: true),
//       home: Scaffold(
//         appBar: AppBar(title: const Text('ExpansionTileController Sample')),
//         body: Column(
//           children: <Widget>[
//             // A controller has been provided to the ExpansionTile because it's
//             // going to be accessed from a component that is not within the
//             // tile's BuildContext.
//             ExpansionTile(
//               controller: controller,
//               title: const Text('ExpansionTile with explicit controller.'),
//               children: <Widget>[
//                 Container(
//                   alignment: Alignment.center,
//                   padding: const EdgeInsets.all(24),
//                   child: const Text('ExpansionTile Contents'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton(
//               child: const Text('Expand/Collapse the Tile Above'),
//               onPressed: () {
//                 if (controller.isExpanded) {
//                   controller.collapse();
//                 } else {
//                   controller.expand();
//                 }
//               },
//             ),
//             const SizedBox(height: 48),
//             // A controller has not been provided to the ExpansionTile because
//             // the automatically created one can be retrieved via the tile's BuildContext.
//             ExpansionTile(
//               title: const Text('ExpansionTile with implicit controller.'),
//               children: <Widget>[
//                 Builder(
//                   builder: (BuildContext context) {
//                     return Container(
//                       padding: const EdgeInsets.all(24),
//                       alignment: Alignment.center,
//                       child: ElevatedButton(
//                         child: const Text('Collapse This Tile'),
//                         onPressed: () {
//                           return ExpansionTileController.of(context).collapse();
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
