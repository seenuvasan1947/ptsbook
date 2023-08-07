
import 'package:flutter_localization/flutter_localization.dart';

import '../../provider.dart';
import '../lang_strings.dart';

class lang_init_local {
final FlutterLocalization localization = FlutterLocalization.instance;

  lang_init() async{

 
    localization.init(
      mapLocales: [
        const MapLocale('en', AppLocale.EN),
        const MapLocale('ta', AppLocale.TM),
        const MapLocale('hi', AppLocale.HI),
        const MapLocale('ml', AppLocale.ML),

        // const MapLocale('ml', AppLocale.ML),
        // const MapLocale('ar', AppLocale.AR),

      
      ],

      initLanguageCode: LangPropHandler.crnt_lang_code,
    );

  


}}