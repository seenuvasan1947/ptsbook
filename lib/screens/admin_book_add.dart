import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/provider.dart';
import 'package:provider/provider.dart';

class AdminBookAddPage extends StatefulWidget {
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
  TextEditingController videoLinkController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  TextEditingController Bookauthor = TextEditingController();

  bool isConverted = false;
  bool isPublished = false;
  bool isFreeBook = false;

  Map<String, String> bookDetails = {
    'Book_name': '',
    'author_name': '',
    'Book_lang': '',
    'Text_File': '',
    'Audio_File': '',
  };

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
                decoration: const InputDecoration(
                  labelText: 'Author Name',
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
                    'Video_Link': videoLinkController.text,
                    'gener': admin_selected_genre,
                    'is_converted': false,
                    'is_published': false,
                    'image_url': '',
                    'added_on': DateTime.now(),
                    'free_book': isFreeBook,
                  });
                  for (var i = 0;
                      i < Getcurrentuser.contentlangList.length;
                      i++) {
                    await firestore
                        .collection('our_books')
                        .doc(bookNameController.text)
                        .update({
                      '${Getcurrentuser.contentlangList[i]}': bookDetails,
                    });
                    print('out loop ${i}');
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('book added ${bookNameController.text}'),
                    ),
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
