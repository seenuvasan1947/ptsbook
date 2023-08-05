// import 'dart:js_interop';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:io';

import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class audplayer extends StatefulWidget {
  String audiourl = '';
  String imageurl = '';
  String bookname = '';
  audplayer(
      {super.key,
      required String this.audiourl,
      required String this.imageurl,
      required String this.bookname});
  @override
  _audplayerState createState() => _audplayerState();
}

class _audplayerState extends State<audplayer> {
  late AudioPlayer _player;

  
  bool isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
     String? _downloadedFilePath;
     var downloaded_file_name='';
     bool is_dowloading=false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
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
  }

  @override
  void dispose() {
    super.dispose();
    _player.stop();
  }

  void audioplay() async {
    final videoUrl = widget.audiourl;
    // final audioUrl = await getAudioStreamUrl(videoUrl);

    if (_duration.inSeconds == 0.0) {
      playAudioFromUrl(videoUrl);
      _player.setVolume(1);
    } else {
      _player.resume();
    }
  }

  void playAudioFromUrl(String audioUrl) async {
    await _player.setUrl(audioUrl);
    _player.play(audioUrl);
    isPlaying = true;
  }


 

  Future<void> downloadAudio() async {
    final url = Uri.parse(widget.audiourl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      
      // final file = File('${directory!.path}/Music/ptsbook/audio.mp3');
// ignore: use_build_context_synchronously
 setState(() {
        is_dowloading=true;
      });
Directory filedir = Directory('/storage/emulated/0/Music/ptsbook');
      if (!(await filedir.exists())) {
       await filedir.create(recursive: true);
        print('Directory created at $filedir');
      } else {
        print('Directory already exists at $filedir');
      }
downloaded_file_name=widget.bookname;
      var file=File('/storage/emulated/0/Music/ptsbook/$downloaded_file_name.mp3');
      if (file.existsSync()) {
        int index = 1;
        while (file.existsSync()) {
          downloaded_file_name = '${downloaded_file_name}($index)';
          file = File('/storage/emulated/0/Music/ptsbook/$downloaded_file_name.mp3');
          index++;
        }
      }
      await file.writeAsBytes(response.bodyBytes);
      setState(() {
        _downloadedFilePath = 'Music/ptsbook/$downloaded_file_name.mp3';
      });
      print('sucessssssssss');
        Fluttertoast.showToast(
        msg: 'you audio downloaded at $_downloadedFilePath',
        toastLength: Toast.LENGTH_LONG,

        backgroundColor: const Color.fromARGB(255, 109, 96, 169),
        textColor: const Color.fromARGB(255, 15, 0, 0),
        gravity: ToastGravity.CENTER,
        fontSize: 20.0,
        
      );
      setState(() {
        is_dowloading=false;
      });
    } else {
     setState(() {
        is_dowloading=false;
      });
      throw Exception('Failed to download audio');
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
                _player.stop();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_rounded)),
        ),
        body: Container(
          height: MediaQuery.sizeOf(context).height,
                        width: MediaQuery.sizeOf(context).width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 107, 188, 80), Color.fromARGB(255, 35, 56, 125),Colors.purple],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0,0.6,1.7]
              ),
            ),
          child: SingleChildScrollView(
            
            child: Center(
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
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height*0.35,
                    width: MediaQuery.sizeOf(context).width*0.85,
                                     
                                      
                                      // child: Image.asset('assets/splashscreen.png')
                                      child: Image.network(widget.imageurl),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(10),
                                    ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ProgressBar(
                      progress: Duration(seconds: _position.inSeconds),
                      buffered: Duration(seconds: _position.inSeconds + 5),
                      total: Duration(seconds: _duration.inSeconds),
                      onSeek: (duration) {
                        print('User selected a new time: $duration');
                        print(isPlaying);
                        _player.seek(Duration(seconds: duration.inSeconds));
                      },
                      timeLabelType: TimeLabelType.remainingTime,
                      barCapShape: BarCapShape.round,
                      barHeight: 10,
                      progressBarColor: Colors.purple[200],
                      bufferedBarColor: Colors.green[200],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.replay_10),
                        onPressed: () {
                          _player.seek(_position - const Duration(seconds: 10));
                        },
                      ),
                      IconButton(
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                        onPressed: () async {
                          if (isPlaying) {
                            _player.pause();
                          } else {
                            audioplay();
                          }
          
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.forward_10_rounded),
                        onPressed: () {
                          _player.seek(_position + const Duration(seconds: 10));
                        },
                      ),
                      IconButton(onPressed: (){
          downloadAudio();
                      }, icon: const Icon(Icons.download))
                      
                    ],
                  ),
          
          is_dowloading==true?const Text('downloading started'):const Text(''),
          
                  Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _duration.toString().substring(0, 7),
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                      
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
