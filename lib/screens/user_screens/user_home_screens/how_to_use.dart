// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../components/language/lang_strings.dart';

class HowToUse extends StatefulWidget {
  const HowToUse({super.key});

  @override
  State<HowToUse> createState() => _HowToUseState();
}

class _HowToUseState extends State<HowToUse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.how_to_use_this_app.getString(context)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width * 0.8,
            child: Column(
              children: [
                Text(
                  AppLocale.topic1.getString(context),
                  style: TextStyle(fontSize: 20.0),
                ),
                Divider(
                  color: Colors.tealAccent,
                ),
                Text(AppLocale.stat1_topic1.getString(context)),
                Divider(
                  color: Colors.tealAccent,
                ),
                Text(AppLocale.stat2_topic1.getString(context)),
                Divider(
                  color: Colors.tealAccent,
                ),
                Text(AppLocale.stat3_topic1.getString(context)),
                Divider(
                  color: Colors.tealAccent,
                ),
                Text(AppLocale.stat4_topic1.getString(context)),
                Divider(
                  color: Colors.tealAccent,
                ),
                Divider(
                  color: Colors.tealAccent,
                ),
                Text(
                  AppLocale.topic2.getString(context),
                  style: TextStyle(fontSize: 20.0),
                ),
                Divider(
                  color: Colors.tealAccent,
                ),
                Text(AppLocale.stat1_topic2.getString(context)),
                Divider(
                  color: Colors.tealAccent,
                ),
                Divider(
                  color: Colors.tealAccent,
                ),
                Text(AppLocale.stat2_topic2.getString(context)),
                Divider(
                  color: Colors.tealAccent,
                ),
                Divider(
                  color: Colors.tealAccent,
                ),
                Text(
                  AppLocale.topic3.getString(context),
                  style: TextStyle(fontSize: 20.0),
                ),
                Divider(
                  color: Colors.tealAccent,
                ),
                Text(AppLocale.stat1_topic3.getString(context)),
                /* FaIcon(FontAwesomeIcons.gamepad), */
              ],
            ),
          ),
        ),
      ),
    );
  }
}
