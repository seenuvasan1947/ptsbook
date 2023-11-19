
  import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../provider.dart';
import 'functions_for_payment.dart';
import 'in_app_purchase_handler.dart';

AlertDialog payment_widget_screen(
      BuildContext context, Getcurrentuser Getcurrentuser,bool heisguest,bool _isPurchased ,List<ProductDetails> _products) {
        TextEditingController coupon_code_user_entered = TextEditingController();
        
    print('he is guest${heisguest}');
    return AlertDialog(
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heisguest == true
              ? Text(
                  'You are a guest so please login otherwise money will loss',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                )
              : Text(
                  "${Getcurrentuser.userName}",
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),

          SizedBox(height: 10),
          Text(
            'Available Subscriptions:',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
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
                          backgroundColor: Color.fromARGB(255, 64, 249, 255),
                          textColor: const Color.fromARGB(255, 15, 0, 0),
                          gravity: ToastGravity.CENTER,
                          fontSize: 20.0,
                        );
                        // ScaffoldMessenger.of(
                        //         context)
                        //     .showSnackBar(
                        //   SnackBar(
                        //     content:
                        //         Text('you still have premium access so not need to purchase'),
                        //   ),
                        // );
                      } else if (_isPurchased == false) {
                        
                          // purchased_product_id = product.id;
                          // purchased_product_title = product.title;
                          // purchased_product_raw_price = product.rawPrice;
                          // purchased_product_discription = product.description;
                          buySubscription(
                              context: context,
                              purchased_product_discription:
                                  product.description,
                              purchased_product_id: product.id,
                              purchased_product_raw_price: product.rawPrice,
                              purchased_product_title: product.title
                              );
                       
                      }
                      Navigator.of(context).pop();
                    },
                    // onPressed: _isPurchased ? null : _buySubscription,
                    child: Text(_isPurchased ? 'Purchased' : 'Buy'),
                  ),
                );
              }).toList(),
            ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.25,
              ),
              Text(
                'OR',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          TextField(
            controller: coupon_code_user_entered,
            decoration: InputDecoration(
              labelText: 'Enter code',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black38),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                availCode(context, coupon_code_user_entered.text.toString());
                print(coupon_code_user_entered);
                coupon_code_user_entered.clear();
                Navigator.of(context).pop();
              },
              child: Text('Avail code'))

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
    );
  }
