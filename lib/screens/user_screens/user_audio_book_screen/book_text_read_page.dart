// ignore_for_file: camel_case_types, must_be_immutable

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/* variable  */

String cap = 'loading data';

class book_read extends StatefulWidget {
  String book_text_file = '';
  String book_name = '';
  book_read(
      {super.key,
      required String this.book_text_file,
      required this.book_name});

  @override
  State<book_read> createState() => _book_readState();
}

class _book_readState extends State<book_read> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getbook();
  }

  Future<void> getbook() async {
    final response = await http.get(Uri.parse(widget.book_text_file));
    setState(() {
      cap = response.body;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book_name),
      ),
      body: RefreshIndicator(
          onRefresh: getbook,
          child: SingleChildScrollView(
            child: Center(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                
                children: [
                  SizedBox(
                      height: MediaQuery.sizeOf(context).height,
                      width: MediaQuery.sizeOf(context).width * 0.8,
                      child: Text(cap)),
                ],
              ),
            ),
          )),
    );
  }
}
