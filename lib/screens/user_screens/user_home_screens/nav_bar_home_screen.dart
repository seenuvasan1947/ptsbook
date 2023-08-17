// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:developer';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:mybook/components/language/lang_strings.dart';
import 'package:mybook/components/provider.dart';

import '../../../components/language/data/lang_maplocals.dart';
import 'contact_us_page.dart';
import 'home_screen.dart';
import 'how_to_use.dart';
import 'package:provider/provider.dart';

import 'lang_select_page.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class NavBarAtHomePage extends StatefulWidget {
  const NavBarAtHomePage({Key? key}) : super(key: key);

  @override
  State<NavBarAtHomePage> createState() => _NavBarAtHomePageState();
}

class _NavBarAtHomePageState extends State<NavBarAtHomePage> {
  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 1);

  /// Controller to handle bottom nav bar and also handles initial page
  final _controller = NotchBottomBarController(index: 1);

  int maxCount = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// widget list
  final List<Widget> bottomBarPages = [
    const ContactusPage(),
    // const Page2(),
    const HomeScreenMainPage(),

    const HowToUse(),
  ];



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
    return Consumer<Getcurrentuser>(
        builder: ((context, Getcurrentuser, child) => MaterialApp(

               supportedLocales: localization.supportedLocales,
              localizationsDelegates: localization.localizationsDelegates,
          home: Scaffold(
                body: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(
                      bottomBarPages.length, (index) => bottomBarPages[index]),
                ),
                extendBody: true,
                bottomNavigationBar: (bottomBarPages.length <= maxCount)
                    ? AnimatedNotchBottomBar(
                        /// Provide NotchBottomBarController
                        notchBottomBarController: _controller,
                        color: Colors.white,
                        showLabel: true,
                        notchColor: Colors.pinkAccent,
        
                        /// restart app if you change removeMargins
                        removeMargins: false,
                        bottomBarWidth: 500,
                        durationInMilliSeconds: 300,
                        bottomBarItems: [
                          // const BottomBarItem(
        
                          //   inActiveItem: Icon(
                          //     Icons.star,
                          //     color: Colors.blueGrey,
                          //   ),
                          //   activeItem: Icon(
                          //     Icons.star,
                          //     color: Colors.blueAccent,
                          //   ),
                          //   itemLabel: 'Page',
        
                          // ),
        
                          ///svg example
        
                          BottomBarItem(
                            inActiveItem: const Icon(
                              Icons.contact_page_rounded,
                              color: Colors.blueGrey,
                            ),
                            activeItem: const Icon(
                              Icons.contact_page_rounded,
                              color: Colors.blueAccent,
                            ),
                            // itemLabel: AppLocale.contact_us.getString(context),
                            // itemLabel: 'contact'
                          ),
                          BottomBarItem(
                            inActiveItem: const Icon(
                              Icons.home_filled,
                              color: Colors.blueGrey,
                            ),
                            activeItem: const Icon(
                              Icons.home_filled,
                              color: Colors.blueAccent,
                            ),
                            // itemLabel: AppLocale.home_page.getString(context),
                          ),
        
                          BottomBarItem(
                            inActiveItem: const Icon(
                              Icons.read_more,
                              color: Colors.blueGrey,
                            ),
                            activeItem: const Icon(
                              Icons.read_more,
                              color: Colors.blueAccent,
                            ),
                            // itemLabel: AppLocale.know_more.getString(context),
                          ),
                        ],
                        onTap: (index) {
                          /// perform action on tab change and to update pages you can update pages without pages
                          log('current selected index $index');
                          _pageController.jumpToPage(index);
                        },
                      )
                    : null,
              ),
        )));
  }
}
