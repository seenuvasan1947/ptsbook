// import 'dart:js_interop';

// ignore_for_file: await_only_futures, unnecessary_string_interpolations, unnecessary_brace_in_string_interps

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/functions/aditional_function_lang.dart';
import '../../../components/functions/audio_downlode_function.dart';
import '../../../components/functions/operational_function.dart';
import '../../../components/language/data/lang_data.dart';
import '../../../components/provider.dart';
import 'book_text_read_page.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class audplayer extends StatefulWidget {
  String rooturl = '';
  String imageurl = '';
  String bookname = '';
  int number_of_epi = 0;
  audplayer(
      {super.key,
      required String this.rooturl,
      required String this.imageurl,
      required String this.bookname,
      required int this.number_of_epi});
  @override
  _audplayerState createState() => _audplayerState();
}

class _audplayerState extends State<audplayer> {
  late AudioPlayer _player;
  FlutterTts flutterTts = FlutterTts();

  bool isPlaying = false;
  var downloaded_file_name = '';
  bool is_dowloading = false;

  // String crnt_content_lang = '';
  String text = '';
  String text_for_len_cnt = '';
 
  late List<bool> isPlayingList;
 

  @override
  void initState() {
    super.initState();
    context.read<LangPropHandler>().getprop_selectedcontentlang();
    getContentLang();
    isPlayingList = List.generate(widget.number_of_epi, (index) => false);
    _player = AudioPlayer();
    // _calculateEstimatedDuration();
    _player.onAudioPositionChanged.listen((position) {
      // if (mounted) {
      //   setState(() {
      //     _position = position;
      //   });
      // }

      setState(() {
      });
    });
    _player.onDurationChanged.listen((duration) {
      // if (mounted) {
      //   setState(() {
      //     _duration = duration;
      //   });
      // }

      setState(() {
      });
    });
    // setplayerstate();
    // _checkPermissionStatus();
    // requestPermission();
  }

  // Future<void> _checkPermissionStatus() async {
  //   final permissionStatus = await Permission.manageExternalStorage.status;
  //   setState(() {
  //     _hasPermission = permissionStatus.isGranted;
  //   });
  // }


  
  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  // void audioplay(String textUrl) async {
  //   http.Response response = await http.get(Uri.parse(textUrl));
  //   text = response.body;
  //   print(text);
  //   if (text.isNotEmpty) {
  //     ttspropset();

  //     await flutterTts.speak(text);
  //   }
  // }


int getNextEpisodeIndex() {
  int currentIndex = isPlayingList.indexOf(true);

  setState(() {
    isPlayingList[currentIndex] = !isPlayingList[currentIndex];
     isPlayingList[currentIndex+1] = !isPlayingList[currentIndex+1];
  });
  if (currentIndex != -1 && currentIndex + 1 < isPlayingList.length) {
    return currentIndex + 1;
  }
  
  return -1;
}

void playEpisode(int index) async {
  String crnt_content_lang=await getContentLang();
  String fullUrl = "${widget.rooturl}${crnt_content_lang}/${index + 1}.txt";

  await audioplay(fullUrl);

}

 audioplay(String textUrl) async {
  http.Response response = await http.get(Uri.parse(textUrl));
  text = response.body;
  print(text);
  if (text.isNotEmpty) {
   await ttspropset();

    await flutterTts.speak(text);
    flutterTts.setCompletionHandler(() {
    int nextIndex = getNextEpisodeIndex();
    if (nextIndex != -1) {
      playEpisode(nextIndex);
    }
  });
  }
}
  // void playAudioFromUrl(String audioUrl) async {
  //   await _player.setUrl(audioUrl);
  //   _player.play(audioUrl);
  //   isPlaying = true;
  // }



  @override
  Widget build(BuildContext context) {
    // bool isPlaying = false;
    // setplayerstate();
    // print('sample');
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.bookname),
          leading: IconButton(
              onPressed: () {
                flutterTts.stop();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_rounded)),
        ),
        body: Center(
          child: Column(
            children: [
              //         Container(
              //               height: MediaQuery.sizeOf(context).height*0.5,
              //               width: MediaQuery.sizeOf(context).width*0.8,
              //   decoration: const BoxDecoration(
              //     gradient: LinearGradient(
              //       colors: [Color.fromARGB(255, 107, 188, 80), Color.fromARGB(255, 35, 56, 125),Colors.purple],
              //       begin: Alignment.topCenter,
              //       end: Alignment.bottomCenter,
              //       stops: [0.0,0.6,1.7]
              //     ),
              //   ),
              // ),

              // ListView.builder(
              //   itemCount: 2,
              //   itemBuilder: (BuildContext context, int index) {
              //     return ListTile(trailing: Row(children: [Text('data'),Text('data')]),);
              //   },
              // ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.05,
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.26,
                width: MediaQuery.sizeOf(context).width * 0.85,

                // child: Image.asset('assets/splashscreen.png')
                child: Image.network(widget.imageurl),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
              ),
              Divider(
                color: Colors.deepPurpleAccent,
              ),

              // Expanded(
              //   child: ListView.builder(
              //                 itemCount: 2,
              //                 itemBuilder: (BuildContext context, int index) {
              //                   return ListTile(trailing: Text("${index}"));
              //                 },
              //               ),
              // ),

              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.number_of_epi,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding:
                          const EdgeInsetsDirectional.symmetric(vertical: 2),
                      margin: EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(15.0),
                            bottom: Radius.circular(15.0)),
                        gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 107, 188, 80),
                              Color.fromARGB(255, 35, 56, 125),
                              Colors.purple
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.0, 0.6, 1.7]),
                      ),
                      child: Column(
                        children: [
                          Text('Episode'),
                          Text("${index + 1}"),
                          Divider(
                            color: Colors.deepPurpleAccent,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  icon: Icon(isPlayingList[index]
                                      ? Icons.pause
                                      : Icons.play_arrow),
                                  onPressed: () async {
                                    String crnt_content_lang=await getContentLang();
                                    String fullUrl =
                                        "${widget.rooturl}$crnt_content_lang/${index + 1}.txt";
                                    if (isPlayingList[index]) {
                                      // _player.pause();
                                      flutterTts.pause();
                                    } else {
                                      print(fullUrl);
                                      // audioplay(fullUrl);
                                      playEpisode(index);
                                    }

                                    setState(() {
                                      isPlayingList[index] =
                                          !isPlayingList[index];
                                    });
                                  },
                                ),
                                IconButton(
                                  onPressed: () async {
                                    String crnt_content_lang=await getContentLang();
                                    String fullUrl =
                                        "${widget.rooturl}$crnt_content_lang/${index + 1}.txt";
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => book_read(
                                                book_text_file: fullUrl,
                                                book_name: widget.bookname)));
                                  },
                                  icon: const Icon(Icons.menu_book,
                                      color: Colors.black),
                                ),
                                IconButton(
                                    onPressed: ()async  {
                                      String crnt_content_lang=await getContentLang();
                                     
                                      String fullUrl =
                                          "${widget.rooturl}$crnt_content_lang/${index + 1}.txt";
                                      downloadAudio(fullUrl, index,widget.bookname);
                                    },
                                    icon: const Icon(Icons.download)),
                               
                              ]),
                        ],
                      ),
                    );
                  },
                ),
              )

                        ],
          ),
        ),
      ),
    );
  }
}
