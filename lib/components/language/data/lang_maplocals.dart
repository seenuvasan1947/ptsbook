
import 'package:flutter_localization/flutter_localization.dart';

import '../../provider.dart';
import '../lang_strings.dart';

class lang_init_local {
final FlutterLocalization localization = FlutterLocalization.instance;

  lang_init() async{

 
    localization.init(
      mapLocales: [
        const MapLocale('ta', AppLocale.TM),
        const MapLocale('ar', AppLocale.AR),
        const MapLocale('bg', AppLocale.BG),
        const MapLocale('bn', AppLocale.BN),
        const MapLocale('bs', AppLocale.BS),
        const MapLocale('ca', AppLocale.CA),
        const MapLocale('cs', AppLocale.CS),
        const MapLocale('cy', AppLocale.CY),
        const MapLocale('da', AppLocale.DA),
        const MapLocale('de', AppLocale.DE),
        const MapLocale('el', AppLocale.EL),
        const MapLocale('en', AppLocale.EN),
        // const MapLocale('en', AppLocale.EN),
        // const MapLocale('en', AppLocale.EN),
        const MapLocale('es', AppLocale.ES),
        const MapLocale('et', AppLocale.ET),
        const MapLocale('fi', AppLocale.FI),
        const MapLocale('fil', AppLocale.FIL),
        const MapLocale('fr', AppLocale.FR),
        const MapLocale('gu', AppLocale.GU),
        const MapLocale('he', AppLocale.HE),
        const MapLocale('hi', AppLocale.HI),
        const MapLocale('hr', AppLocale.HR),
        const MapLocale('hu', AppLocale.HU),
        const MapLocale('id', AppLocale.ID),
        const MapLocale('is', AppLocale.IS),
        const MapLocale('it', AppLocale.IT),
        const MapLocale('ja', AppLocale.JA),
        const MapLocale('jv', AppLocale.JV),
        const MapLocale('km', AppLocale.KM),
        const MapLocale('kn', AppLocale.KN),
        const MapLocale('ko', AppLocale.KO),
        const MapLocale('lv', AppLocale.LV),
        const MapLocale('lt', AppLocale.LT),
        const MapLocale('ml', AppLocale.ML),
        const MapLocale('mr', AppLocale.MR),
        const MapLocale('ms', AppLocale.MS),
        const MapLocale('nb', AppLocale.NB),
        const MapLocale('ne', AppLocale.NE),
        const MapLocale('nl', AppLocale.NL),
        const MapLocale('pt', AppLocale.PT),
        // const MapLocale('pt', AppLocale.PT),
        const MapLocale('pl', AppLocale.PL),
        const MapLocale('pa', AppLocale.PA),
        const MapLocale('ro', AppLocale.RO),
        const MapLocale('ru', AppLocale.RU),
        const MapLocale('si', AppLocale.SI),
        const MapLocale('sk', AppLocale.SK),
        const MapLocale('sq', AppLocale.SQ),
        const MapLocale('sr', AppLocale.SR),
        const MapLocale('su', AppLocale.SU),
        const MapLocale('sv', AppLocale.SV),
        const MapLocale('sw', AppLocale.SW),
        const MapLocale('te', AppLocale.TE),
        const MapLocale('th', AppLocale.TH),
        const MapLocale('tr', AppLocale.TR),
        const MapLocale('uk', AppLocale.UK),
        const MapLocale('ur', AppLocale.UR),
        const MapLocale('vi', AppLocale.VI),
        const MapLocale('zh', AppLocale.ZH),
       

      
      ],

      initLanguageCode: LangPropHandler.crnt_lang_code,
    );

  


}}