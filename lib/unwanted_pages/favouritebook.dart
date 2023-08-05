// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../components/provider.dart';
// import 'package:provider/provider.dart';
// import 'audioplayer.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// class favbooks extends StatefulWidget {
//   const favbooks({super.key});

//   @override
//   State<favbooks> createState() => _favbooksState();
// }

// List favbooklist = [''];

// class _favbooksState extends State<favbooks> {
//   final db = FirebaseFirestore.instance;
//   late Uri tempurl;
//   bool isfavget = false;
//   bool isfavempty = true;
//   var user = '';
//   getuser() async {
//     final prefs = await SharedPreferences.getInstance();

//     user = prefs.getString('name')!;
//   }

//   @override
//   void initState() {
//     super.initState();
//     print('inside init state');
//     getfavlistFavorites();
//      print('inside init state 2');
//   }

//   Future<void> _launchUrl(Uri tempurl) async {
//     if (!await launchUrl(tempurl, mode: LaunchMode.inAppWebView)) {
//       throw Exception('Could not launch $tempurl');
//     }
//   }

//   Future<void> getfavlistFavorites() async {
//     int count=0;
//     // final CollectionReference _booksCollection =
//     //     FirebaseFirestore.instance.collection('book');
//     final CollectionReference _userCollection =
//         FirebaseFirestore.instance.collection('users');
//     final prefs = await SharedPreferences.getInstance();

//     var user = prefs.getString('name');

//     final DocumentSnapshot favoriteDocument = await _userCollection
//         .doc(user)
//         // .collection('favorite')
//         // .doc('favuritebooks')
//         .get();

//     if (favoriteDocument.exists) {
//       favbooklist = await favoriteDocument['books'] ;
//       print(favbooklist);
//       isfavget = true;
//       isfavempty = false;
    
// if(count==0){
//   // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>favbooks()));
//   count=1;
// }


      
//     }

//   }

//   Future<void> removefromFavorites(bookid) async {
//     final CollectionReference _booksCollection =
//         FirebaseFirestore.instance.collection('book');
//     final CollectionReference _userCollection =
//         FirebaseFirestore.instance.collection('users');
//     final prefs = await SharedPreferences.getInstance();

//     var user = prefs.getString('name');

//     final DocumentSnapshot favoriteDocument = await _userCollection
//         .doc(user)
//         // .collection('favorite')
//         // .doc('favuritebooks')
//         .get();

//     if (favoriteDocument.exists) {
//       final List<dynamic> favoriteBooks = favoriteDocument['books'];
//       print(favoriteBooks);
//       if (favoriteBooks.contains(bookid) && favoriteBooks.isNotEmpty) {
//         favoriteBooks.remove(bookid);
//         await _userCollection.doc(user).update({'books': favoriteBooks});
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('book removed from favourite'),
//           ),
//         );
//         isfavempty = false;
//       } else if (favoriteBooks.isEmpty) {
//         isfavempty = true;
//       }
//     }
//   }
// /*  */
//   @override
//   Widget build(BuildContext context) {
//     var selectedBook = 'abc';
//     // getfavlistFavorites();
//     // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>favbooks()));
//     print('above scafffoled');
//     return 
    
//     Scaffold(
//       appBar: AppBar(
//         title: const Text('favurite books'),
//         actions: [IconButton(onPressed: (){
//           print('inside action');
//           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>favbooks()));
//         }, icon: Icon(Icons.refresh_rounded))],
//       ),
//       body: isfavempty == true
//           ? const Text(
//               'no favourite books',
//               style: TextStyle(fontSize: 20.0,height: 6.0),
//               textAlign: TextAlign.end,
//               textDirection: TextDirection.rtl,
//             )
//           : SingleChildScrollView(
//               child: RefreshIndicator(
                
//                 onRefresh: getfavlistFavorites,
//                 child: Center(
//                   child: Column(
//                     children: [
                      
//                       StreamBuilder<QuerySnapshot>(
//                         // stream: db
//                         //     .collection('our_books')
//                         //     .where("gener", isEqualTo: widget.lable  )

//                         //     .snapshots(),
//                         stream: selectedBook == 'abc'
//                             ? db
//                                 .collection('our_books')
//                                 // .where("gener", isEqualTo: 'education')
//                                 .where("Book_id", whereIn:favbooklist)
//                                 .snapshots()
//                             : db
//                                 .collection('our_books')
//                                 .where("Book_Name", isEqualTo: selectedBook)
//                                 .snapshots(),

//                         builder: (context, snapshot) {
//                           if (!snapshot.hasData) {
//                             return const Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           } else {
//                             return ListView(
//                               padding: const EdgeInsetsDirectional.symmetric(
//                                   vertical: 2),
//                               shrinkWrap: true,
//                               scrollDirection: Axis.vertical,
//                               children: snapshot.data!.docs.map((doc) {
//                                 // var _isFavorite;
//                                 return Card(
//                                   child: InkWell(
//                                     splashColor: Colors.pink,
//                                     child: Row(
//                                       children: [
//                                         SizedBox.square(
//                                           dimension: 110.0,
//                                           // child: Image.asset('assets/book.jpeg')
//                                           child: Image.network(
//                                               'https://github.com/seenuvasan1947/flames-app/raw/main/assets/AppIcons/playstore.png'),
//                                         ),
//                                         const Padding(
//                                           padding: EdgeInsets.all(10),
//                                         ),
//                                         Column(
//                                           children: [
//                                             Text(doc.get('Book_Name')),
//                                             Text(doc.get('Book_Name')),
//                                             Row(
//                                               children: [
//                                                 IconButton(
//                                                   onPressed: () {
//                                                     removefromFavorites(
//                                                         doc.get('Book_id'));
//                                                   },
//                                                   icon: const Icon(
//                                                       Icons.favorite,
//                                                       color: Colors.purple),
//                                                 ),
//                                                 IconButton(
//                                                   onPressed: () {
//                                                     Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                             builder: (context) =>
//                                                                 MyApp456(
//                                                                     vidurl: doc.get(
//                                                                         'Video_Link'))));
//                                                   },
//                                                   icon: const Icon(
//                                                       Icons.audiotrack_rounded,
//                                                       color: Colors.purple),
//                                                 ),
//                                                 IconButton(
//                                                   onPressed: () {
//                                                     var urllan =
//                                                         doc.get('Video_Link');
//                                                     tempurl = Uri.parse(urllan);

//                                                     _launchUrl(tempurl);
//                                                   },
//                                                   icon: const Icon(
//                                                     FontAwesomeIcons.youtube,
//                                                     color: Color.fromARGB(
//                                                         255, 172, 48, 48),
//                                                   ),
//                                                 ),
//                                                 IconButton(
//                                                   onPressed: () {
//                                                     var urllan =
//                                                         doc.get('Blog_Link');
//                                                     tempurl = Uri.parse(urllan);

//                                                     _launchUrl(tempurl);
//                                                   },
//                                                   icon: const Icon(
//                                                       Icons.language_rounded,
//                                                       color: Colors.black26),
//                                                 ),
//                                               ],
//                                             )
//                                           ],
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   // child: ListTile(
//                                   //   title: Text(doc.get('Book_Name')),
//                                   //   onTap: () {
//                                   //     var urllan = doc.get('Blog_Link');
//                                   //     tempurl = Uri.parse(urllan);

//                                   //     _launchUrl(tempurl);
//                                   //   },
//                                   // ),
//                                 );
//                               }).toList(),
//                             );
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//     );
  
//   }
// }
