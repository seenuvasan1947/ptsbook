// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_function_type_syntax_for_parameters, depend_on_referenced_packages

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mybook/auth/auth.dart';
import 'package:mybook/components/provider.dart';

import 'package:provider/provider.dart';
import 'package:mybook/screens/user_screens/user_book/user_books_add_page.dart';
import 'package:mybook/screens/user_screens/user_book/user_added_book_list.dart';
import 'package:mybook/screens/user_screens/user_book/login_user_added_book.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../components/language/lang_strings.dart';
import '../../../components/language/lang_strings.dart';
import '../../../components/language/multi_lang.dart';
import '../../admin_screens/admin_home_page.dart';

import '../../payment/payment_page.dart';
import '../user_audio_book_screen/our_books_list.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'lang_select_page.dart';
import 'nav_bar_home_screen.dart';


bool heisvalid = false;
bool isselected = false;
// List lang_list = ['en', 'ta', 'hi', 'ml', 'ar'];
final FlutterLocalization localization = FlutterLocalization.instance;
late StreamSubscription<List<PurchaseDetails>> _subscription;
List<ProductDetails> _products = [];
bool _isPurchased = false;
var purchased_product_id;
var purchased_product_raw_price;
var purchased_product_discription;
var purchased_product_title;
const bool kAutoConsume = true;
bool heisguest = false;

List<dynamic> code_list = [];
List<dynamic> date_for_code_list = [];
List<dynamic> user_for_code_list = [];
TextEditingController coupon_code_user_entered = TextEditingController();
// Set it to false if you don't want to auto-consume products
// bool heisvalid = false;

class HomeScreenMainPage extends StatefulWidget {
  const HomeScreenMainPage({Key? key}) : super(key: key);

  @override
  _HomeScreenMainPageState createState() => _HomeScreenMainPageState();
}

class _HomeScreenMainPageState extends State<HomeScreenMainPage> {
  final db = FirebaseFirestore.instance;
  final FlutterLocalization localization = FlutterLocalization.instance;




  @override
  initState() {
    super.initState();
    context.read<Getcurrentuser>().getuser();
    context.read<Getcurrentuser>().getgenerlist();
    context.read<Getcurrentuser>().getcontentlanglist();
    context.read<Getcurrentuser>().getselectedcontentlang();
    context.read<Getcurrentuser>().getadminlist();
    context.read<LangPropHandler>().getlangindex();
     lang_init_local().lang_init();
    localization.onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
    localization.translate(LangPropHandler.crnt_lang_code);



    _refreshData();
    // getgenerlist();
    // localization.init();
    _initializeProducts();

    // Listen for purchases updates
    _subscription = InAppPurchase.instance.purchaseStream.listen((data) {
      _handlePurchaseUpdates(data);
    });
    check_valid();
  }

void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
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

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> check_valid() async {
    final prefs = await SharedPreferences.getInstance();

    String? user = prefs.getString('name');

    if (user != 'guest@gmail.com') {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(user).get();
      print(userDoc.get('purchased'));
      if (userDoc == null || userDoc.exists == false) {
        heisvalid = false;
      } else if (userDoc.exists == true) {
        bool isPurchased = userDoc.get('purchased');
        final isvalid = userDoc.get('validDate') as Timestamp;
        final validDate = isvalid.toDate();
        final now = DateTime.now();
        //  DateTime isvalid =userDoc.get('validDate') ;
        //  DateTime now=DateTime.now();
        if (isPurchased == true && now.isBefore(validDate)) {
          heisvalid = true;
          print(heisvalid);
          setState(() {
            heisvalid = true;
          });
        } else {
          heisvalid = false;
          print(heisvalid);
          setState(() {
            heisvalid = false;
          });
        }
      }
      print('valid check');
    } else {
      heisguest = true;
    }
  }

