import 'package:flutter/material.dart';
import 'package:youtube_caption_scraper/youtube_caption_scraper.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:youtube_caption_scraper/youtube_caption_scraper.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

String cap = 'a';

class audfrmcap extends StatefulWidget {
  const audfrmcap({super.key});

  @override
  State<audfrmcap> createState() => _audfrmcapState();
}

class _audfrmcapState extends State<audfrmcap> {
  String crntlang = 'en'; // Default language is English
  // String videoId = 'your_video_id'; // Replace with your YouTube video ID
  String audioFilePath = '';
var map='';
  FlutterTts flutterTts = FlutterTts();
  @override
  void initState() {
    super.initState();
    getcap();
  }

  Future<void> getcap() async {
    // var _textController = TextEditingController();
    // String videoUrl = 'https://www.youtube.com/watch?v=uDSKe3MQZOQ&t=155s';
    // final captionScraper = YouTubeCaptionScraper();
    // final captionTracks = await captionScraper.getCaptionTracks(videoUrl);
    // print(captionTracks);
    // final subtitles = await captionScraper.getSubtitles(captionTracks[0]);
    // // print(subtitles.toString());
    // print(subtitles[0].text);

    // cap = subtitles[0].text;
    // Text(subtitles[0].text);
    // for (final subtitle in subtitles) {
    //   print(
    //     '${subtitle.text}',
    //   );
    // }
//     File fr =File("assets/sample.txt");

//      if (fr.existsSync()) {
//     // The file exists.
//     print('The file exists.');
//   } else {
//     // The file does not exist.
//     print('The file does not exist.');
//   }
//    await fr.writeAsString('abc');

// // var map = await fr.readAsString();

// String text = await rootBundle.loadString("assets/sample.txt");



// String cleanCaptionText(String captionText) {
//   // Remove newlines and extra whitespaces
//   String cleanedText = captionText.replaceAll('\n', ' ').replaceAll(RegExp(' +'), ' ');

//   // Remove any special characters or symbols that may cause issues
//   // For example, if the caption contains HTML tags or timestamps, you can remove them using regex or string manipulation

//   // Example: Remove HTML tags
//   cleanedText = cleanedText.replaceAll(RegExp(r'<[^>]*>'), '');

//   return cleanedText.trim();
// }

// // Usage
// cap = cleanCaptionText(cap);






//  cap =
//         '''Some of the key takeaways from the book include the "Seven Cures 
//         for a Lean Purse," which are practical tips for managing money, 
//         such as "start thy purse to fattening" and "control thy expenditures."
//          The book also highlights the importance of taking calculated risks and 
//          investing in assets that provide a reliable return.''';



// Future<String> fetchTextFileContent() async {
//   final response = await http.get(Uri.parse('https://raw.githubusercontent.com/seenuvasan1947/flames-app/main/lib/main.dart'));
//   return response.body;
// }

// final response = await http.get(Uri.parse('https://github.com/seenuvasan1947/mybook-data/raw/main/text/richdadpoordad.txt'));

final response = await http.get(Uri.parse('https://github.com/seenuvasan1947/mybook-data/raw/main/text/richdadpoordad.txt'));



print(response.body);



// String utteranceID = generateUtteranceID();


Directory? dir = await getExternalStorageDirectory();

final myFile = File('${dir!.path}/data.txt');

final langlistfile = File('${dir!.path}/langlist.txt');
final voicelistfile = File('${dir!.path}/voicelist.txt');

await myFile.openWrite(mode: FileMode.write);
cap=response.body;


// var lang= await flutterTts.isLanguageAvailable('ta-IN');
var voice =await flutterTts.getDefaultVoice;

// print(lang);
print(voice);
var langlist=await flutterTts.getLanguages;
var voicelist=await flutterTts.getVoices;
print(langlist);
print(voicelist);
await myFile.writeAsString(response.body);
// var data=langlist+""+"\n"+"new line"+vovelist.toString();
await langlistfile.writeAsString(langlist.toString());
await voicelistfile.writeAsString(voicelist.toString());
// await flutterTts.setLanguage('ta-IN');
// await flutterTts.synthesizeToFile(response.body,'data.mp3');
await flutterTts.setSpeechRate(0.35);
await flutterTts.setPitch(1.1);
await flutterTts.setLanguage('en-IN');
//  await flutterTts.setLanguage('ta-IN');
Map<String,String> voi={"name": "en-IN-language", "locale": "en-IN"};
// await flutterTts.setVoice({"name": "en-IN-language", "locale": "en-IN"});
await flutterTts.setVoice(voi);
// await flutterTts.setVoice({"name": "ta-in-x-tac-network", "locale": "ta-IN"});
  // String text = 'வணக்கம்';
  String text =response.body;

  await flutterTts.synthesizeToFile(text, 'audio.mp3');
flutterTts.setCompletionHandler(() {

print('complete');


});

// Uri m0= Uri.https("https://docs.google.com/document/d/1AKrBMKBB4Pjd_O062LjAR_eVeCJng7OAOU0dxvHVFsg/edit?usp=sharing");

// var m2 =await File.fromUri(m0);
//  map = await myFile.readAsStringSync();


// try{
// if(cap!='a'){

  
//   await myFile.writeAsString(cap);

//   await flutterTts.synthesizeToFile(cap,'data.mp3').then((value) {

//     print('reann');
//   });
//   print(' updated upto here');
// }
// else{
//   print('not updated upto here');
// }}
// catch(e){
// print(e);
// }
// _textController=map as TextEditingController;

  // await flutterTts.speak(_textController as String);

print('`1234567');
// print(map);

// var map =cap;
    // var map =
    //     '''Some of the key takeaways from the book include the "Seven Cures 
    //     for a Lean Purse," which are practical tips for managing money, 
    //     such as "start thy purse to fattening" and "control thy expenditures."
    //      The book also highlights the importance of taking calculated risks and 
    //      investing in assets that provide a reliable return.''';
  
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

      if (!(await audioDir.exists())) {
        audioDir.create(recursive: true);
        print('Directory created at $audioDir');
      } else {
        print('Directory already exists at $audioDir');
      }

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

// String _formatDuration(Duration duration) {
//   return '${duration.inHours}:'
//       '${duration.inMinutes.remainder(60)}:'
//       '${duration.inSeconds.remainder(60)}:'
//       '${duration.inMilliseconds.remainder(60)}';
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('data')),
      body: RefreshIndicator(
        onRefresh: getcap,
        child: SingleChildScrollView(
          // child:cap=='a'? CircularProgressIndicator(): Column(
          child: Column(
            children: [
              // Spacer(),
              ElevatedButton(
                  onPressed: () async {
                    //  await getcap();
                    //                     await flutterTts.setLanguage(crntlang);
                    //   // await flutterTts.play(audioFilePath);
                    //  await flutterTts.speak(cap);
                  },
                  child: Text('get')),

              Text(cap),
            ],
          ),
        ),
      ),
    );
  }
}
