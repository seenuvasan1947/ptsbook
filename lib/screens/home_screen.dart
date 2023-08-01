// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_function_type_syntax_for_parameters, depend_on_referenced_packages

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mybook/auth/auth.dart';
import 'package:mybook/components/language/lang_select.dart';
import 'package:mybook/components/provider.dart';

import 'package:provider/provider.dart';
import 'package:mybook/screens/book_add_page.dart';
import 'package:mybook/screens/book_list.dart';
import 'package:mybook/screens/my_book.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../components/language/lang_strings.dart';
import '../components/language/lang_strings.dart';
import '../components/language/multi_lang.dart';
import 'admin_book_add.dart';
import 'admin_screens/admin_home_page.dart';
import 'apl.dart';

import 'audio_check.dart';
import 'audio_create.dart';
import 'audio_download.dart';
import 'favouritebook.dart';
import 'nav_bar_home_screen.dart';
import 'our_books.dart';
import 'package:restart_app/restart_app.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

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
bool heisguest =
    false; // Set it to false if you don't want to auto-consume products
// bool heisvalid = false;

class HomeScreenMainPage extends StatefulWidget {
  const HomeScreenMainPage({Key? key}) : super(key: key);

  @override
  _HomeScreenMainPageState createState() => _HomeScreenMainPageState();
}

class _HomeScreenMainPageState extends State<HomeScreenMainPage> {
  final db = FirebaseFirestore.instance;

  @override
  initState() {
    context.read<Getcurrentuser>().getuser();
    context.read<Getcurrentuser>().getgenerlist();
    context.read<Getcurrentuser>().getcontentlanglist();
    context.read<Getcurrentuser>().getselectedcontentlang();
    context.read<Getcurrentuser>().getadminlist();
    _refreshData();
    // getgenerlist();
    _initializeProducts();

    // Listen for purchases updates
    _subscription = InAppPurchase.instance.purchaseStream.listen((data) {
      _handlePurchaseUpdates(data);
    });
    check_valid();
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

  // DateTime _calculateValidDate(PurchaseDetails purchaseDetails) {
  //   if (purchaseDetails.billingPeriod == BillingPeriod.month) {
  //     return purchaseDetails.purchaseDate.add(Duration(days: 31));
  //   } else if (purchaseDetails.billingPeriod == BillingPeriod.sixMonths) {
  //     return purchaseDetails.purchaseDate.add(Duration(days: 186));
  //   }
  //   return null;
  // }

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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreenMainPage()));
      }
    } catch (e) {
      // Handle Firestore update error
    }
  }

  // Future<void> check_valid() async {
  //   final userDoc = await _firestore.collection('users').doc('user_id').get();
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

  Future<void> _buySubscription() async {
    print(purchased_product_id);
    // int index = _products.indexOf(ProductDetails(
    //     id: prod.id,
    //     title: prod.title,
    //     description: prod.description,
    //     price: prod.price,
    //     rawPrice: prod.rawPrice,
    //     currencyCode: prod.currencyCode));
    // int index= _products.indexOf(_products)

    // int index=_products.indexOf(prod);
    int index = 0;
    print(_products.elementAt(0));
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
      // productDetails: prod,

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

  @override
  Widget build(BuildContext context) {
    return Consumer<Getcurrentuser>(
        builder: ((context, Getcurrentuser, child) => MaterialApp(
              home: Scaffold(
                appBar: AppBar(
                  title: Text(AppLocale.welcome.getString(context)),
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

                      RefreshIndicator(
                        onRefresh: _refreshData,
                        child: ExpansionTile(
                          title: Text('app language'),
                          children: [
                            ListView.builder(
                                itemBuilder: (context, Index) {
                                  return ListTile(
                                    splashColor: Colors.cyan,
                                    selectedColor: Colors.deepPurple,
                                    selectedTileColor: Colors.indigoAccent,
                                    onTap: () async {
                                      // set_app_lang();
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      print(prefs.getString('crnt_lang_code'));
                                      print('=0=0=0=0');
                                      prefs.setString('crnt_lang_code',
                                          Getcurrentuser.lang_list[Index]);

                                      localization.translate(
                                          Getcurrentuser.lang_list[Index]);
                                      // localization.translate('en');
                                      print(prefs.getString('crnt_lang_code'));
                                      print(
                                          AppLocale.welcome.getString(context));

                                      // setcontentlang(Getcurrentuser
                                      //     .contentlangList[Index]);
                                      // isselected == true
                                      //     ? ScaffoldMessenger.of(context)
                                      //         .showSnackBar(
                                      //         SnackBar(
                                      //           content: Text(
                                      //               'content lang ${Getcurrentuser.contentlangList[Index]} is selected'),
                                      //         ),
                                      //       )
                                      //     : null;
                                    },
                                    title:
                                        Text(Getcurrentuser.lang_list[Index]),
                                    subtitle: Text(
                                        Getcurrentuser.lang_name_list[Index]),
                                  );
                                },
                                itemCount: Getcurrentuser.lang_list.length,
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
                          title: Text('content language'),
                          children: [
                            ListView.builder(
                                itemBuilder: (context, Index) {
                                  return ListTile(
                                    splashColor: Colors.cyan,
                                    selectedColor: Colors.deepPurple,
                                    onTap: () async {
                                      setcontentlang(Getcurrentuser
                                          .contentlangList[Index]);
                                      isselected == true
                                          ? ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'content lang ${Getcurrentuser.contentlangList[Index]} is selected'),
                                              ),
                                            )
                                          : null;
                                    },
                                    title: Text(
                                        Getcurrentuser.contentlangList[Index]),
                                    subtitle: Text(
                                        Getcurrentuser.lang_name_list[Index]),
                                  );
                                },
                                itemCount:
                                    Getcurrentuser.contentlangList.length,
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
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ourbooklist(
                                                        lable: Getcurrentuser
                                                            .GenerList[Index],
                                                        freebook: false),
                                              ),
                                            )
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
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        SnackBar(
                                                                          content:
                                                                              Text('you still have premium access so not need to purchase'),
                                                                        ),
                                                                      );
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
                             Divider(
                        color: Colors.purple[200],
                        thickness: 3,
                      ),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height*0.3,
                            ),
                           
                    ],
                  ),
                ),
                body: SingleChildScrollView(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
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
