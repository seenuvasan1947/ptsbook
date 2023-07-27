// import 'dart:js_interop';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        body: Center(
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
                  
                ],
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
        ),
      ),
    );
  }
}
