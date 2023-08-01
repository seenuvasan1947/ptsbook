// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        title: Text('How To Use This App'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        
        child: Center(
                   child: SizedBox(
                    height: MediaQuery.sizeOf(context).height,
                    width: MediaQuery.sizeOf(context).width*0.8,
                     child: Column(
                      children: [
                   
                        Text('App Guidance',style: TextStyle(fontSize: 20.0),),
                         Divider(color: Colors.tealAccent,),
                        Text('''Free user's can use all books otherwise only able to use free books'''),
                        Divider(color: Colors.tealAccent,),
                        Text('user can also use Download option to play audio in ofline mode and if you are free user you can also download free books audio '),
                         Divider(color: Colors.tealAccent,),
                         Text('while playing audio if you come out it get stop but if you simply turn to sleep mode it play in background'),
                          Divider(color: Colors.tealAccent,),
                          Text('Each and Every book is available in all content language'),
                          Divider(color: Colors.tealAccent,),
                          Divider(color: Colors.tealAccent,),
                          Text('Why this app',style: TextStyle(fontSize: 20.0),),
                          Divider(color: Colors.tealAccent,),
                          Text('user can learn a book in all language in our app so language barrear for getting knowledge is avoided'),
                          Divider(color: Colors.tealAccent,),
                          Divider(color: Colors.tealAccent,),
                          Text('In this app not only hear user can also read the summery of that book or content'),
                          Divider(color: Colors.tealAccent,),
                          Divider(color: Colors.tealAccent,),
                          Text('Request book',style: TextStyle(fontSize: 20.0),),
                          Divider(color: Colors.tealAccent,),
                          Text('If you need any book message us through contact us'),
                          /* FaIcon(FontAwesomeIcons.gamepad), */
                   
                      ],
                     ),
                   ),
        ),
      ),
    );
  }
}