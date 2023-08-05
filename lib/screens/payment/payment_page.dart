import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mybook/components/provider.dart';

import 'package:provider/provider.dart';

import '../user_screens/user_home_screens/home_screen.dart';

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

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final db = FirebaseFirestore.instance;
  TextEditingController coupon_code_user_entered = TextEditingController();
  @override
  initState() {
    super.initState();
    context.read<Getcurrentuser>().getuser();
    context.read<Getcurrentuser>().getgenerlist();
    context.read<Getcurrentuser>().getcontentlanglist();
    context.read<Getcurrentuser>().getselectedcontentlang();
    context.read<Getcurrentuser>().getadminlist();

    // getgenerlist();
    check_valid();
    _initializeProducts();

    // Listen for purchases updates
    _subscription = InAppPurchase.instance.purchaseStream.listen((data) {
      _handlePurchaseUpdates(data);
    });
  }

  Future<void> check_valid() async {
    final prefs = await SharedPreferences.getInstance();

    String? user = prefs.getString('name');

    if (user != 'guest@gmail.com') {
      // final userDoc =
      //     await FirebaseFirestore.instance.collection('users').doc(user).get();
      // print(userDoc.get('purchased'));
      // if (userDoc == null || userDoc.exists == false) {
      //   heisvalid = false;
      // } else if (userDoc.exists == true) {
      //   bool isPurchased = userDoc.get('purchased');
      //   final isvalid = userDoc.get('validDate') as Timestamp;
      //   final validDate = isvalid.toDate();
      //   final now = DateTime.now();
      //   //  DateTime isvalid =userDoc.get('validDate') ;
      //   //  DateTime now=DateTime.now();
      //   if (isPurchased == true && now.isBefore(validDate)) {
      //     heisvalid = true;
      //     print(heisvalid);
      //     setState(() {
      //       heisvalid = true;
      //     });
      //   } else {
      //     heisvalid = false;
      //     print(heisvalid);
      //     setState(() {
      //       heisvalid = false;
      //     });
      //   }
      // }
      heisguest = false;
    } else {
      heisguest = true;
    }
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
      // check_valid();
      if (_isPurchased == true) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const HomeScreenMainPage()));
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
        Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomeScreenMainPage()),
                                            );
      }

else if (heisguest==true) {
      Fluttertoast.showToast(
        msg: 'guest user not able to avail',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.pink.shade200,
        textColor: Colors.black,
        gravity: ToastGravity.CENTER,
        fontSize: 20.0,
      );
    } else if (code_list.contains(code) == false) {
      Fluttertoast.showToast(
        msg: 'code is not valid',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.pink.shade200,
        textColor: Colors.black,
        gravity: ToastGravity.CENTER,
        fontSize: 20.0,
      );
    } else if (user_for_code_list.contains(user) == true) {
      Fluttertoast.showToast(
        msg: 'code already redemed by you',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.pink.shade200,
        textColor: Colors.black,
        gravity: ToastGravity.CENTER,
        fontSize: 20.0,
      );
    }
      // admin_list[admin_list.indexOf('seenu')];
    } 

    // if(heisguest==false&&user)
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Getcurrentuser>(
        builder: ((context, Getcurrentuser, child) => Scaffold(
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // AlertDialog(

                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.1,
                      ),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height,
                        width: MediaQuery.sizeOf(context).width * 0.75,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'subscription Details',
                              style: TextStyle(fontSize: 30),
                            ),
                            heisguest == true
                                ? const Text(
                                    'You are a guest so please login otherwise money will loss',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 16),
                                  )
                                : Text(
                                    "${Getcurrentuser.userName}",
                                    style: const TextStyle(
                                        color: Colors.green, fontSize: 16),
                                  ),

                            const SizedBox(height: 10),
                            const Text(
                              'Available Subscriptions:',
                              style: TextStyle(fontSize: 20),
                            ),
                            const SizedBox(height: 10),
                            if (_products.isNotEmpty)
                              Column(
                                children: _products.map((product) {
                                  return ListTile(
                                    title: Text(product.title),
                                    subtitle: Text(product.price),
                                    trailing: ElevatedButton(
                                      onPressed: () {
                                        if (_isPurchased == true) {
                                          Fluttertoast.showToast(
                                            msg:
                                                'you still have premium access so not need to purchase',
                                            toastLength: Toast.LENGTH_LONG,
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 64, 249, 255),
                                            textColor: const Color.fromARGB(
                                                255, 15, 0, 0),
                                            gravity: ToastGravity.CENTER,
                                            fontSize: 20.0,
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'you still have premium access so not need to purchase'),
                                            ),
                                          );
                                        } else if (_isPurchased == false) {
                                          setState(() {
                                            purchased_product_id = product.id;
                                            purchased_product_title =
                                                product.title;
                                            purchased_product_raw_price =
                                                product.rawPrice;
                                            purchased_product_discription =
                                                product.description;
                                            _buySubscription();
                                          });
                                        }
                                      },
                                      // onPressed: _isPurchased ? null : _buySubscription,
                                      child: Text(
                                          _isPurchased ? 'Purchased' : 'Buy'),
                                    ),
                                  );
                                }).toList(),
                              ),
                            // ElevatedButton(
                            //     onPressed:
                            //         check_valid,
                            //     child:
                            //         Text('press')),
                            // heisvalid == true
                            //     ? Text('valid')
                            //     : Text('Not valid'),
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.25,
                                ),
                                Text(
                                  'OR',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.25,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SingleChildScrollView(
                                              child: AlertDialog(
                                                actions: [
                                                  IconButton(
                                                      onPressed: () {
                                                        coupon_code_user_entered
                                                            .clear();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      icon: const Icon(
                                                          Icons.close))
                                                ],
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TextField(
                                                      controller:
                                                          coupon_code_user_entered,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Enter code',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                        ),
                                                        enabledBorder:
                                                            const OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
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
                                                        child:
                                                            Text('Avail code'))
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: Text('use code'))
                              ],
                            ),
                          ],
                        ),
                      ),

                      // )
                    ],
                  ),
                ),
              ),
            )));
  }
}
