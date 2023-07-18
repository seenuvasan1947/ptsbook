// ignore_for_file: camel_case_types, must_be_immutable

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:search_choices/search_choices.dart';

import '../components/provider.dart';
import 'audiofromcaption.dart';
import 'audioplayer.dart';
import 'package:provider/provider.dart';

class ourbooklist extends StatefulWidget {
  String lable = '';

  ourbooklist({super.key, required String this.lable});

  @override
  State<ourbooklist> createState() => _ourbooklistState();
}

class _ourbooklistState extends State<ourbooklist> {
  final db = FirebaseFirestore.instance;
  late Uri tempurl;
  bool isFavorite = false;
  late AudioPlayer _player;

  String _url = "https://samplelib.com/lib/preview/mp3/sample-15s.mp3";
  bool isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  var selectedBook = 'abc';
  List bookNames = [];

  Future<void> _launchUrl(Uri tempurl) async {
    if (!await launchUrl(tempurl, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $tempurl');
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<Getcurrentuser>().getselectedcontentlang();
    _player = AudioPlayer();
    _player.onAudioPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }

      // setState(() {
      //   _position = position;
      // });
    });
    _player.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _duration = duration;
        });
      }

      // setState(() {
      //   _duration = duration;
      // });
    });
    // setplayerstate();
    fetchBookNames();
  }

  

  Future<void> fetchBookNames() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('our_books')
        .where('gener', isEqualTo: widget.lable)
        .get();

    setState(() {
         print('999');
       print("${Getcurrentuser.selectlang}");
       print(widget.lable);
      // bookNames =bookNames =
      //  querySnapshot.docs.map((doc) => doc['Book_Name']).toList();
       print('999');
       print("${Getcurrentuser.selectlang}");
       print(querySnapshot.docs.map((doc) => doc['Book_Name']).toList());
       print( querySnapshot.docs.map((doc) => doc.get("${Getcurrentuser.selectlang}")['Book_name']).toList());

       /* 
       bookNames =bookNames =
       querySnapshot.docs.map((doc) => doc['Book_Name']).toList();
        */
      bookNames = bookNames =
          querySnapshot.docs.map((doc) => doc["${Getcurrentuser.selectlang}"]['Book_name']).toList();
    });
  }


  List<DropdownMenuItem<String>> buildDropdownMenuItems() {
    return bookNames.map<DropdownMenuItem<String>>((var value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  Future<void> refreshdata() async {
    fetchBookNames();
    selectedBook = 'abc';
  }


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books List'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: refreshdata,
        child: Column(
          children: [
            Divider(color: Colors.deepPurple, thickness: 2.2),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: SearchChoices.single(
                items: buildDropdownMenuItems(),
                value: selectedBook,
                hint: 'Select a book',
                searchHint: 'Search for a book',
                onChanged: (value) {
                  setState(() {
                    selectedBook = value;
                  });
                },
                dialogBox: true,
                isExpanded: true,
              ),
            ),
            Divider(color: Colors.deepPurple, thickness: 2.2),
            ElevatedButton(onPressed: (){
              
            }, child:Text('next page')),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                // stream: db
                //     .collection('our_books')
                //     .where("gener", isEqualTo: widget.lable  )

                //     .snapshots(),
                stream: selectedBook == 'abc'
                    ? db
                        .collection('our_books')
                        .where("gener", isEqualTo: widget.lable)
                        .snapshots()
                    : db
                        .collection('our_books')
                        // .where("Book_Name", isEqualTo: selectedBook)
                        .where("${Getcurrentuser.selectlang}.Book_name", isEqualTo: selectedBook)
                        .snapshots(),

                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView(
                      padding:
                          const EdgeInsetsDirectional.symmetric(vertical: 2),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: snapshot.data!.docs.map((doc) {
                        // var _isFavorite;
                        return Card(
                          child: InkWell(
                            onTap: () {
                              var urllan = doc.get('Blog_Link');
                              tempurl = Uri.parse(urllan);

                              _launchUrl(tempurl);
                            },
                            splashColor: Colors.pink,
                            child: Row(
                              children: [
                                SizedBox.square(
                                    dimension: 110.0,
                                    // child: Image.asset('assets/book.jpeg')
                                    child: Image.network('https://github.com/seenuvasan1947/flames-app/raw/main/assets/AppIcons/playstore.png'),
                                    ),
                                const Padding(
                                  padding: EdgeInsets.all(10),
                                ),
                                Column(
                                  children: [
                                    Text(doc["${Getcurrentuser.selectlang}"]['Book_name']),
                                    Text(doc.get('Book_Name')),
                                    Text(doc.get('Book_Name')),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            
                                          },
                                          icon: const Icon(Icons.favorite,
                                              color: Colors.red),
                                          
                                        ),
                                        IconButton(
                                          onPressed: () {
                                           

                                           Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp456(vidurl: doc.get('Video_Link'))));
                                         
                                         
                                          },
                                          icon: const Icon(
                                              Icons.audiotrack_rounded,
                                              color: Colors.purple),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            var urllan = doc.get('Video_Link');
                                            tempurl = Uri.parse(urllan);

                                            _launchUrl(tempurl);
                                          },
                                          icon: const Icon(
                                            FontAwesomeIcons.youtube,
                                            color: Color.fromARGB(
                                                255, 172, 48, 48),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            var urllan = doc.get('Blog_Link');
                                            tempurl = Uri.parse(urllan);

                                            _launchUrl(tempurl);
                                          },
                                          icon: const Icon(
                                              Icons.language_rounded,
                                              color: Colors.black26),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          // child: ListTile(
                          //   title: Text(doc.get('Book_Name')),
                          //   onTap: () {
                          //     var urllan = doc.get('Blog_Link');
                          //     tempurl = Uri.parse(urllan);

                          //     _launchUrl(tempurl);
                          //   },
                          // ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}