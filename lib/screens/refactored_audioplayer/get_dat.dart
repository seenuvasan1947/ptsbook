// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_mlkit_translation/google_mlkit_translation.dart';

// import 'package:syncfusion_flutter_pdf/pdf.dart';

// class GetData extends StatefulWidget {
//   const GetData({super.key});

//   @override
//   State<GetData> createState() => _GetDataState();
// }

// class _GetDataState extends State<GetData> {
//   FlutterTts _flutterTts = FlutterTts();
//   String text = '';
//  String samp='atomic%20 habits.txt';
//   // Future<String> _getRemoteFile() async {
//   //   String url =
//   //       'https://github.com/seenuvasan1947/mybook-data/edit/main/text/atomic%20%20habits.txt';
//   //   http.Response response = await http.get(Uri.parse(url));
//   //   return response.body;
//   // }

//   // void _speakText() async {
//   //   String url =
//   //       'https://github.com/seenuvasan1947/mybook-data/raw/main/text/$samp';
//   //   http.Response response = await http.get(Uri.parse(url));
//   //   text = response.body;
//   //   print(text);
//   //   // if (_text.isNotEmpty) {
//   //   //   await _flutterTts.speak(_text);
//   //   // }
//   // }






//   getRemoteFile() async {
//     String url =
//         'https://github.com/seenuvasan1947/mybook-data/raw/main/books/rich_dad_poor_dad/ta-IN/1.docx';
//     http.Response response = await http.get(Uri.parse(url));
//     return response.body;
//   }



//   void _speakText() async {
//     String url =
//         'https://github.com/seenuvasan1947/mybook-data/raw/main/text/$samp';
//     http.Response response = await http.get(Uri.parse(url));
//     text = response.body;
//     print(text);
//     // if (_text.isNotEmpty) {
//     //   await _flutterTts.speak(_text);
//     // }
//   }
// @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
    
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('data read'),
//       ),
//       body: Center(
//           child: Column(
//         children: [
//           ElevatedButton(
//               onPressed: () async {
               
// //                final TranslateLanguage sourceLanguage=TranslateLanguage.english;
// // final TranslateLanguage targetLanguage=TranslateLanguage.tamil;

// // final onDeviceTranslator = OnDeviceTranslator(sourceLanguage: sourceLanguage, targetLanguage: targetLanguage);
// // final String response = await onDeviceTranslator.translateText('happy new year').then((value) {
// //   print(value);
// //   return value;
// // });
// // print(response);






//               },
//               child: Text('press')),
//               // ElevatedButton(
//               // onPressed: () {
//               //   // _speakText();
//               //   _flutterTts.pause();
//               //   // _flutterTts.speak('text hai how are you');

//               // },
//               // child: Text('press 2')),
              
//         ],
//       )),
//     );
//   }
// }


// class ContentDisplayPage extends StatefulWidget {
//   final String pdfUrl;
//   final String imageUrl;

//   ContentDisplayPage({required this.pdfUrl, required this.imageUrl});

//   @override
//   _ContentDisplayPageState createState() => _ContentDisplayPageState();
// }

// class _ContentDisplayPageState extends State<ContentDisplayPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Content Display'),
//       ),
//       body: SfPdfViewer.network(widget.pdfUrl),
//     );
//   }
// }