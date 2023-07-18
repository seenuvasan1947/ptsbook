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
import 'package:provider/provider.dart';
import '../components/provider.dart';
import 'audiofromcaption.dart';
import 'audioplayer.dart';

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
print(widget.lable);
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

  void audioplay(String vidurl) async {
    final videoUrl = vidurl;
    final audioUrl = await getAudioStreamUrl(videoUrl);

    if (_duration.inSeconds == 0.0) {
      playAudioFromUrl(audioUrl);
      _player.setVolume(1);
    } else {
      _player.resume();
    }
  }

  Future<String> getAudioStreamUrl(String videoUrl) async {
    final yt = YoutubeExplode();
    final video = await yt.videos.get(videoUrl);
    print('1111');
    print(video);
    print('========');
    final streamManifest = await yt.videos.streamsClient.getManifest(video.id);
    // final strm = await yt.videos.closedCaptions.getManifest(videoUrl);

    // final strtam = strm.getByLanguage('en');

    // var tamtam = yt.videos.closedCaptions.get(strtam[0]);
    print('22222');
    // print(strtam);
    print('33333');
    // print(tamtam);
    print('44444');
    print(streamManifest);
    print('========');
    final audioStreams = streamManifest.audioOnly;
    print(audioStreams);
    print('========');
    final audioStreamInfo = audioStreams.first;
    print(audioStreamInfo);
    print('========');
    print(audioStreamInfo.url);

    yt.close();

    return audioStreamInfo.url.toString();
  }

  void playAudioFromUrl(String audioUrl) async {
    await _player.setUrl(audioUrl);
    _player.play(audioUrl);
    isPlaying = true;
  }

  // void setplayerstate() async {
  //   int count = 0;
  //   if (count == 0) {
  //     final prefs = await SharedPreferences.getInstance();
  //     // await prefs.setBool('isPlaying', isPlaying);
  //     bool? isPlay = await prefs.getBool('isPlaying');
  //     print('***676****');
  //     print(isPlay);
  //     isPlaying = isPlay! as bool;
  //     print('^^^^^^^^');
  //     print(isPlaying);
  //     count = count + 1;
  //   }
  //   count = 0;
  // }

  Future<void> fetchBookNames() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('our_books')
        .where('gener', isEqualTo: widget.lable)
        .get();

    setState(() {
      // bookNames = querySnapshot.docs.map((doc) => doc['bookname']).toList();
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

  Future<void> addToFavorites(bookid) async {
    final CollectionReference _booksCollection =
        FirebaseFirestore.instance.collection('our_books');
    final CollectionReference _userCollection =
        FirebaseFirestore.instance.collection('users');
    final prefs = await SharedPreferences.getInstance();

    var user = prefs.getString('name');

    final DocumentSnapshot favoriteDocument = await _userCollection
        .doc(user)
        // .collection('favorite')
        // .doc('favuritebooks')
        .get();
     
    if (favoriteDocument.exists) {
      final List<dynamic> favoriteBooks = favoriteDocument['books'];
      print(favoriteBooks);
      if(favoriteBooks.contains(bookid)){
        ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'allready in favrouite'),
                ),
              );
      }
      else{

      favoriteBooks.add(bookid);
      await _userCollection
          .doc(user)
          .update({'books': favoriteBooks});
      }
    } else {
      await _userCollection.doc(user).set({
        'books': [bookid]
      });
    }
  }
List arr=['abc','bcv','education'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books List'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: RefreshIndicator(
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
              
              
              StreamBuilder<QuerySnapshot>(
                // stream: db
                //     .collection('our_books')
                //     .where("gener", isEqualTo: widget.lable  )
                      
                //     .snapshots(),
                stream: selectedBook == 'abc'
                    ? db
                        .collection('our_books')
                        .where("gener", isEqualTo: widget.lable)
                        
                        // .where("gener",whereIn: List.from(arr))
                        .snapshots()
                    : db
                        .collection('our_books')
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
                        // Map<String,dynamic> lang=doc['en-IN'];
                        // var _isFavorite;
                        // print(doc['Blog_Link']);
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
                                  child: Image.network(
                                      'https://gthub.com/seenuvasan1947/flames-app/raw/main/assets/AppIcons/playstore.png'
                                      
                                      ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(10),
                                ),
                                Column(
                                  children: [
                                    Text(doc["${Getcurrentuser.selectlang}"]['Book_name']),
                                    // Text(doc["${Getcurrentuser.selectlang}"]['Text_File']),
                                    // Text(data),
                                    
                                    Text(doc.get('Book_Name')),
                                    // Text(lang['Book_name']),
                                    Row(
                                      children: [
                                        // IconButton(
                                        //   onPressed: () {
                                        //     addToFavorites(doc.get('Book_id'));
                                        //   },
                                        //   icon: const Icon(Icons.favorite,
                                        //       color: Colors.red),
                                        // ),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyApp456(
                                                            vidurl: doc.get(
                                                                'Video_Link'))));
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
              
            ],
          ),
        ),
      ),
    );
  }
}
