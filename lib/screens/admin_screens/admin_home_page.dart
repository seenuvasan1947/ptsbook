import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'admin_book_add.dart';
import 'audio_create.dart';
import 'data/lang_data.dart';
import 'lang_store.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

final TextEditingController emailController = TextEditingController();

class _AdminHomeState extends State<AdminHome> {
  void addAdmin(String email) {
    FirebaseFirestore.instance
        .collection('metadata')
        .doc('accessible_user')
        .update({
      'admin': FieldValue.arrayUnion([email])
    });
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
              ElevatedButton(
                onPressed: () {
                  String email = emailController.text.trim();
                  if (email.isNotEmpty) {
                    addAdmin(email);
                    emailController.clear();
                  }
                },
                child: const Text('Add'),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
