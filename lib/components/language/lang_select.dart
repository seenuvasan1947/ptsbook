import 'package:awesome_select/awesome_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '/components/language/lang_strings.dart';
import '/components/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LangSelect extends StatefulWidget {
  const LangSelect({super.key});

  @override
  State<LangSelect> createState() => _LangSelectState();
}

class _LangSelectState extends State<LangSelect> {
  final FlutterLocalization localization = FlutterLocalization.instance;
  List lang_list = ['en', 'tm', 'hi', 'ml','ar'];
  String value = 'lang';
  var temp_lang_index = 0;

  List<S2Choice<String>> options = [
    S2Choice<String>(value: 'en', title: 'English'),
    S2Choice<String>(value: 'tm', title: 'Tamil'),
    S2Choice<String>(value: 'hi', title: 'Hindi'),
    S2Choice<String>(value: 'ml', title: 'Malayalam'),
    S2Choice<String>(value: 'ar', title: 'Arabic'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlertDialog(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close))
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SmartSelect.single(
              selectedValue: value,
              title: AppLocale.Language.getString(context),
              choiceItems: options,
              onChange: (state) => setState(() async {
                value = state.value;
                // place_value=state.placeholder!;
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('crnt_lang_code', value);
                temp_lang_index = lang_list.indexOf(value);
                print(temp_lang_index);
                // LangPropHandler().getlangindex(temp_lang_index);
                localization.translate(value);
                Navigator.pop(context);
              }),
              // selectedChoice: options[LangPropHandler.lang_index],
            ),
          ],
        ),
      ),
    );
  }
}