  Future<void> setcontentlang(String selectedlang) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('selectlang', selectedlang);
    print(prefs.getString('selectlang'));
    isselected = true;
  }

  Future<void> _initializeProducts() async {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      // The store is not available, handle accordingly
      return;
    }

    // Define your product IDs for subscriptions
    const Set<String> _kProductIds = {
      '1_week_subscription',
      '1_month_subscription',
      '6_month_subscription',
      '1_year_subscription'
    };

    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(_kProductIds);

    if (response.notFoundIDs.isNotEmpty) {
      // Some product IDs were not found, handle accordingly
    }
    print('1234567890');

    /* 
    0-1 mon
    1-1 week
    2-1 year
    3-6 month
     */
    print(response.productDetails[0].rawPrice);
    print(response.productDetails[0].description);
    print(response.productDetails[0].title);
    print(response.productDetails[0].id);
    final List<ProductDetails> products = response.productDetails;

    if (mounted) {
      setState(() {
        _products = products;
        print('123456=====');
        print(products[0]);
      });
    }
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          // Purchase is pending, handle accordingly
          break;
        case PurchaseStatus.purchased:
          // Purchase was successful, verify and process the purchase
          _verifyPurchase(purchaseDetails);
          break;
        case PurchaseStatus.error:
          // Purchase failed, handle accordingly
          break;
        case PurchaseStatus.restored:
          // Purchase was restored, handle accordingly
          _verifyPurchase(purchaseDetails);
          break;
      }
    }
  }

  void _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // Verify the purchase if necessary
    if (purchaseDetails.pendingCompletePurchase) {
      await InAppPurchase.instance.completePurchase(purchaseDetails);
    }

    if (purchaseDetails.productID == '1_week_subscription') {
      // Update the Firestore document for the user
      purchase_update_firestore('1_week_subscription');
    }
    if (purchaseDetails.productID == '1_month_subscription') {
      // Update the Firestore document for the user
      purchase_update_firestore('1_month_subscription');
    }
    if (purchaseDetails.productID == '6_month_subscription') {
      // Update the Firestore document for the user
      purchase_update_firestore('6_month_subscription');
    }
    if (purchaseDetails.productID == '1_year_subscription') {
      // Update the Firestore document for the user
      purchase_update_firestore('1_year_subscription');
    }
  }

  void purchase_update_firestore(String purchased_id) async {
    int dataNo = 0;
    try {
      DateTime purchaseDate = DateTime.now();
      DocumentSnapshot us =
          await db.collection('metadata').doc('subscription_days').get();

      if (us.exists) {
        // setState(() {
        //   dataNo = us['subscription_silver'] as int;

        // });
        dataNo = us[purchased_id] as int;

        print(dataNo);
      }
      DateTime validDate = purchaseDate.add(Duration(days: dataNo));

      await db.collection('users').doc(Getcurrentuser.user).update({
        'purchased': true,
        'purchaseDate': purchaseDate,
        'validDate': validDate,
        'no_of_days': dataNo
      });

      setState(() {
        _isPurchased = true;
      });
      check_valid();
      if (_isPurchased == true) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => NavBarAtHomePage()));
      }
    } catch (e) {
      // Handle Firestore update error
    }
  }

  Future<void> _buySubscription() async {
    int index = 0;

    // print(prod);
    for (int i = 0; i < _products.length; i++) {
      if (_products[i].id == purchased_product_id &&
          _products[i].title == purchased_product_title &&
          _products[i].description == purchased_product_discription &&
          _products[i].rawPrice == purchased_product_raw_price) {
        index = i;
      }
    }
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: _products[index],
      applicationUserName:
          null, // Set it if you want to use an application-specific username
      // sandboxTesting: false, // Set it to true for testing in sandbox mode
    );

    try {
      await InAppPurchase.instance.buyNonConsumable(
        purchaseParam: purchaseParam,
        // autoConsume: kAutoConsume,
      );
    } catch (e) {
      // Handle purchase error
    }
  }

  void availCode(String code) async {
    final prefs = await SharedPreferences.getInstance();

    String? user = prefs.getString('name');
    CollectionReference collection =
        FirebaseFirestore.instance.collection('metadata');

    DocumentSnapshot snapshot = await collection.doc('coupon_code_data').get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    if (data != null &&
        data.containsKey('coupon_code_list') &&
        data.containsKey('no_of_days') &&
        data.containsKey(code)) {
      code_list = data['coupon_code_list'];
      date_for_code_list = data['no_of_days'];
      user_for_code_list = data[code];
      print(code_list);

      print(code_list.contains('seenu'));
       print(code_list.contains('swetha'));
      print(code_list.contains(code));
      print(code_list.contains('element'));

      // if (code == '' || code == null||code.isEmpty==true) {
      //   Fluttertoast.showToast(
      //     msg: 'enter code',
      //     toastLength: Toast.LENGTH_LONG,
      //     backgroundColor: Colors.pink.shade200,
      //     textColor: Colors.black,
      //     gravity: ToastGravity.CENTER,
      //     fontSize: 20.0,
      //   );
      // } else 
      
      if (heisguest == false &&
          code_list.contains(code) == true &&
          user_for_code_list.contains(user) == false) {
        FirebaseFirestore.instance
            .collection('metadata')
            .doc('coupon_code_data')
            .update({
          code: FieldValue.arrayUnion([user])
        });
        int dataNo = date_for_code_list[code_list.indexOf(code)];
        DateTime purchaseDate = DateTime.now();

        DateTime validDate = purchaseDate.add(Duration(days: dataNo));

        await db.collection('users').doc(Getcurrentuser.user).update({
          'purchased': true,
          'purchaseDate': purchaseDate,
          'validDate': validDate,
          'no_of_days': dataNo
        });
        Fluttertoast.showToast(
          msg: 'code redemed',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.pink.shade200,
          textColor: Colors.black,
          gravity: ToastGravity.CENTER,
          fontSize: 20.0,
        );
        // Navigator.pop(context);
        setState(() {
          _isPurchased = true;
        });
        check_valid();
        if (_isPurchased == true) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => NavBarAtHomePage()));
        }
      } else if (heisguest == true) {
        Fluttertoast.showToast(
          msg: 'guest user not able to avail',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.pink.shade200,
          textColor: Colors.black,
          gravity: ToastGravity.CENTER,
          fontSize: 20.0,
        );
      }  else if (user_for_code_list.contains(user) == true) {
        Fluttertoast.showToast(
          msg: 'code already redemed by you',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.pink.shade200,
          textColor: Colors.black,
          gravity: ToastGravity.CENTER,
          fontSize: 20.0,
        );
      }
      else{
        print('else    bolock');
      }
      // admin_list[admin_list.indexOf('seenu')];
    }
    else if (code_list.contains(code) == false) {
        print('swe#######');
        Fluttertoast.showToast(
          msg: 'code is not valid',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.pink.shade200,
          textColor: Colors.black,
          gravity: ToastGravity.CENTER,
          fontSize: 20.0,
        );
      }

    // if(heisguest==false&&user)
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Getcurrentuser>(
        builder: ((context, Getcurrentuser, child) => MaterialApp(
          supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
              home: Scaffold(
                
                appBar: AppBar(
                  title: Text(AppLocale.welcome.getString(context)),
                  centerTitle: true,
                  actions: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingsPage(),
                              ));
                        },
                        icon: Icon(Icons.g_translate_rounded))
                  ],
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
                            // Divider(
                            //   color: Colors.pink,
                            //   thickness: 3,
                            // ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        title: const Text('write your book'),
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
                        title: const Text('others Book List'),
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

                      // RefreshIndicator(
                      //   onRefresh: _refreshData,
                      //   child: SingleChildScrollView(
                      //     child: ExpansionTile(
                      //       title: Text('app language'),
                      //       children: [
                      //         ListView.builder(
                      //             itemBuilder: (context, Index) {
                      //               return ListTile(
                      //                 splashColor: Colors.cyan,
                      //                 selectedColor: Colors.deepPurple,
                      //                 selectedTileColor: Colors.indigoAccent,
                      //                 onTap: () async {
                      //                   // set_app_lang();
                      //                   final prefs =
                      //                       await SharedPreferences.getInstance();
                      //                   prefs.setString('crnt_lang_code',
                      //                       Getcurrentuser.lang_list[Index]);

                      //                   localization.translate(
                      //                       Getcurrentuser.lang_list[Index]);

                      //                 },
                      //                 title:
                      //                     Text(Getcurrentuser.lang_list[Index]),
                      //                 subtitle: Text(
                      //                     Getcurrentuser.lang_name_list[Index]),
                      //               );
                      //             },
                      //             itemCount: Getcurrentuser.lang_list.length,
                      //             shrinkWrap: true),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Divider(
                      //   color: Colors.purple[200],
                      //   thickness: 3,
                      // ),

                      // RefreshIndicator(
                      //   onRefresh: _refreshData,
                      //   child: ExpansionTile(
                      //     title: Text('content language'),
                      //     children: [
                      //       ListView.builder(
                      //           itemBuilder: (context, Index) {
                      //             return ListTile(
                      //               splashColor: Colors.cyan,
                      //               selectedColor: Colors.deepPurple,
                      //               onTap: () async {
                      //                 setcontentlang(Getcurrentuser
                      //                     .contentlangList[Index]);
                      //                 isselected == true
                      //                     ? ScaffoldMessenger.of(context)
                      //                         .showSnackBar(
                      //                         SnackBar(
                      //                           content: Text(
                      //                               'content lang ${Getcurrentuser.contentlangList[Index]} is selected'),
                      //                         ),
                      //                       )
                      //                     : null;
                      //               },
                      //               title: Text(
                      //                   Getcurrentuser.contentlangList[Index]),
                      //               subtitle: Text(
                      //                   Getcurrentuser.lang_name_list[Index]),
                      //             );
                      //           },
                      //           itemCount:
                      //               Getcurrentuser.contentlangList.length,
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
                          title: Text('free books'),
                          children: [
                            ListView.builder(
                                itemBuilder: (context, Index) {
                                  return ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ourbooklist(
                                              lable: Getcurrentuser
                                                  .GenerList[Index],
                                              freebook: true),
                                        ),
                                      );
                                    },
                                    title:
                                        Text(Getcurrentuser.GenerList[Index]),
                                  );
                                },
                                itemCount: Getcurrentuser.GenerList.length,
                                shrinkWrap: true),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.purple[200],
                        thickness: 3,
                      ),

                      RefreshIndicator(
                        onRefresh: _refreshData,
                        child: ExpansionTile(
                          title: Text('books'),
                          children: [
                            ListView.builder(
                                itemBuilder: (context, Index) {
                                  return ListTile(
                                    onTap: () async {
                                      heisvalid == true
                                          ? Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ourbooklist(
                                                        lable: Getcurrentuser
                                                            .GenerList[Index],
                                                        freebook: false),
                                              ),
                                            )
                                          // : Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             Payment()),
                                          //   );

                                          : showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return SingleChildScrollView(
                                                  child: AlertDialog(
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
                                                    title: const Text(
                                                        'subscription Details'),
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
                                                        heisguest == true
                                                            ? Text(
                                                                'You are a guest so please login otherwise money will loss',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        16),
                                                              )
                                                            : Text(
                                                                "${Getcurrentuser.userName}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .green,
                                                                    fontSize:
                                                                        16),
                                                              ),

                                                        SizedBox(height: 10),
                                                        Text(
                                                          'Available Subscriptions:',
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                        SizedBox(height: 10),
                                                        if (_products
                                                            .isNotEmpty)
                                                          Column(
                                                            children: _products
                                                                .map((product) {
                                                              return ListTile(
                                                                title: Text(
                                                                    product
                                                                        .title),
                                                                subtitle: Text(
                                                                    product
                                                                        .price),
                                                                trailing:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (_isPurchased ==
                                                                        true) {
                                                                      Fluttertoast
                                                                          .showToast(
                                                                        msg:
                                                                            'you still have premium access so not need to purchase',
                                                                        toastLength:
                                                                            Toast.LENGTH_LONG,
                                                                        backgroundColor: Color.fromARGB(
                                                                            255,
                                                                            64,
                                                                            249,
                                                                            255),
                                                                        textColor: const Color.fromARGB(
                                                                            255,
                                                                            15,
                                                                            0,
                                                                            0),
                                                                        gravity:
                                                                            ToastGravity.CENTER,
                                                                        fontSize:
                                                                            20.0,
                                                                      );
                                                                      // ScaffoldMessenger.of(
                                                                      //         context)
                                                                      //     .showSnackBar(
                                                                      //   SnackBar(
                                                                      //     content:
                                                                      //         Text('you still have premium access so not need to purchase'),
                                                                      //   ),
                                                                      // );
                                                                    } else if (_isPurchased ==
                                                                        false) {
                                                                      setState(
                                                                          () {
                                                                        purchased_product_id =
                                                                            product.id;
                                                                        purchased_product_title =
                                                                            product.title;
                                                                        purchased_product_raw_price =
                                                                            product.rawPrice;
                                                                        purchased_product_discription =
                                                                            product.description;
                                                                        _buySubscription();
                                                                      });
                                                                    }
                                                                    Navigator.of(context)
                                                                  .pop();
                                                                  },
                                                                  // onPressed: _isPurchased ? null : _buySubscription,
                                                                  child: Text(
                                                                      _isPurchased
                                                                          ? 'Purchased'
                                                                          : 'Buy'),
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .width *
                                                                  0.25,
                                                            ),
                                                            Text(
                                                              'OR',
                                                              style: TextStyle(
                                                                  fontSize: 18),
                                                            ),
                                                          ],
                                                        ),
                                                        TextField(
                                                          controller:
                                                              coupon_code_user_entered,
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
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              availCode(
                                                                  coupon_code_user_entered
                                                                      .text
                                                                      .toString());
                                                              print(
                                                                  coupon_code_user_entered);
                                                              coupon_code_user_entered
                                                                  .clear();
                                                              Navigator.of(context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                                'Avail code'))

                                                        // ElevatedButton(
                                                        //     onPressed:
                                                        //         check_valid,
                                                        //     child:
                                                        //         Text('press')),
                                                        // heisvalid == true
                                                        //     ? Text('valid')
                                                        //     : Text('Not valid'),
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


                                      // Fluttertoast.showToast(
                                      //   msg:
                                      //       'please subscribe for access premium content',
                                      //   toastLength: Toast.LENGTH_LONG,
                                      //   backgroundColor: Colors.pink.shade200,
                                      //   textColor: Colors.black,
                                      //   gravity: ToastGravity.CENTER,
                                      //   fontSize: 20.0,
                                      // );
                                    },
                                    title:
                                        Text(Getcurrentuser.GenerList[Index]),
                                  );
                                },
                                itemCount: Getcurrentuser.GenerList.length,
                                shrinkWrap: true),
                          ],
                        ),
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
                      // Getcurrentuser.userName!.contains(Getcurrentuser.admin_list)?
                      Getcurrentuser.admin_list
                              .contains(Getcurrentuser.userName)
                          ? ListTile(
                              title: const Text('Admin Page'),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AdminHome()));
                              },
                            )
                          : Divider(
                              color: Colors.white,
                              thickness: 3,
                            ),
                      // Divider(
                      //   color: Colors.purple[200],
                      //   thickness: 3,
                      // ),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.3,
                      ),
                    ],
                  ),
                ),
                body: SingleChildScrollView(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            // margin: EdgeInsets.only(top: 150),
                            margin: EdgeInsets.all(20),
                            height: MediaQuery.of(context).size.height / 1,
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
                                Text('Knowledge is power',
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