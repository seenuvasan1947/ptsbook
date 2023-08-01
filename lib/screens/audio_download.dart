// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';

// class AudioDownloader extends StatefulWidget {
//   final String audioUrl;

//   AudioDownloader({required this.audioUrl});

//   @override
//   _AudioDownloaderState createState() => _AudioDownloaderState();
// }

// class _AudioDownloaderState extends State<AudioDownloader> {
//   String? _downloadedFilePath;

//   Future<void> _downloadAudio() async {
//     final url = Uri.parse(widget.audioUrl);
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final directory = await getExternalStorageDirectory();
//       // final file = File('${directory!.path}/Music/ptsbook/audio.mp3');

//       Directory filedir = Directory('/storage/emulated/0/Music/ptsbook');
//       if (!(await filedir.exists())) {
//         await filedir.create(recursive: true);
//         print('Directory created at $filedir');
//       } else {
//         print('Directory already exists at $filedir');
//       }

//       final file = File('/storage/emulated/0/Music/ptsbook/audio.mp3');
//       await file.writeAsBytes(response.bodyBytes);
//       setState(() {
//         _downloadedFilePath = file.path;
//       });
//       print('sucessssssssss');
//       Fluttertoast.showToast(
//         msg: 'you audio downloaded at $_downloadedFilePath',
//         toastLength: Toast.LENGTH_LONG,
//         backgroundColor: Color.fromARGB(255, 109, 96, 169),
//         textColor: const Color.fromARGB(255, 15, 0, 0),
//         gravity: ToastGravity.CENTER,
//         fontSize: 20.0,
//       );
//     } else {
//       throw Exception('Failed to download audio');
      
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Audio Downloader'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: _downloadAudio,
//               child: Text('Download Audio'),
//             ),
//             if (_downloadedFilePath != null)
//               Text('Audio downloaded at: $_downloadedFilePath'),
//           ],
//         ),
//       ),
//     );
//   }
// }
