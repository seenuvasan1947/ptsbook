

  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../screens/user_screens/user_home_screens/nav_bar_home_screen.dart';
import '../functions/shared_pref_functions.dart';
import '../provider.dart';
import 'functions_for_payment.dart';

Future< List<ProductDetails>> initializeProducts(BuildContext context) async {
  List<ProductDetails> products_list = []; //replacement of _product
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      // The store is not available, handle accordingly
      return products_list ;
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

        products_list = products;
        print('123456=====');
        print(products[0]);

        return products_list;
  
  }





  void handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList,BuildContext context) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          // Purchase is pending, handle accordingly
          break;
        case PurchaseStatus.purchased:
          // Purchase was successful, verify and process the purchase
          verifyPurchase(purchaseDetails,context);
          break;
        case PurchaseStatus.error:
          // Purchase failed, handle accordingly
          break;
        case PurchaseStatus.restored:
          // Purchase was restored, handle accordingly
          verifyPurchase(purchaseDetails,context);
          break;
      }
    }
  }







  void verifyPurchase(PurchaseDetails purchaseDetails, BuildContext context) async {
    // Verify the purchase if necessary
    if (purchaseDetails.pendingCompletePurchase) {
      await InAppPurchase.instance.completePurchase(purchaseDetails);
    }

    if (purchaseDetails.productID == '1_week_subscription') {
      // Update the Firestore document for the user
      purchase_update_firestore('1_week_subscription',context);
    }
    if (purchaseDetails.productID == '1_month_subscription') {
      // Update the Firestore document for the user
      purchase_update_firestore('1_month_subscription',context);
    }
    if (purchaseDetails.productID == '6_month_subscription') {
      // Update the Firestore document for the user
      purchase_update_firestore('6_month_subscription',context);
    }
    if (purchaseDetails.productID == '1_year_subscription') {
      // Update the Firestore document for the user
      purchase_update_firestore('1_year_subscription',context);
    }
  }






  void purchase_update_firestore( String purchased_id, BuildContext context) async {
    int dataNo = 0;
    
    final db = FirebaseFirestore.instance;
    bool is_payment_purchased=false;
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

      
        is_payment_purchased = true;
        setboolvalue("ispurchased",is_payment_purchased);
     
      check_valid();
      if (is_payment_purchased == true) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => NavBarAtHomePage()));
      }
    } catch (e) {
      // Handle Firestore update error
    }
  }







  Future<void> buySubscription({required BuildContext context,required String purchased_product_id,required String purchased_product_title,required double purchased_product_raw_price,required  String purchased_product_discription}) async {
    int index = 0;

List<ProductDetails> _products= await  initializeProducts(context);
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
