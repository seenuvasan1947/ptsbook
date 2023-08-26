// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../components/provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_email_sender/flutter_email_sender.dart';
class AdminBookAddPage extends StatefulWidget {

  const AdminBookAddPage({super.key});
  @override
  _AdminBookAddPageState createState() => _AdminBookAddPageState();
}

class _AdminBookAddPageState extends State<AdminBookAddPage> {
  final firestore = FirebaseFirestore.instance;

  // final lanList=
  List genre_item = [''];
  var admin_selected_genre = '';
  List langList = ['en-IN', 'ml-IN','ta-IN'];
  TextEditingController bookNameController = TextEditingController();
  TextEditingController bookIdController = TextEditingController();
  TextEditingController rootlinkController = TextEditingController();
   TextEditingController imagelinkController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  TextEditingController Bookauthor = TextEditingController();
   TextEditingController mail_text_file_url = TextEditingController();

  bool isConverted = false;
  bool ispublishedBook = false;
  bool isFreeBook = false;
  String mail_body='';
  
   int no_of_ep=0;
   
   final db = FirebaseFirestore.instance;
  // Map<String, String> bookDetails = {
  //   'Book_name': '',
  //   'author_name': '',
  //   'Book_lang': '',
  //   'Text_File': '',
  //   'Audio_File': '',
  // };

  @override
  void initState() {
    super.initState();
    // bookDetails.add({
    //   'book_name': '',
    //   'author_name': '',
    //   'book_lang': '',
    //   'text_file': '',
    //   'audio_file': '',
    // });
    context.read<Getcurrentuser>().getgenerlist();
    // context.read<Getcurrentuser>().getcontentlanglist();
    // getfirebasedata();
  }

  Future<void> getfirebasedata() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('metadata');

    DocumentSnapshot snapshot = await collection.doc('genres').get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    if (data != null && data.containsKey('book_genres')) {

      List<dynamic> arrayData = data['book_genres'];
      genre_item=arrayData;
    } else {
      // genre_item = ['a'];
    }
  }

// List item=['a','b'];
// List langList = ['en-IN', 'ml-IN','ta-IN'];
  // List<DropdownMenuItem<String>> buildDropdownMenuItems() {
  //   return genre_item.map<DropdownMenuItem<String>>((var value) {
  //     return DropdownMenuItem<String>(
  //       value: value,
  //       child: Text(value),
  //     );
  //   }).toList();
  // }
Future<void> mailsend(String file_url) async {

final resp = await http.get(Uri.parse(file_url));

mail_body=resp.body;


     QuerySnapshot user_list_snap = await db
        .collection('users')
        
        .get();

 final List<String> user_list = user_list_snap.docs
        .map((doc) => doc['email'] as String)
        .toList();
    var recMail = user_list;
    final Email email = Email(
      body: mail_body,
      subject: '<book name>book added',
      recipients: recMail,
      isHTML: false,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      print(error);
      platformResponse = error.toString();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  


}
  @override
  Widget build(BuildContext context) {
    return Consumer<Getcurrentuser>(builder: ((context,Getcurrentuser,child)=>Scaffold(
      appBar: AppBar(
        title: const Text('Add book'),
      ),
      body: RefreshIndicator(
        onRefresh: getfirebasedata,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: bookNameController,
                decoration: InputDecoration(
                  labelText: 'Book Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
              ),
              
              TextField(
                controller: Bookauthor,
                decoration: InputDecoration(
                  labelText: 'Author Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
              ),
              
              TextField(
                controller: bookIdController,
                decoration: InputDecoration(
                  labelText: 'Book ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
              ),
              
              TextField(
                controller: rootlinkController,
                decoration: InputDecoration(
                  labelText: 'Book Root link',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
              ),
              TextField(
                controller: imagelinkController,
                decoration: InputDecoration(
                  labelText: 'Book image link',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
              ),
               TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'No of episode',
                  
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
                onChanged: (value) {
                no_of_ep = int.parse(value);
              },
              ),
              
              // DropdownButtonFormField(
              //   items: buildDropdownMenuItems(),
              //   hint: Text('gener'),
              //   onChanged: (value) {
              //     setState(() {
              //       admin_selected_genre = value!;
              //     });
              //   },
              // ),
              ExpansionTile(
                title: Text('gener'),
                children: [
                  ListView.builder(
                      itemBuilder: (context, Index) {
                        return ListTile(
                          splashColor: Colors.cyan,
                          selectedColor: Colors.deepPurple,
                          onTap: () async {
                           admin_selected_genre=Getcurrentuser.GenerList[Index];
                            ExpansionTileController.of(context)
                                                .collapse();
                                           
                          },
                          title: Text(
                              Getcurrentuser.GenerList[Index]),
                          
                        );
                      },
                      itemCount:
                          Getcurrentuser.GenerList.length,
                      shrinkWrap: true),
                ],
              ),
              
              const Text('is free book'),
              Checkbox(
                value: isFreeBook,
                onChanged: (value) {
                  setState(() {
                    isFreeBook = value!;
                  });
                },
              ),

              const Text('is published'),
              Checkbox(
                value: ispublishedBook,
                onChanged: (value) {
                  setState(() {
                    ispublishedBook = value!;
                  });
                },
              ),
              ElevatedButton(
                child: const Text('Submit'),
                onPressed: () async {
                  await firestore
                      .collection('our_books')
                      .doc(bookNameController.text)
                      .set({
                    'Book_Name': bookNameController.text,
                    'Author_name': Bookauthor.text,
                    'Book_id': bookIdController.text,
                    // 'Video_Link': videoLinkController.text,
                    'gener': admin_selected_genre,
                    'is_converted': false,
                    'is_published': ispublishedBook,
                    'no_of_episode':no_of_ep,
                    'root_path':rootlinkController.text,
                    'image_url': imagelinkController.text,
                    'added_on': DateTime.now(),
                    'free_book': isFreeBook,
                    // 'Blog_Link':'',

                  });
                //   for (var i = 0;
                //       i < Getcurrentuser.contentlangList.length;
                //       i++) {
                //     await firestore
                //         .collection('our_books')
                //         .doc(bookNameController.text)
                //         .update({
                //       '${Getcurrentuser.contentlangList[i]}': bookDetails,
                //     });
                //     print('out loop ${i}');
                //   }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('book added ${bookNameController.text}'),
                    ),
                  );


showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('send notification'),
                    content: const Text('send notification to user'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          // Close the dialog
                          Navigator.of(context).pop();
                        },
                        child:Column(
                          children: [
                            TextField(
                controller: mail_text_file_url,
                decoration: InputDecoration(
                  labelText: 'enter file url',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
              ),
              ElevatedButton(onPressed: (){

                mailsend(mail_text_file_url.text);
              }, child: const Text('send'))
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );

                },
              )
            ],
          ),
        ),
      ),
    )));
  }
}


