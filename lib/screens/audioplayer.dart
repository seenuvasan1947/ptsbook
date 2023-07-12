// import 'dart:js_interop';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp456 extends StatefulWidget {
  String vidurl = '';
  MyApp456({super.key, required String this.vidurl});
  @override
  _MyApp456State createState() => _MyApp456State();
}

class _MyApp456State extends State<MyApp456> {
  late AudioPlayer _player;

  String _url = "https://samplelib.com/lib/preview/mp3/sample-15s.mp3";
  bool isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

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
    final videoUrl = widget.vidurl;
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
    // print('1111');
    // print(video);
    // print('========');
    final streamManifest = await yt.videos.streamsClient.getManifest(video.id);
    // final strm=await yt.videos.closedCaptions.getManifest(videoUrl);

    // final strtam= strm.getByLanguage('en');

    // var tamtam=yt.videos.closedCaptions.get(strtam[0]);
    // print('22222');
    // // print(strtam);
    // print('33333');
    // // print(tamtam);
    // print('44444');
    // print(streamManifest);
    // print('========');
    final audioStreams = streamManifest.audioOnly;
    // print(audioStreams);
    // print('========');
    final audioStreamInfo = audioStreams.first;
    // print(audioStreamInfo);
    // print('========');
    // print(audioStreamInfo.url);

    yt.close();

    return audioStreamInfo.url.toString();
  }

  void playAudioFromUrl(String audioUrl) async {
    await _player.setUrl(audioUrl);
    _player.play(audioUrl);
    isPlaying = true;
  }

//   void setplayerstate() async{
// int count=0;
// if(count==0){
//     final prefs = await SharedPreferences.getInstance();
//               // await prefs.setBool('isPlaying', isPlaying);
//               bool? isPlay = await prefs.getBool('isPlaying');
//               print('***676****');
//               print(isPlay);
//               isPlaying=isPlay! as bool;
//               print('^^^^^^^^');
//               print(isPlaying);
//               count=count+1;
//                }
//               count=0;
//   }

  @override
  Widget build(BuildContext context) {
    // bool isPlaying = false;
    // setplayerstate();
    // print('sample');
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("book name"),
          leading: IconButton(
              onPressed: () {
                _player.stop();
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_rounded)),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ProgressBar(
                  progress: Duration(seconds: _position.inSeconds),
                  buffered: Duration(seconds: _position.inSeconds + 15),
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

                      // setplayerstate();
                      //         if (mounted) {
                      //           setState(() {
                      //             isPlaying = !isPlaying;
                      //           });
                      //           final prefs = await SharedPreferences.getInstance();
                      // await prefs.setBool('isPlaying', isPlaying);
                      // bool? crnt= await prefs.getBool('isPlaying');
                      // print('*********');
                      // isPlaying=crnt!;
                      // print(crnt);
                      //         }

                      // setState(() {
                      //   isPlaying = !isPlaying;
                      // });
                      //         final prefs = await SharedPreferences.getInstance();
                      // await prefs.setBool('isPlaying', isPlaying);
                      // bool? crnt= await prefs.getBool('isPlaying');
                      // print('*********');
                      // isPlaying=crnt!;
                      // print(crnt);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.forward_10_rounded),
                    onPressed: () {
                      _player.seek(_position + Duration(seconds: 10));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _duration.toString().substring(0, 7),
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
