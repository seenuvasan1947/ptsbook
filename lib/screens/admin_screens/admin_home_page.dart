import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../admin_book_add.dart';
import '../audio_create.dart';

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
