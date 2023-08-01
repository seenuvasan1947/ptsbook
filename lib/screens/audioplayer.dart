// import 'dart:js_interop';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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

        backgroundColor: Color.fromARGB(255, 109, 96, 169),
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
              icon: Icon(Icons.arrow_back_rounded)),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox.square(
                                    dimension: 500,
                                    // child: Image.asset('assets/book.jpeg')
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
                      icon: Icon(Icons.replay_10),
                      onPressed: () {
                        _player.seek(_position - Duration(seconds: 10));
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
                      icon: Icon(Icons.forward_10_rounded),
                      onPressed: () {
                        _player.seek(_position + Duration(seconds: 10));
                      },
                    ),
                    IconButton(onPressed: (){
        downloadAudio();
                    }, icon: Icon(Icons.download))
                    
                  ],
                ),
        
        is_dowloading==true?Text('downloading started'):Text(''),
        
                Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _duration.toString().substring(0, 7),
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
