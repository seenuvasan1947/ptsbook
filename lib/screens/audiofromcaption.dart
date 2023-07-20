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
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';












import 'package:ffmpeg_kit_flutter/abstract_session.dart';
import 'package:ffmpeg_kit_flutter/arch_detect.dart';
import 'package:ffmpeg_kit_flutter/chapter.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session_complete_callback.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_session.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_session_complete_callback.dart';
import 'package:ffmpeg_kit_flutter/level.dart';
import 'package:ffmpeg_kit_flutter/log.dart';
import 'package:ffmpeg_kit_flutter/log_callback.dart';
import 'package:ffmpeg_kit_flutter/log_redirection_strategy.dart';
import 'package:ffmpeg_kit_flutter/media_information.dart';
import 'package:ffmpeg_kit_flutter/media_information_json_parser.dart';
import 'package:ffmpeg_kit_flutter/media_information_session.dart';
import 'package:ffmpeg_kit_flutter/media_information_session_complete_callback.dart';
import 'package:ffmpeg_kit_flutter/packages.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:ffmpeg_kit_flutter/session.dart';
import 'package:ffmpeg_kit_flutter/session_state.dart';
import 'package:ffmpeg_kit_flutter/signal.dart';
import 'package:ffmpeg_kit_flutter/statistics.dart';
import 'package:ffmpeg_kit_flutter/statistics_callback.dart';
import 'package:ffmpeg_kit_flutter/stream_information.dart';









// import 'package:flutter_file_utils/flutter_file_utils.dart';
String cap = 'a';
String response_trans='b';
final chunks = <String>[];
List<File> inputAudioFiles = [];
int audcount=0;
int audcomcount=0;

class audfrmcap extends StatefulWidget {
  const audfrmcap({super.key});

  @override
  State<audfrmcap> createState() => _audfrmcapState();
}

class _audfrmcapState extends State<audfrmcap> {
  final TextEditingController textController = TextEditingController();
  String crntlang = 'en'; // Default language is English
  // String videoId = 'your_video_id'; // Replace with your YouTube video ID
  String audioFilePath = '';
var map='';
  FlutterTts flutterTts = FlutterTts();
  // FlutterFFmpeg flutterFFmpeg = FlutterFFmpeg();
  @override
  void initState() {
    super.initState();
    // getcap();
  }

