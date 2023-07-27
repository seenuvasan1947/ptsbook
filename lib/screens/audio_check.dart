import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_caption_scraper/youtube_caption_scraper.dart';

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import '../components/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

String cap = 'a';
String response_trans = 'b';
final chunks = <String>[];
List<File> inputAudioFiles = [];
int audcount = 0;
int audcomcount = 0;
 final db = FirebaseFirestore.instance;
//  File _videoFile =File('');
//  List<File> audiopath=[];
var files='';
var _videoFile='';
 String _outputPath='';

class audcheck extends StatefulWidget {
  const audcheck({super.key});

  @override
  State<audcheck> createState() => _audcheckState();
}

class _audcheckState extends State<audcheck> {

  String audioFilePath = '';
  var map = '';
  FlutterTts flutterTts = FlutterTts();
 
  // FlutterFFmpeg flutterFFmpeg = FlutterFFmpeg();



   List<File> images = [];
  late File audio;
    final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  @override
  void initState() {
    super.initState();
    context.read<Getcurrentuser>().getcontentlanglist();
    // getcap();
    //  vidcr();
    // addAudioToVideo();
    // _pickVideo();
  }
Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
dialogTitle: "video",
      allowedExtensions: ['mp4'],
    );

    if (result != null) {
 _videoFile=result.files.single.path!;
 print(_videoFile);
      // setState(() {
      //   _videoFile = File(result.files.single.path!);
      //   print(_videoFile);
      // });
    }
  }

  Future<void> _pickaudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
allowMultiple: true,
dialogTitle: "audio",
      allowedExtensions: ['mp3'],
    );

    if (result != null) {
       files=result.files.single.path!;
      //  List<File> files = result.files.cast<File>();
      // var files=File (result.files.single.path!);
      //  audiopath.add(files as File);
      //  print(audiopath);
       print(files);
      // setState(() {
      //   a = File(result.files.single.path!);
      // });
    }
  }

Future<void> addAudioToVideo() async {
    // Add the generated audio file (tamil.mp3) to the original video (sample.mkv)
    // using your preferred method
    // Replace this with your own code to add the audio file to the video

    // Example code using FFmpeg (make sure to add ffmpeg dependency to pubspec.yaml)
    final directory = await getExternalStorageDirectory();
    // final videoPath = '${directory!.path}/sample.mkv';
    // final audioPath = '${directory.path}/tamil.mp3';
    final outputPath = '${directory!.path}/sample_with_audio.mp4';
  //   final videoPath='/storage/emulated/0/ptsbook/Vid/Sample.mp4';
  //   final audioPath='/storage/emulated/0/ptsbook/audio/audio1.mp3';

  //   final aupatlist=['/storage/emulated/0/ptsbook/audio/audio1.mp3','/storage/emulated/0/ptsbook/audio/audio2.mp3'];
    
  //   final outputPath='/storage/emulated/0/ptsbook/Vid/op.mp4';
  //   var permissionStatus = await Permission.manageExternalStorage.status;
  //   if (permissionStatus != PermissionStatus.granted) {
  //     Map<Permission, PermissionStatus> statuses =
  //       await [Permission.storage,
  //        Permission.phone,
  //         Permission.sms,
  //         ].request();
  //   // await Permission.manageExternalStorage.request();
  // }
  // else if(permissionStatus==PermissionStatus.granted){
  //   print('sucess');
  //   // await Process.run('ffmpeg', ['-i', videoPath, '-i', audioPath, '-c', 'copy', '-map', '0', '-map', '1', '-shortest', outputPath]);
  // }
    // if(await Permission.manageExternalStorage.isGranted)
    // {
    //   await Process.run('ffmpeg', ['-i', videoPath, '-i', audioPath, '-c', 'copy', '-map', '0', '-map', '1', '-shortest', outputPath]);
    // }
    // else {
    //   Permission.manageExternalStorage.request();
    // }

    await Process.run('ffmpeg', ['-i', _videoFile, '-i', files, '-c', 'copy', '-map', '0', '-map', '1', '-shortest', outputPath]);
  }


void vidcr() async{
images = Directory('/storage/emulated/0/ptsbook/images').listSync().cast<File>();
final imagesFolder = "/storage/emulated/0/ptsbook/images";
    final audioFile = "/storage/emulated/0/ptsbook/audios/audio.mp3";
    final outputDirectory = await getTemporaryDirectory();
    final outputVideo = "${outputDirectory.path}/output_video.mp4";

    final List<String> imagePaths = await Directory(imagesFolder)
        .list()
        .where((element) => element.path.endsWith('.jpg'))
        .map((e) => e.path)
        .toList();

print(imagePaths.length);

}





  Future<void> getcap() async {


var text='''

Империя Великих Моголов была мусульманской династией, 
правившей большей частью Индийского субконтинента с начала 16 до середины 18 веков. эта империя была основана в 1526 году Бабуром,

 ''';
    // await flutterTts.setSpeechRate(0.35);
    await flutterTts.setSpeechRate(0.25);
    await flutterTts.setPitch(1.1);

var lang_code='ru-RU';
List lang_voice=
[
  'ru-ru-x-rue-local'
 

  
  ];

// await flutterTts.setLanguage('ta-IN');
    await flutterTts.setLanguage(lang_code);

  await flutterTts.setVoice({"name": lang_voice[0], "locale": lang_code});
    await flutterTts.speak(text);

// }

  
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: ((context,Getcurrentuser,child)=>Scaffold(
      appBar: AppBar(title: Text('data')),
      body: RefreshIndicator(
        onRefresh: getcap,
        child: SingleChildScrollView(
          // child:cap=='a'? CircularProgressIndicator(): Column(
          child: Column(
            children: [

              ElevatedButton(
                  onPressed: () async {
                    // await getcap();
                    await _pickVideo();
                    //                     await flutterTts.setLanguage(crntlang);
                    //   // await flutterTts.play(audioFilePath);
                    //  await flutterTts.speak(cap);
                  },
                  child: Text('vid')),

 ElevatedButton(
                  onPressed: () async {
                    // await getcap();
                    await _pickaudio();
                    //                     await flutterTts.setLanguage(crntlang);
                    //   // await flutterTts.play(audioFilePath);
                    //  await flutterTts.speak(cap);
                  },
                  child: Text('aud')),

ElevatedButton(
                  onPressed: () async {
                    // await getcap();
                    await addAudioToVideo();
                    //                     await flutterTts.setLanguage(crntlang);
                    //   // await flutterTts.play(audioFilePath);
                    //  await flutterTts.speak(cap);
                  },
                  child: Text('add')),

// Text(audcount as String),

              Text('${audcount}'),
              Text('${audcomcount}'),
            ],
          ),
        ),
      ),
    )));
  }
}
