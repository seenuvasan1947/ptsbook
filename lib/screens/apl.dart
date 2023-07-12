import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mybook/screens/audioplayer.dart';

class name extends StatefulWidget {
  String lable = '222';
  name({super.key, required String this.lable});

  @override
  State<name> createState() => _nameState();
}

class _nameState extends State<name> {
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    print(widget.lable);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lable),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: db
                  .collection('our_books')
                  .where("gener", isEqualTo: widget.lable)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: snapshot.data!.docs.map((doc) {
                      return Card(
                        child: ListTile(
                          title: Text(doc['Book_Name']),
                          subtitle: Text(doc['Book_Name']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyApp456(
                                  vidurl: doc['Book_Link'],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
