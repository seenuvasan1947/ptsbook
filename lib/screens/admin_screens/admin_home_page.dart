import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'admin_book_add.dart';
import 'audio_create.dart';
import '../../components/language/data/lang_data.dart';
import 'lang_store.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

final TextEditingController emailController = TextEditingController();
final TextEditingController generController = TextEditingController();
final TextEditingController code = TextEditingController();
final TextEditingController no_of_days = TextEditingController();

// String code='';
// int no_of_days=0;

class _AdminHomeState extends State<AdminHome> {
  void addAdmin(String email) {
    FirebaseFirestore.instance
        .collection('metadata')
        .doc('accessible_user')
        .update({
      'admin': FieldValue.arrayUnion([email])
    });
  }
    void addgener(String gener) {
    FirebaseFirestore.instance
        .collection('metadata')
        .doc('genres')
        .update({
      'book_genres': FieldValue.arrayUnion([gener])
    });
  }

    void addCode() {
      String codeentered = code.text;
    int noOfDays = int.tryParse(no_of_days.text) ?? 0;
DocumentReference<Map<String, dynamic>> couponDataRef =
          FirebaseFirestore.instance.collection('metadata').doc('coupon_code_data');
couponDataRef.get().then((snapshot){
 if (snapshot.exists) {
List<dynamic>? currentCodes = snapshot.data()?['coupon_code_list'];
          List<dynamic>? currentDays = snapshot.data()?['no_of_days'];

          // If the lists are null, initialize them as empty lists
          currentCodes ??= [];
          currentDays ??= [];

          // Append the new code and number of days to the lists
          currentCodes.add(codeentered);
          currentDays.add(noOfDays);

          // Update the document with the updated lists
          couponDataRef.update({
            'coupon_code_list': currentCodes,
            'no_of_days': currentDays,
            codeentered:[],
          });

 }
});
    // FirebaseFirestore.instance
    //     .collection('metadata')
    //     .doc('coupon_code_data')
    //     .update({
    //   'coupon_code_list': FieldValue.arrayUnion([codeentered]),
    //   'no_of_days':FieldValue.arrayUnion([noOfDays]),
      
    //   codeentered:[''],
      
    // });

    Fluttertoast.showToast(
          msg: 'code added $codeentered for $noOfDays',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.pink.shade200,
          textColor: Colors.black,
          gravity: ToastGravity.CENTER,
          fontSize: 20.0,
        );
        
  }

  void setLang() async{
     FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Create a document reference to the `content_lang` document.
  DocumentReference appLangRef = firestore.collection('metadata').doc('content_lang');

  appLangRef.update({'app_lang': LangData.appLang});

  DocumentReference contentLangRef = firestore.collection('metadata').doc('content_lang');

  contentLangRef.update({'lang_list': LangData.ContentLang});

    DocumentReference LangNameRef = firestore.collection('metadata').doc('content_lang');

  LangNameRef.update({'Lang_name': LangData.LangName});

    DocumentReference viocelistRef = firestore.collection('metadata').doc('content_lang');

  viocelistRef.update({'Voice_list': LangData.VoiceList});


  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lang added'),
                    ),
                  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home Page'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.2,
              ),
              Divider(
                color: Colors.purple[200],
                thickness: 3,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AudioCreate()));
                  },
                  child: const Text('Audio create')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminBookAddPage()));
                  },
                  child: const Text('Add Book')),
              // SizedBox(
              //   height: MediaQuery.sizeOf(context).height * 0.2,
              // ),
              const SizedBox(height: 16.0,),
              ElevatedButton(onPressed: (){
                setLang();
              }, child: Text('Set Lang')),
              Divider(
                color: Colors.purple[200],
                thickness: 3,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Add Admin',
                  border: OutlineInputBorder(
                    
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pinkAccent),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
               TextField(
                controller: generController,
                decoration: InputDecoration(
                  labelText: 'Add Gener',
                  border: OutlineInputBorder(
                    
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pinkAccent),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  String gener = generController.text.trim();
                  if (gener.isNotEmpty) {
                    addgener(gener);
                    generController.clear();
                  }
                },
                child: const Text('Add'),
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height*0.05,),
              ElevatedButton(
                onPressed: () {
                  showDialog(context: context, builder: (BuildContext context){
                                 return AlertDialog(
actions: [
                                                      IconButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          icon: const Icon(
                                                              Icons.close))
                                                    ],
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                              children: [
                                                                 TextField(
                                                          controller:
                                                              code,
                                                              // onChanged: (value) {
                                                              //   code=value;
                                                              // },
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'Enter code',
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0),
                                                            ),
                                                            enabledBorder:
                                                                const OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .black38),
                                                            ),
                                                            focusedBorder:
                                                                const OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .blueAccent),
                                                            ),
                                                          ),
                                                        ),
                                                         TextField(
                                                          controller:
                                                              no_of_days,

                                                              // onChanged: (value) {
                                                              //   no_of_days=value as int;
                                                              // },
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'Enter no days',
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0),
                                                            ),
                                                            enabledBorder:
                                                                const OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .black38),
                                                            ),
                                                            focusedBorder:
                                                                const OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .blueAccent),
                                                            ),
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              addCode();
                                                             
                                                              code.clear();
                                                              no_of_days.clear();
                                                              Navigator.of(context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                                'Add code'))
                                                              ],
                                                    ),
                                 );
                  });
                },
                child: const Text('Add  coupen code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
