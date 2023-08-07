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
import '../../components/provider.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

import '../../components/language/data/lang_data.dart';
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
     final chunkSize = 4000;
  // FlutterFFmpeg flutterFFmpeg = FlutterFFmpeg();


 

  
  @override
  void initState() {
    super.initState();
    // context.read<Getcurrentuser>().getcontentlanglist();
    getcap();
   
  }


  Future<void> getcap() async {

    //  QuerySnapshot lang_list_snap = await db.collection('metadata');
    QuerySnapshot text_file_list_snap = await db.collection('our_books')
    .where('is_converted' ,isEqualTo: false)
    .get();
    //  CollectionReference collection =
    //     FirebaseFirestore.instance.collection('metadata');
 
//  DocumentSnapshot snapshot = await db.collection('metadata').doc('content_lang').get();
//   Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
//   if (data != null && data.containsKey('lang_list') && data.containsKey('Voice_list')){
//   lang_list=data!['lang_list'];
//   voice_list=data!['Voice_list'];
//   }
    lang_list=LangData.ContentLang;
  voice_list=LangData.VoiceList;
   

    book_text_link_list =text_file_list_snap.docs.map((doc) => doc["en-IN"]['Text_File']).toList();
    print('1234567987654345678987654234567');
    print(book_text_link_list);
    book_name_list=text_file_list_snap.docs.map((doc) => doc['Book_Name']).toList();

  

    Directory? dir = await getExternalStorageDirectory();






    await flutterTts.setSpeechRate(0.25);
    await flutterTts.setPitch(1);



  

 
  


for(var k=0;k< book_text_link_list.length;k++){
  for(var s=0;s<lang_list.length;s++){

await flutterTts.setLanguage("${lang_list[s]}");
await flutterTts
        .setVoice({"name": "${voice_list[s]}", "locale": "${lang_list[s]}"});
  book_text_link_list =text_file_list_snap.docs.map((doc) => doc["${lang_list[s]}"]['Text_File']).toList();
  print('6667676767676');
  print(book_text_link_list.length);
final response = await http.get(Uri.parse(
        '${book_text_link_list[k]}'));

 String text = response.body;
// var textlength=response.body.characters.length;
    var textlength = text.characters.length;
     Directory filedir = Directory(path.join('${dir!.path}', book_name_list[k],'${lang_list[s]}'));
      if (!(await filedir.exists())) {
       await filedir.create(recursive: true);
        print('Directory created at $filedir');
      } else {
        print('Directory already exists at $filedir');
      }

    if (textlength > 4000) {
      var quo = textlength ~/ 4000;
      var rem = textlength % 4000;
      var totalchunksize = quo * 4000;
      var j = 0;
     
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

        setState(() {
              audcount = audcount+1;
        });
        flutterTts.setCompletionHandler(() async {
        print('complete');

        setState(() {
          audcomcount = audcomcount + 1;
          print(audcomcount);
        });

      });
    
       
        // chunks.add(chunk);
      }
      print(j);
      await flutterTts.synthesizeToFile(
          text.substring(totalchunksize - 1, textlength),
          '${book_name_list[k]}/${lang_list[s]}/audio${j + 1}.mp3');
      setState(() {
              audcount = audcount+1;
        });
    
      
    } else if (textlength == 4000 || textlength < 4000) {
        setState(() {
              audcount = audcount+1;
        });
    
      
      await flutterTts.synthesizeToFile(text, '${book_name_list[k]}/${lang_list[s]}/audio.mp3');
      flutterTts.setCompletionHandler(() async {
        print('complete');

        setState(() {
          audcomcount = audcomcount + 1;
          print(audcomcount);
        });

      });
    }
   
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
          child: Center(
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
      ),
    )));
  }
}
