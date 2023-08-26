// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:youtube_caption_scraper/youtube_caption_scraper.dart';

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
// import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../components/provider.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

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
  String text = '';
  FlutterTts flutterTts = FlutterTts();
  List book_text_link_list = [];
  List lang_list = [];
  List book_name_list = [];
  List voice_list = [];
  final chunkSize = 4000;
  List no_epi = [2];

  List<String> modifiedUrls = [];
  // FlutterFFmpeg flutterFFmpeg = FlutterFFmpeg();

  @override
  void initState() {
    super.initState();
    // context.read<Getcurrentuser>().getcontentlanglist();
    // getcap();
  }

  Future<void> getcap() async {
    //  QuerySnapshot lang_list_snap = await db.collection('metadata');
    QuerySnapshot text_file_list_snap = await db
        .collection('our_books')
        .where('is_converted', isEqualTo: false)
        .get();

    //  CollectionReference collection =
    //     FirebaseFirestore.instance.collection('metadata');

//  DocumentSnapshot snapshot = await db.collection('metadata').doc('content_lang').get();
//   Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
//   if (data != null && data.containsKey('lang_list') && data.containsKey('Voice_list')){
//   lang_list=data!['lang_list'];
//   voice_list=data!['Voice_list'];
//   }
    lang_list = LangData.ContentLang;
    voice_list = LangData.VoiceList;

    final List<String> urls = text_file_list_snap.docs
        .map((doc) => doc['root_path'] as String)
        .toList();
        no_epi=text_file_list_snap.docs
        .map((doc) => doc['no_of_episode'] as int)
        .toList();
    print(urls);
    // final List<String> modifiedUrls = urls
    //     .map((url) => [url + 'ap', url + 'ta'])
    //     .expand((element) => element)
    //     .toList();

    setState(() {
      this.modifiedUrls = modifiedUrls;
    });

    // book_text_link_list =text_file_list_snap.docs.map((doc) => doc["en-IN"]['Text_File']).toList();
    print('1234567987654345678987654234567');
    print(book_text_link_list);
    book_name_list =
        text_file_list_snap.docs.map((doc) => doc['Book_Name']).toList();

    Directory? dir = await getExternalStorageDirectory();

    await flutterTts.setSpeechRate(0.25);
    await flutterTts.setPitch(1);

    for (int i = 0; i < urls.length; i++) {
      for (int j = 0; j < LangData.ContentLang.length; j++) {
        Directory device_dir = Directory(path.join(
            '${dir!.path}', '${book_name_list[i]}', LangData.ContentLang[j]));
        if (!(await device_dir.exists())) {
          await device_dir.create(recursive: true);
          print('Directory created at $device_dir');
        } else {
          print('Directory already exists at $device_dir');
        }
        Directory homedir = Directory('/storage/emulated/0/Music/ptsbookadmin/${book_name_list[i]}/${LangData.ContentLang[j]}');
        if (!(await homedir.exists())) {
          await homedir.create(recursive: true);
          print('Directory created at $homedir');
        } else {
          print('Directory already exists at $homedir');
        }
        print(no_epi);
        for (int k = 0; k < no_epi.length; k++) {
          flutterTts.setLanguage(LangData.ContentLang[j]);
          await flutterTts.setVoice({
            "name": LangData.VoiceList[j],
            "locale": LangData.ContentLang[j]
          });
          String final_url = '${urls[i]}${LangData.ContentLang[j]}/${k+1}.txt';
          print(final_url);
          final resp = await http.get(Uri.parse(final_url));
          text = resp.body;
          print('+++++++');
          print(text);
          final file_path =
              '${book_name_list[i]}/${LangData.ContentLang[j]}/${k+1}.mp3';
          await flutterTts.synthesizeToFile(text, file_path);
          final file_home = File(
              '/storage/emulated/0/Music/ptsbookadmin/${book_name_list[i]}/${LangData.ContentLang[j]}/${k+1}.mp3');
          file_home.create().then((value) => null);
          File file = File('${dir.path}/${file_path}');
          var filedata = await file.readAsBytes();
          await file_home.writeAsBytes(filedata);
          flutterTts.setCompletionHandler(() {
            Fluttertoast.showToast(
              msg: 'you audio downloaded at $file_home',
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: const Color.fromARGB(255, 109, 96, 169),
              textColor: const Color.fromARGB(255, 15, 0, 0),
              gravity: ToastGravity.CENTER,
              fontSize: 20.0,
            );
          });
        }
      }
    }

    Fluttertoast.showToast(
      msg: 'you audio downloaded ',
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: const Color.fromARGB(255, 109, 96, 169),
      textColor: const Color.fromARGB(255, 15, 0, 0),
      gravity: ToastGravity.CENTER,
      fontSize: 20.0,
    );

  }



void set_prop() async{

}

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: ((context, Getcurrentuser, child) => Scaffold(
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
                              //  await flutterTts.C(cap);
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
