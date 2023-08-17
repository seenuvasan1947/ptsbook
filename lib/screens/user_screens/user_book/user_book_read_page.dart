import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../../components/language/data/lang_maplocals.dart';
import '../../../components/language/lang_strings.dart';
import '../../../components/provider.dart';

class Login_Book_Read extends StatefulWidget {
  String bookname = '';
  String authorname = '';
  String shortdisc = '';
  String longdisc = '';
   Login_Book_Read(
      {super.key,
      required String this.bookname,
      required String this.authorname,
      required String this.shortdisc,
      required String this.longdisc});

  @override
  State<Login_Book_Read> createState() => _Login_Book_ReadState();
}

class _Login_Book_ReadState extends State<Login_Book_Read> {
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
        appBar: AppBar(title: Text(AppLocale.book_detail.getString(context)),),
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Text(
                    AppLocale.book_name.getString(context),
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(
                    height: 27,
                  ),
                  Text(widget.bookname),
                  const SizedBox(
                    height: 35,
                  ),
                  Text(
                    AppLocale.author_name.getString(context),
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(
                    height: 27,
                  ),
                  Text(widget.authorname),
                  const SizedBox(
                    height: 35,
                  ),
                  Text(
                    AppLocale.short_discription.getString(context),
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(
                    height: 27,
                  ),
                  Text(widget.shortdisc),
                  const SizedBox(
                    height: 35,
                  ),
                  Text(
                    AppLocale.long_discription.getString(context),
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(
                    height: 27,
                  ),
                  Text(widget.longdisc),
                  const SizedBox(
                    height: 35,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