  Future<void> getcap() async {
    
final response = await http.get(Uri.parse('https://github.com/seenuvasan1947/mybook-data/raw/main/text/rich_eng_trans.txt'));



// print(response.body);



// String utteranceID = generateUtteranceID();


Directory? dir = await getExternalStorageDirectory();


final myFile = File('${dir!.path}/data.txt');

final langlistfile = File('${dir!.path}/langlist.txt');
final voicelistfile = File('${dir!.path}/voicelist.txt');
final enginelistfile = File('${dir!.path}/enginelist.txt');
final tamlfile = File('${dir!.path}/tamil.txt');

await myFile.openWrite(mode: FileMode.write);
cap=response.body;


// var lang= await flutterTts.isLanguageAvailable('ta-IN');
var voice =await flutterTts.getDefaultVoice;

// print(lang);
// print(voice);
var langlist=await flutterTts.getLanguages;
var voicelist=await flutterTts.getVoices;
var enginelist=await flutterTts.getEngines;
// await flutterTts.setMaxSpeechInputLength(10000);
Future<int?> defeng=flutterTts.getMaxSpeechInputLength.then((value) {
  print('^^^^6^^^');
  print(value!.ceil());
  print('^^^^6^^^');
} );
// print(langlist);
// print(voicelist);
print('^^^^^^^');
print(defeng);
print(flutterTts.getMaxSpeechInputLength );

await myFile.writeAsString(response.body);
// var data=langlist+""+"\n"+"new line"+vovelist.toString();
await langlistfile.writeAsString(langlist.toString());
await voicelistfile.writeAsString(voicelist.toString());
await enginelistfile.writeAsString(defeng.toString());



// await flutterTts.setLanguage('ta-IN');
// await flutterTts.synthesizeToFile(response.body,'data.mp3');
await flutterTts.setSpeechRate(0.35);
await flutterTts.setPitch(1.1);

// await flutterTts.setLanguage('en-IN');
 await flutterTts.setLanguage('ta-IN');
// Map<String,String> voi={"name": "en-IN-language", "locale": "en-IN"};
// await flutterTts.setVoice({"name": "en-IN-language", "locale": "en-IN"});
// await flutterTts.setVoice(voi);

await flutterTts.setVoice({"name": "ta-in-x-tac-network", "locale": "ta-IN"});
// String text= response.body;
  // String text =response.body;
// final TranslateLanguage sourceLanguage = TranslateLanguage.tamil;
// final TranslateLanguage targetLanguage = TranslateLanguage.english;

// final onDeviceTranslator = OnDeviceTranslator(sourceLanguage: sourceLanguage, targetLanguage: targetLanguage);
// final String response_trans = await onDeviceTranslator.translateText(text);

// print(response_trans);
// await tamlfile.writeAsString(response_trans.toString());
// List<int> utf8EncodedText = utf8.encode(text);
//  text=utf8.decode(utf8EncodedText );
// print(utf8EncodedText);
String text = '''

ராபர்ட் கியோசாகியின் "பணக்கார அப்பா ஏழை அப்பா" என்பது நிதி 
அறிவு, பண மேலாண்மை மற்றும் முதலீடு பற்றி கற்பிக்கும் ஒரு தனிப்பட்ட நிதி புத்தகமாகும்.
 புத்தகத்தில் 10 அத்தியாயங்கள் உள்ளன, மேலும் ஒவ்வொரு அத்தியாயத்தின் சுருக்கம் கீழே உள்ளது:
 ராபர்ட் கியோசாகியின் "பணக்கார அப்பா ஏழை அப்பா" என்பது நிதி 
அறிவு, பண மேலாண்மை மற்றும் முதலீடு பற்றி கற்பிக் என்பது நிதி 
அறிவு, பண மேலாண்மை மற்றும் முதலீடு பற்றி கற்பிக்கும் ஒரு தனிப்பட்ட நிதி புத்தகமாகும்.
 புத்தகத்தில் 10 அத்தியாயங்கள் உள்ளன, மேலும் ஒவ்வொரு அத்தியாயத்தின் சுருக்கம் கீழே உள்ளது:
 ராபர்ட் கியோசாகியின் "பணக்கார அப்பா ஏழை அப்பா"
 
 
 
 ''';
 
  var strlist=[''];
// print(text.trim());
// var myline=myFile.readAsLines().then((value) {

//    strlist=value;
//    print(strlist[0]);
//   cap=strlist[1];

// });
// var myli=
// var strlist=myline.toString().split('\n');
// cap=myline;

print(strlist[0]);
// text.substring(0,4000);
// text=response.body;
final chunkSize = 4000;
print('++++');
print(text.characters.length);
print(response.body.characters.length);
print('++++');
  
text=response.body;
// var textlength=response.body.characters.length;
var textlength=text.characters.length;
if(textlength>4000){

var quo=textlength~/4000;
var rem=textlength%4000;
var totalchunksize=quo*4000;
var j=0;
Directory filedir=Directory( path.join('${dir!.path}','en'));
    if (!(await filedir.exists())) {
        filedir.create(recursive: true);
        print('Directory created at $filedir');
      } else {
        print('Directory already exists at $filedir');
      }

      if (!filedir.existsSync()) {
        filedir.createSync();
      }
 for (var i = 0; i < totalchunksize; i += chunkSize) {
  j=j+1;
    final chunk = text.substring(i, i + chunkSize);
    // Directory filedir=Directory( path.join('${dir!.path}','en'));
    // if (!(await filedir.exists())) {
    //     filedir.create(recursive: true);
    //     print('Directory created at $filedir');
    //   } else {
    //     print('Directory already exists at $filedir');
    //   }

    //   if (!filedir.existsSync()) {
    //     filedir.createSync();
    //   }
    final chunkFilePath = 'en/audio$j.mp3';
    // var filestore = path.join( "en",chunkFilePath);
    await flutterTts.synthesizeToFile(chunk, chunkFilePath);
    // chunks.add(chunk);


  }
  print(j);
  await flutterTts.synthesizeToFile(text.substring(totalchunksize-1,textlength), 'en/audio${j+1}.mp3');
  audcount=j+1;
flutterTts.setCompletionHandler(() async{

print('complete');

setState(() {
audcomcount=audcomcount+1;  
});


    File audioFileName = File('${dir!.path}/audio$audcomcount.mp3');
    inputAudioFiles.add(audioFileName);
    print(inputAudioFiles);
//       String outputAudioFileName = 'merged_audio.mp3';

//  String audioPath = path.join(dir!.path, outputAudioFileName);

//   String command = '-i "concat:${inputAudioFiles.join('|')}" -c copy $audioPath';

//   int result = await flutterFFmpeg.execute(command);
//   if (result == 0) {
//     print('Audio files merged successfully.');
//   } else {
//     print('Error merging audio files: ');
//   }



});
// flutterTts.completionHandler()
print(inputAudioFiles);
// Directory? dir = await getExternalStorageDirectory();

// print(dir);
// // final myFile = File('${dir!.path}/audio$i.mp3');


// List<File> inputAudioFiles = [];
//   for (int i = 1; i == j+1; i++) {
//     File audioFileName = File('${dir!.path}/audio$i.mp3');
//     inputAudioFiles.add(audioFileName);
//   }

//   String outputAudioFileName = 'merged_audio.mp3';

//  String audioPath = path.join(dir!.path, outputAudioFileName);

//   String command = '-i "concat:${inputAudioFiles.join('|')}" -c copy $audioPath';

//   int result = await flutterFFmpeg.execute(command);
//   if (result == 0) {
//     print('Audio files merged successfully.');
//   } else {
//     print('Error merging audio files: ');
//   }







  // for (var i = 0; i < chunks.length; i++) {
  //   final chunk = chunks[i];
  //   final chunkFilePath = '$i.mp3'; // File path for each chunk

  //   await flutterTts.synthesizeToFile(chunk, chunkFilePath);
  // }


} else if(textlength==4000||textlength<4000){
  await flutterTts.synthesizeToFile(text, 'audio.mp3');
}

// for (var i = 0; i < text.length; i += chunkSize) {
//     final chunk = text.substring(i, i + chunkSize);
//     final chunkFilePath = '$i.mp3';
//     await flutterTts.synthesizeToFile(chunk, chunkFilePath);
//     // chunks.add(chunk);


//   }

  // for (var i = 0; i < text.length; i += chunkSize) {
  //   final chunk = text.substring(i, i + chunkSize);
  //   chunks.add(chunk);


  // }

  // for (var i = 0; i < chunks.length; i++) {
  //   final chunk = chunks[i];
  //   final chunkFilePath = '$i.mp3'; // File path for each chunk

  //   await flutterTts.synthesizeToFile(chunk, chunkFilePath);
  // }
  // await flutterTts.synthesizeToFile(response.body, 'audio.mp3');

  for (var i =0 ;i<strlist.length;i++){
    // await flutterTts.synthesizeToFile(strlist[i], 'audio${i}.mp3');
  }
  // await flutterTts.speak(textController.text);


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

Future<void> mergeaud() async{
  Directory? dir = await getExternalStorageDirectory();
      String outputAudioFileName = 'merged_audio.mp3';

 String audioPath = path.join(dir!.path, outputAudioFileName);
String mp3Encoder = 'libfdk_aac';
  // String command = '-i "concat:${inputAudioFiles.join('|')}" -c copy $audioPath';
  // String command ="-i '${dir!.path}/audio1.mp3' -i '${dir!.path}/audio2.mp3' -filter_complex concat=n=2:v=0:a=1 -c:a $mp3Encoder $audioPath";

String command ="-i '${dir!.path}/audio1.mp3' -i '${dir!.path}/audio2.mp3' -filter_complex concat=n=2:v=0:a=1 -c:a $mp3Encoder $audioPath";

// await FFmpegKit.
 await FFmpegKit.execute(command).then((session) async {
  final returnCode = await session.getReturnCode();

  if (ReturnCode.isSuccess(returnCode)) {

    // SUCCESS
    print('Audio files merged successfully.');

  } else if (ReturnCode.isCancel(returnCode)) {

    // CANCEL
print('cancel merging audio files: ');

  } else {

print(returnCode);  
print(ReturnCode(1)); 
session.getAllLogsAsString().then((value) {
  print(value);
}); // ERROR
    print('Error merging audio files: ');

  }
});
  // if (result == 0) {
  //   print('Audio files merged successfully.');
  // } else {
  //   print('Error merging audio files: ');
  // }



}

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

              ElevatedButton(
                  onPressed: () async {
                     await mergeaud();
                    //                     await flutterTts.setLanguage(crntlang);
                    //   // await flutterTts.play(audioFilePath);
                    //  await flutterTts.speak(cap);
                  },
                  child: Text('merge')),
              // Text(cap),
              // Text('--------------------'),
              // Text(response_trans),
            ],
          ),
        ),
      ),
    );
  }
}
