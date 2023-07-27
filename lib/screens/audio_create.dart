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
import '../components/provider.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
String cap = 'a';
String response_trans = 'b';
final chunks = <String>[];
List<File> inputAudioFiles = [];
int audcount = 0;
int audcomcount = 0;
 final db = FirebaseFirestore.instance;
class AudioCreate extends StatefulWidget {
  const AudioCreate({super.key});

  @override
  State<AudioCreate> createState() => _AudioCreateState();
}

class _AudioCreateState extends State<AudioCreate> {
  final TextEditingController textController = TextEditingController();
  String crntlang = 'en'; // Default language is English
  // String videoId = 'your_video_id'; // Replace with your YouTube video ID
  String audioFilePath = '';
  var map = '';
  FlutterTts flutterTts = FlutterTts();
  List book_text_link_list=[];
  List lang_list=[];
  List book_name_list=[];
  List voice_list=[];
  // FlutterFFmpeg flutterFFmpeg = FlutterFFmpeg();


 

  
  @override
  void initState() {
    super.initState();
    context.read<Getcurrentuser>().getcontentlanglist();
    getcap();
   
  }


  Future<void> getcap() async {

    //  QuerySnapshot lang_list_snap = await db.collection('metadata');
    QuerySnapshot text_file_list_snap = await db.collection('our_books')
    .where('is_converted' ,isEqualTo: false)
    .get();
    //  CollectionReference collection =
    //     FirebaseFirestore.instance.collection('metadata');
 
 DocumentSnapshot snapshot = await db.collection('metadata').doc('content_lang').get();
  Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
  if (data != null && data.containsKey('lang_list') && data.containsKey('Voice_list')){
  lang_list=data!['lang_list'];
  voice_list=data!['Voice_list'];
  }
    // DocumentSnapshot snapshot = await collection.doc('content_lang').get();
    // Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    // if (data != null && data.containsKey('lang_list')) {
    //   List<dynamic> langData = data['lang_list'];
    //   contentlangList = langData;
    //   return langData;
    // } else {
    //   return [];
    // }
   

    book_text_link_list =text_file_list_snap.docs.map((doc) => doc["en-IN"]['Text_File']).toList();
    book_name_list=text_file_list_snap.docs.map((doc) => doc['Book_Name']).toList();

    final response = await http.get(Uri.parse(
        'https://github.com/seenuvasan1947/mybook-data/raw/main/text/rich_eng_trans.txt'));

// print(response.body);

// String utteranceID = generateUtteranceID();

    Directory? dir = await getExternalStorageDirectory();

    final myFile = File('${dir!.path}/data.txt');

    final langlistfile = File('${dir!.path}/langlist.txt');
    final voicelistfile = File('${dir!.path}/voicelist.txt');
    final enginelistfile = File('${dir!.path}/enginelist.txt');
    final tamlfile = File('${dir!.path}/tamil.txt');

    await myFile.openWrite(mode: FileMode.write);
    cap = response.body;
    // List av= Getcurrentuser.sample;

// var lang= await flutterTts.isLanguageAvailable('ta-IN');
    var voice = await flutterTts.getDefaultVoice;

// print(lang);
// print(voice);
    var langlist = await flutterTts.getLanguages;
    var voicelist = await flutterTts.getVoices;
    var enginelist = await flutterTts.getEngines;
// await flutterTts.setMaxSpeechInputLength(10000);
    Future<int?> defeng = flutterTts.getMaxSpeechInputLength.then((value) {
      print('^^^^6^^^');
      print(value!.ceil());
      print('^^^^6^^^');
    });
// print(langlist);
// print(voicelist);
    print('^^^^^^^');
    print(defeng);
    print(flutterTts.getMaxSpeechInputLength);

    await myFile.writeAsString(response.body);
// var data=langlist+""+"\n"+"new line"+vovelist.toString();
    await langlistfile.writeAsString(langlist.toString());
    await voicelistfile.writeAsString(voicelist.toString());
    await enginelistfile.writeAsString(defeng.toString());

// await flutterTts.setLanguage('ta-IN');
// await flutterTts.synthesizeToFile(response.body,'data.mp3');
    await flutterTts.setSpeechRate(0.22);
    await flutterTts.setPitch(1.1);

// await flutterTts.setLanguage('en-IN');
    await flutterTts.setLanguage('ta-IN');
// Map<String,String> voi={"name": "en-IN-language", "locale": "en-IN"};
// await flutterTts.setVoice({"name": "en-IN-language", "locale": "en-IN"});
// await flutterTts.setVoice(voi);

    // await flutterTts
    //     .setVoice({"name": "ta-in-x-tac-network", "locale": "ta-IN"});

    String text = response.body;

    var strlist = [''];


    print(strlist[0]);
// text.substring(0,4000);
// text=response.body;
    final chunkSize = 4000;
    print('++++');
    print(text.characters.length);
    print(response.body.characters.length);
    print('++++');

  
// await flutterTts.setLanguage('ta-IN');
//     // await flutterTts.setLanguage(lang_code);
// // Map<String,String> voi={"name": "en-IN-language", "locale": "en-IN"};
// await flutterTts.setVoice({"name": "ta-in-x-tac-network", "locale": "ta-IN"});
// await flutterTts.synthesizeToFile('உமா நீயும் பொன்னாங்குப்பத்தாம் குடும்பமும் ஒரு முட்டாள் பைத்தியம் ', "uma.mp3");



for(var k=0;k< book_text_link_list.length;k++){
  for(var s=0;s<lang_list.length;s++){

await flutterTts.setLanguage("${lang_list[s]}");
await flutterTts
        .setVoice({"name": "${voice_list[s]}", "locale": "${lang_list[s]}"});
  book_text_link_list =text_file_list_snap.docs.map((doc) => doc["${lang_list[s]}"]['Text_File']).toList();
final response = await http.get(Uri.parse(
        '${book_text_link_list[k]}'));

  text = response.body;
// var textlength=response.body.characters.length;
    var textlength = text.characters.length;
    if (textlength > 4000) {
      var quo = textlength ~/ 4000;
      var rem = textlength % 4000;
      var totalchunksize = quo * 4000;
      var j = 0;
      Directory filedir = Directory(path.join('${dir!.path}', book_name_list[k],'${lang_list[s]}'));
      if (!(await filedir.exists())) {
       await filedir.create(recursive: true);
        print('Directory created at $filedir');
      } else {
        print('Directory already exists at $filedir');
      }

      // if (!filedir.existsSync()) {
      //   filedir.createSync();
      // }
      for (var i = 0; i < totalchunksize; i += chunkSize) {
        j = j + 1;
        final chunk = text.substring(i, i + chunkSize);
        // Directory filedir=Directory( path.join('${dir!.path}','en'));
       
        final chunkFilePath = '${book_name_list[k]}/${lang_list[s]}/audio$j.mp3';
        // var filestore = path.join( "en",chunkFilePath);
        await flutterTts.synthesizeToFile(chunk, chunkFilePath);
        audcount = audcount+1;
        // chunks.add(chunk);
      }
      print(j);
      await flutterTts.synthesizeToFile(
          text.substring(totalchunksize - 1, textlength),
          '${book_name_list[k]}/${lang_list[s]}/audio${j + 1}.mp3');
      audcount = audcount+1;
      flutterTts.setCompletionHandler(() async {
        print('complete');

        setState(() {
          audcomcount = audcomcount + 1;
        });

      });
    } else if (textlength == 4000 || textlength < 4000) {
      await flutterTts.synthesizeToFile(text, 'audio.mp3');
    }
  }


}
//     text = response.body;
// // var textlength=response.body.characters.length;
//     var textlength = text.characters.length;
//     if (textlength > 4000) {
//       var quo = textlength ~/ 4000;
//       var rem = textlength % 4000;
//       var totalchunksize = quo * 4000;
//       var j = 0;
//       Directory filedir = Directory(path.join('${dir!.path}', 'en'));
//       if (!(await filedir.exists())) {
//         filedir.create(recursive: true);
//         print('Directory created at $filedir');
//       } else {
//         print('Directory already exists at $filedir');
//       }

//       if (!filedir.existsSync()) {
//         filedir.createSync();
//       }
//       for (var i = 0; i < totalchunksize; i += chunkSize) {
//         j = j + 1;
//         final chunk = text.substring(i, i + chunkSize);
//         // Directory filedir=Directory( path.join('${dir!.path}','en'));
       
//         final chunkFilePath = 'en/audio$j.mp3';
//         // var filestore = path.join( "en",chunkFilePath);
//         await flutterTts.synthesizeToFile(chunk, chunkFilePath);
//         // chunks.add(chunk);
//       }
//       print(j);
//       await flutterTts.synthesizeToFile(
//           text.substring(totalchunksize - 1, textlength),
//           'en/audio${j + 1}.mp3');
//       audcount = j + 1;
//       flutterTts.setCompletionHandler(() async {
//         print('complete');

//         setState(() {
//           audcomcount = audcomcount + 1;
//         });

//       });
//     } else if (textlength == 4000 || textlength < 4000) {
//       await flutterTts.synthesizeToFile(text, 'audio.mp3');
//     }

    for (var i = 0; i < strlist.length; i++) {}

    if (Platform.isAndroid) {
      String fileName = 'audio_$crntlang.mp3';
      Directory appDir = await getApplicationDocumentsDirectory();
      // Directory? appDir = await getDownloadsDirectory();
      // print(appDir);
      final locdir = await getExternalStorageDirectory();
      // print(locdir);
      var downloadDirectory = path.join(locdir!.path, "Downloads");
      // print(downloadDirectory);
      //  Directory? directory = Directory('/storage/emulated/0/Android/data/com.ptsinfotech.mybook/files/storage/emulated/0/Download/');
      //  print(directory);
      String audioDirPath = '${appDir.path}/audio';
      Directory audioDir = Directory(audioDirPath);
      // if (!directory.existsSync()) {
      //   directory.createSync();
      // }
      // String audioPath = '$audioDirPath/$fileName';
      String audioPath = path.join(audioDir.path, 'audio', fileName);
      print('123456');
      print(audioPath);

      // if (!(await audioDir.exists())) {
      //   audioDir.create(recursive: true);
      //   print('Directory created at $audioDir');
      // } else {
      //   print('Directory already exists at $audioDir');
      // }

      if (!audioDir.existsSync()) {
        audioDir.createSync();
      }
      // await flutterTts.synthesizeToFile(cap, audioPath);
      // flutterTts.
      if (mounted) {
        setState(() {
          audioFilePath = audioPath;
        });
      }
    }
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
// Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: TextFormField(
//             controller: textController,

//             minLines: 10,
//       maxLines: null, // Set maxLines to null to allow unlimited lines
//       keyboardType: TextInputType.multiline,
//       decoration: InputDecoration(
//         border: OutlineInputBorder(),
//         hintText: 'Type here...',
//       ),
//           ),
//         ),
              // Spacer(),
              ElevatedButton(
                  onPressed: () async {
                    await getcap();
                    //                     await flutterTts.setLanguage(crntlang);
                    //   // await flutterTts.play(audioFilePath);
                    //  await flutterTts.speak(cap);
                  },
                  child: Text('get')),

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
