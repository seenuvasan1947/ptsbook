// import 'dart:js_interop';

// ignore_for_file: await_only_futures

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  String? _downloadedFilePath;
  var downloaded_file_name = '';
  bool is_dowloading = false;

  String crnt_content_lang = '';
  String text = '';
  String text_for_len_cnt = '';
  bool _hasPermission = false;
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
        _position = position;
      });
    });
    _player.onDurationChanged.listen((duration) {
      // if (mounted) {
      //   setState(() {
      //     _duration = duration;
      //   });
      // }

      setState(() {
        _duration = duration;
      });
    });
    // setplayerstate();
    // _checkPermissionStatus();
    requestPermission();
  }

  // Future<void> _checkPermissionStatus() async {
  //   final permissionStatus = await Permission.manageExternalStorage.status;
  //   setState(() {
  //     _hasPermission = permissionStatus.isGranted;
  //   });
  // }

  Future<void> requestPermission() async {

final permissionStatus = await Permission.manageExternalStorage.status;
if(permissionStatus.isDenied){

final status = await Permission.manageExternalStorage.request();
    setState(() {
      _hasPermission = status.isGranted;
    });
}    
else{
  _hasPermission=permissionStatus.isGranted;
}
    
  }

  void getContentLang() async {
    final prefs = await SharedPreferences.getInstance();

    crnt_content_lang = await prefs.getString('selectlang')!;
    print('object');
    print(crnt_content_lang);

    if (crnt_content_lang == '') {
      print('*****');
      print(crnt_content_lang);
      setState(() {
        crnt_content_lang = 'ta-IN';
      });
    } else {
      setState(() {
        crnt_content_lang = crnt_content_lang;
      });

      print('@@@@@');
      print(crnt_content_lang);
    }
  }

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
  String fullUrl = "${widget.rooturl}${crnt_content_lang}/${index + 1}.txt";

  await audioplay(fullUrl);

}

 audioplay(String textUrl) async {
  http.Response response = await http.get(Uri.parse(textUrl));
  text = response.body;
  print(text);
  if (text.isNotEmpty) {
    ttspropset();

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

  void ttspropset() async {
    await flutterTts.setSpeechRate(0.25);
    await flutterTts.setPitch(1);
    await flutterTts.setLanguage(crnt_content_lang);
    print('object');
    print(crnt_content_lang);

    int cont_lang_index = LangData.ContentLang.indexOf(crnt_content_lang);

    print(LangData.VoiceList[cont_lang_index]);
    await flutterTts.setVoice({
      "name": LangData.VoiceList[cont_lang_index],
      "locale": crnt_content_lang
    });
  }

  Future<void> downloadAudio(String textUrl, int episode) async {
    requestPermission();
    // if(Permission.storage.isGranted==true){
    ttspropset();

    if (await Permission.manageExternalStorage.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.

      Fluttertoast.showToast(
        msg: 'you audio downloading please wait',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: const Color.fromARGB(255, 109, 96, 169),
        textColor: const Color.fromARGB(255, 15, 0, 0),
        gravity: ToastGravity.CENTER,
        fontSize: 20.0,
      );
      // }
      Directory? dir = await getExternalStorageDirectory();
      final url = Uri.parse(textUrl);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // final file = File('${directory!.path}/Music/ptsbook/audio.mp3');
// ignore: use_build_context_synchronously
        Directory devicefiledir =
            Directory(path.join('${dir!.path}', widget.bookname));
        if (!(await devicefiledir.exists())) {
          await devicefiledir.create(recursive: true);
          print('Directory created at $devicefiledir');
        } else {
          print('Directory already exists at $devicefiledir');
        }
        final FilePath =
            '${widget.bookname}/${widget.bookname}_${episode + 1}.mp3';
        flutterTts.synthesizeToFile(response.body, FilePath);

        Directory filedir = Directory('/storage/emulated/0/Music/ptsbook');
        if (!(await filedir.exists())) {
          await filedir.create(recursive: true);
          print('Directory created at $filedir');
        } else {
          print('Directory already exists at $filedir');
        }
        downloaded_file_name = '${widget.bookname}_${episode + 1}';
        var file_home =
            File('/storage/emulated/0/Music/ptsbook/$downloaded_file_name.mp3');
        print('0000');
        print(file_home);
        print('11111');

        File file = File('${dir.path}/${FilePath}');
        print(file);
        flutterTts.setCompletionHandler(() async {
          file_home.create().then((value) => print(value));
          //  await file.copy('$file_home');
          var filedata = await file.readAsBytes();
          await file_home.writeAsBytes(filedata);
          Fluttertoast.showToast(
            msg: 'you audio downloaded at $_downloadedFilePath',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: const Color.fromARGB(255, 109, 96, 169),
            textColor: const Color.fromARGB(255, 15, 0, 0),
            gravity: ToastGravity.CENTER,
            fontSize: 20.0,
          );
// await file_home.writeAsString(response.body);
          setState(() {
            is_dowloading = true;
          });
        });

        // file_home.copy('$file');

        // if (file_home.existsSync()) {
        //   int index = 1;
        //   while (file_home.existsSync()) {
        //     downloaded_file_name = '${downloaded_file_name}($index)';
        //     file_home = File('/storage/emulated/0/Music/ptsbook/$downloaded_file_name.mp3');
        //     index++;
        //   }
        // }

        // await file_home.writeAsBytes(response.bodyBytes);
        setState(() {
          _downloadedFilePath = 'Music/ptsbook/$downloaded_file_name.mp3';
        });
        print('sucessssssssss');
        is_dowloading == true
            ? Fluttertoast.showToast(
                msg: 'you audio downloaded at $_downloadedFilePath',
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: const Color.fromARGB(255, 109, 96, 169),
                textColor: const Color.fromARGB(255, 15, 0, 0),
                gravity: ToastGravity.CENTER,
                fontSize: 20.0,
              )
            : Text('');
        setState(() {
          is_dowloading = false;
        });
      } else {
        setState(() {
          is_dowloading = false;
        });
        throw Exception('Failed to download audio');
      }
    }
  }


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
                                  onPressed: () {
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
                                    onPressed: () {
                                      is_dowloading == true
                                          ? const Text('downloading started')
                                          : const Text('');
                                      String fullUrl =
                                          "${widget.rooturl}$crnt_content_lang/${index + 1}.txt";
                                      downloadAudio(fullUrl, index);
                                    },
                                    icon: const Icon(Icons.download)),
                               
                              ]),
                        ],
                      ),
                    );
                  },
                ),
              )

              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.9,
              //   child: ProgressBar(
              //     progress: Duration(seconds: _position.inSeconds),
              //     buffered: Duration(seconds: _position.inSeconds + 5),
              //     total: Duration(seconds: _duration.inSeconds),
              //     onSeek: (duration) {
              //       print('User selected a new time: $duration');
              //       print(isPlaying);
              //       _player.seek(Duration(seconds: duration.inSeconds));
              //     },
              //     timeLabelType: TimeLabelType.remainingTime,
              //     barCapShape: BarCapShape.round,
              //     barHeight: 10,
              //     progressBarColor: Colors.purple[200],
              //     bufferedBarColor: Colors.green[200],
              //   ),
              // ),

              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             IconButton(
              //               icon: const Icon(Icons.replay_10),
              //               onPressed: () {
              //                 _player.seek(_position - const Duration(seconds: 10));
              //               },
              //             ),
              //             IconButton(
              //               icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              //               onPressed: () async {
              //                 if (isPlaying) {
              //                   _player.pause();
              //                 } else {
              //                   audioplay();
              //                 }

              //                 setState(() {
              //                   isPlaying = !isPlaying;
              //                 });
              //               },
              //             ),
              //             IconButton(
              //               icon: const Icon(Icons.forward_10_rounded),
              //               onPressed: () {
              //                 _player.seek(_position + const Duration(seconds: 10));
              //               },
              //             ),
              //             IconButton(onPressed: (){
              // downloadAudio();
              //             }, icon: const Icon(Icons.download))

              //           ],
              //         ),

              // is_dowloading==true?const Text('downloading started'):const Text(''),

              //         Padding(
              //               padding: const EdgeInsets.all(16.0),
              //               child: Text(
              //                 _duration.toString().substring(0, 7),
              //                 style: const TextStyle(fontSize: 16.0),
              //               ),
              //             ),
            ],
          ),
        ),
      ),
    );
  }
}
