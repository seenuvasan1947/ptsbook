// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_function_type_syntax_for_parameters, depend_on_referenced_packages

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mybook/auth/auth.dart';
import 'package:mybook/components/provider.dart';

import 'package:provider/provider.dart';
import 'package:mybook/screens/book_add_page.dart';
import 'package:mybook/screens/book_list.dart';
import 'package:mybook/screens/my_book.dart';

import 'apl.dart';

import 'audiofromcaption.dart';
import 'our_books.dart';
import 'package:restart_app/restart_app.dart';
bool heisvalid=true;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final db = FirebaseFirestore.instance;


final TextEditingController emailController = TextEditingController();

  void addAdmin(String email) {
    FirebaseFirestore.instance
        .collection('users_login')
        .doc('datas')
        .update({
      'admin_list': FieldValue.arrayUnion([email])
      
    });
  }



  @override
  initState() {
    context.read<Getcurrentuser>().getuser();
    context.read<Getcurrentuser>().getgenerlist();
    _refreshData();
    // getgenerlist();
  }
  Future<void> _refreshData() async {
    // Simulate a delay for fetching new data
    await Future.delayed(Duration(seconds: 2));

    // Generate new data or update existing data
    setState(() {
      // items = List.generate(5, (index) => 'New Item ${index + 1}');
      context.read<Getcurrentuser>().getgenerlist();
    });
  }
  Future<void> check_valid() async{
   final userDoc = await FirebaseFirestore.instance.collection('users').doc('user_id').get();
       bool isPurchased= userDoc.get('purchased') ;
        final isvalid =userDoc.get('validDate') as Timestamp;
         final validDate = isvalid.toDate();
       final now=DateTime.now();
      //  DateTime isvalid =userDoc.get('validDate') ;
      //  DateTime now=DateTime.now();
if(isPurchased==true && now.isBefore(validDate)){
heisvalid=true;
print(heisvalid);
setState(() {
  heisvalid=true;
});

}
else{
heisvalid=false;
print(heisvalid);
setState(() {
  heisvalid=false;
});

}
}
  @override
  Widget build(BuildContext context) {
    return Consumer<Getcurrentuser>(
        builder: ((context, Getcurrentuser, child) => MaterialApp(
              home: Scaffold(
                appBar: AppBar(
                  title: const Text("Welcome"),
                  centerTitle: true,
                ),
                drawer: Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      DrawerHeader(
                        // ignore: prefer_const_constructors
                        decoration: BoxDecoration(
                          color: Colors.blue,
                        ),

                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text('Welcome'),
                            SizedBox(
                              height: 20,
                            ),
                            Text('${Getcurrentuser.userName}'),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        title: const Text('add book'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const bookaddscreen()));
                        },
                      ),
                      Divider(
                        color: Colors.purple[200],
                        thickness: 3,
                      ),
                      ListTile(
                        title: const Text('My book'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const mybooklist()));
                        },
                      ),
                      Divider(
                        color: Colors.purple[200],
                        thickness: 3,
                      ),
                      ListTile(
                        title: const Text('Book List'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const booklist()));
                        },
                      ),
                      Divider(
                        color: Colors.purple[200],
                        thickness: 3,
                      ),
                      ListTile(
                        title: const Text('Logout'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                        },
                      ),
                      Divider(
                        color: Colors.purple[200],
                        thickness: 3,
                      ),

                      // RefreshIndicator(
                      //   onRefresh: _refreshData,
                      //   child: ExpansionTile(
                      //     title: Text('geners'),
                      //     children: [
                      //       ListView.builder(
                      //           itemBuilder: (context, Index) {
                      //             return ListTile(
                      //               onTap: () async {
                      //                 Navigator.push(
                      //                   context,
                      //                   MaterialPageRoute(
                      //                     builder: (context) => name(
                      //                         lable: Getcurrentuser
                      //                             .arrayDataList[Index]),
                      //                   ),
                      //                 );
                      //               },
                      //               title:
                      //                   Text(Getcurrentuser.arrayDataList[Index]),
                      //             );
                      //           },
                      //           itemCount: Getcurrentuser.arrayDataList.length,
                      //           shrinkWrap: true),
                      //     ],
                      //   ),
                      // ),
                      
                      // Divider(
                      //   color: Colors.purple[200],
                      //   thickness: 3,
                      // ),
                      
                      RefreshIndicator(
                        onRefresh: _refreshData,
                        child: ExpansionTile(
                          title: Text('books'),
                          children: [
                            ListView.builder(
                                itemBuilder: (context, Index) {
                                  return ListTile(
                                    onTap: () async {
                                   heisvalid==true ?   Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ourbooklist(
                                              lable: Getcurrentuser
                                                  .arrayDataList[Index]),
                                        ),
                                      ):showDialog(context: context, builder: (BuildContext context){
                                        return SingleChildScrollView(
                                          child: AlertDialog(
                                            actions: [
                                        IconButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            icon: const Icon(Icons.close))
                                      ],
                                      title: const Text('subscription Details'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              
                                            ],
                                      ),
                                          ),
                                        );
                                      });
                                      
              //                         ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content: Text(
              //         'please subscribe for access premium content'),
              //   ),
              // ); 
                                    },
                                    title:
                                        Text(Getcurrentuser.arrayDataList[Index]),
                                  );
                                },
                                itemCount: Getcurrentuser.arrayDataList.length,
                                shrinkWrap: true),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.purple[200],
                        thickness: 3,
                      ),
                      // ListTile(
                      //   title: const Text('Logout'),
                      //   onTap: () {
                      //     // SystemNavigator.pop();
                      //     Restart.restartApp();
                      //     // Restart.restartApp();
                      //   },
                      // ),
                    ],
                  ),

                ),
                body: SingleChildScrollView(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
            //               ElevatedButton(onPressed: (){
            //   Navigator.push(context, MaterialPageRoute(builder: (context) => audfrmcap()));
            // }, child:Text('next page')),
            // TextField(
            //   controller: emailController,
            //   decoration: InputDecoration(labelText: 'Add Admin'),
            // ),
            // SizedBox(height: 16.0),
            // ElevatedButton(
            //   onPressed: () {
            //     String email = emailController.text.trim();
            //     if (email.isNotEmpty) {
            //       addAdmin(email);
            //       emailController.clear();
            //     }
            //   },
            //   child: Text('Add'),
            // ),
                          Container(
                            // margin: EdgeInsets.only(top: 150),
                            margin: EdgeInsets.all(20),
                            height: MediaQuery.of(context).size.height / 1.2,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 250, 252, 250),
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              ),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 110.0),
                                Text('Welcome ...',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium),
                                SizedBox(height: 40.0),
                                Text(
                                    'unleash your skill, write book discription here',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium),
                                SizedBox(height: 40.0),
                                Image.asset("assets/book.jpeg"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )));
  }
}
