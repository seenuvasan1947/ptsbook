import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:mybook/screens/admin_screens/splash_screen.dart';
// import 'package:mentorme/components/language/lang_strings.dart';
// import 'package:mentorme/screens/welcome_screen.dart';
import '../../auth/auth.dart';
import '../../screens/user_screens/user_home_screens/home_screen.dart';
import '/components/language/lang_strings.dart';
import '/components/provider.dart';

import 'package:provider/provider.dart';

import 'data/lang_maplocals.dart';
class LangMainPage extends StatefulWidget {
  const LangMainPage({super.key});

  @override
  State<LangMainPage> createState() => _LangMainPageState();
}

// mixin AppLocale {
//   static const String title = 'title';
//   static const Map<String, dynamic> EN = {title: 'Localization'};
//   static const Map<String, dynamic> TM = {title: 'ការធ្វើមូលដ្ឋានីយកម្ម'};
//   static const Map<String, dynamic> HI = {title: 'ローカリゼーション'};
// }

class _LangMainPageState extends State<LangMainPage> {
  final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  void initState() {
    context.read<LangPropHandler>().getlangindex();
    // _localization.translate(LangPropHandler.crnt_lang_code);
    // _localization.translate('en');
    // _localization.translate('tm');
    
    // localization.init(
    //   mapLocales: [
    //     const MapLocale('en', AppLocale.EN),
    //     const MapLocale('ta', AppLocale.TM),
    //     const MapLocale('hi', AppLocale.HI),
    //     const MapLocale('ml', AppLocale.ML),

    //     // const MapLocale('ml', AppLocale.ML),
    //     // const MapLocale('ar', AppLocale.AR),

      
    //   ],

    //   initLanguageCode: LangPropHandler.crnt_lang_code,
    // );
    lang_init_local().lang_init();
    localization.onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
    localization.translate(LangPropHandler.crnt_lang_code);
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
      home: const SplashScreen(),
      // home: const LoginPage(),
    );
  }
}
