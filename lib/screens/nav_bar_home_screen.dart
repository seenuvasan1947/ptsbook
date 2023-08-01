// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:mybook/components/provider.dart';

import 'contact_us_page.dart';
import 'home_screen.dart';
import 'how_to_use.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return Consumer<Getcurrentuser>(
        builder: ((context, Getcurrentuser, child) => Scaffold(
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

                        const BottomBarItem(
                          inActiveItem: Icon(
                            Icons.contact_page_rounded,
                            color: Colors.blueGrey,
                          ),
                          activeItem: Icon(
                            Icons.contact_page_rounded,
                            color: Colors.blueAccent,
                          ),
                          itemLabel: 'contact us',
                        ),
                        const BottomBarItem(
                          inActiveItem: Icon(
                            Icons.home_filled,
                            color: Colors.blueGrey,
                          ),
                          activeItem: Icon(
                            Icons.home_filled,
                            color: Colors.blueAccent,
                          ),
                          itemLabel: 'Home',
                        ),

                        const BottomBarItem(
                          inActiveItem: Icon(
                            Icons.read_more,
                            color: Colors.blueGrey,
                          ),
                          activeItem: Icon(
                            Icons.read_more,
                            color: Colors.blueAccent,
                          ),
                          itemLabel: 'Know more',
                        ),
                       
                      ],
                      onTap: (index) {
                        /// perform action on tab change and to update pages you can update pages without pages
                        log('current selected index $index');
                        _pageController.jumpToPage(index);
                      },
                    )
                  : null,
            )));
  }
}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white, child: const Center(child: Text('Page 1')));
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white, child: const Center(child: Text('Page 2')));
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white, child: const Center(child: Text('Page 3')));
  }
}

class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white, child: const Center(child: Text('Page 4')));
  }
}

class Page5 extends StatelessWidget {
  const Page5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white, child: const Center(child: Text('Page 5')));
  }
}
