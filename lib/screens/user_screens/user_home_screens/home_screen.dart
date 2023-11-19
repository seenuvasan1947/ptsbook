// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_function_type_syntax_for_parameters, depend_on_referenced_packages, use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:mybook/auth/auth.dart';
import 'package:mybook/components/functions/operational_function.dart';
import 'package:mybook/components/functions/shared_pref_functions.dart';
import 'package:mybook/components/language/data/excell_data.dart';
import 'package:mybook/components/provider.dart';

import 'package:provider/provider.dart';
import 'package:mybook/screens/user_screens/user_book/user_books_add_page.dart';

import 'package:mybook/screens/user_screens/user_book/login_user_added_book_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// import '../components/language/lang_strings.dart';
import '../../../components/functions/aditional_function_lang.dart';
import '../../../components/language/data/lang_maplocals.dart';
import '../../../components/language/lang_strings.dart';
import '../../../components/language/multi_lang.dart';
import '../../../components/payment/functions_for_payment.dart';
import '../../../components/payment/in_app_purchase_handler.dart';
import '../../../components/payment/payment_popup_widget.dart';
import '../../../components/reusable_widget/book_list_widget.dart';
import '../../admin_screens/admin_home_page.dart';

import '../user_audio_book_screen/audioplayer.dart';
import '../user_audio_book_screen/book_text_read_page.dart';
import '../user_audio_book_screen/our_books_list.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'lang_select_page.dart';
import 'nav_bar_home_screen.dart';
import '../../../components/language/data/lang_data.dart';

// import 'package:google_mlkit_translation/google_mlkit_translation.dart';

// bool heisvalid = false;
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
  ScrollController _scrollController = ScrollController();
  final FlutterLocalization localization = FlutterLocalization.instance;
//  final db = FirebaseFirestore.instance;
  late Uri tempurl;
  var selectedBook = 'abc';
  List bookNames = [];

  String book__name_over_all = '';

  Future<void> _launchUrl(Uri tempurl) async {
    if (!await launchUrl(tempurl, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $tempurl');
    }
  }

  @override
  initState() {
    super.initState();
    context.read<Getcurrentuser>().getuser();
    context.read<Getcurrentuser>().getgenerlist();
    context.read<Getcurrentuser>().getcontentlanglist();
    context.read<Getcurrentuser>().getselectedcontentlang();
    context.read<Getcurrentuser>().getadminlist();
    context.read<LangPropHandler>().getlangindex();
    context.read<Getcurrentuser>().gethomepageimg();
    Provider.of<ExcellData>(context, listen: false).fetchlistforrender('Free');

    initstate_function();
    getContentLang();
    lang_init_local().lang_init();
    localization.onTranslatedLanguage = _onTranslatedLanguage;
    localization.translate(LangPropHandler.crnt_lang_code);
    super.initState();

    _refreshData();
    // getgenerlist();
    // localization.init();

    // Listen for purchases updates
    _subscription = InAppPurchase.instance.purchaseStream.listen((data) {
      handlePurchaseUpdates(data, context);
    });
    check_valid();
    // lang_model_manage();
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  void initstate_function() async {

    setState(() async {
         heisguest = await check_he_is_guest();

    _isPurchased = await check_he_is_purchased();

   _products= await initializeProducts(context);
    });
 
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

  @override
  Widget build(BuildContext context) {
    return Consumer<Getcurrentuser>(
        builder: ((context, Getcurrentuser, child) => MaterialApp(
              supportedLocales: localization.supportedLocales,
              localizationsDelegates: localization.localizationsDelegates,
              home: Scaffold(
                appBar: AppBar(
                  title: Text('ptsbook'),
                  centerTitle: true,
                  actions: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SettingsPage(),
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
                            Text(AppLocale.welcome.getString(context)),

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
                        title:
                            Text(AppLocale.write_your_book.getString(context)),
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
                        title: Text(AppLocale.my_book.getString(context)),
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

                      RefreshIndicator(
                        onRefresh: _refreshData,
                        child: ExpansionTile(
                          title: Text(AppLocale.paid_books.getString(context)),
                          children: [
                            ListView.builder(
                                itemBuilder: (context, Index) {
                                  return ListTile(
                                    onTap: () async {
                                      bool heisvalid = await check_valid();

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
                                                  child: payment_widget_screen(
                                                      context, Getcurrentuser,heisguest,_isPurchased,_products),
                                                );
                                              });
                                    },

                                    title: FutureBuilder(
                                      future: getTranslatedText(
                                          Getcurrentuser.GenerList[Index]),
                                      // initialData: InitialData,
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        // return Text(snapshot.data);
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Text(Getcurrentuser.GenerList[
                                              Index]); // Display a loading indicator
                                        } else if (snapshot.hasError) {
                                          return
                                              // Text('Error: ${snapshot.error}');
                                              Text(Getcurrentuser
                                                  .GenerList[Index]);
                                        } else {
                                          return Text(snapshot
                                              .data!); // Display the translated text
                                        }
                                      },
                                    ),

                                    // title:Text(Getcurrentuser.GenerList[Index]),
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
                        title: Text(AppLocale.logout.getString(context)),
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
                    child: Column(
                      children: [
                        // ElevatedButton(
                        //     onPressed: () {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => GetData()));
                        //     },
                        //     child: Text('go')),
                        SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.04),

                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.3,
                          width: MediaQuery.sizeOf(context).width * 0.8,
                          child: Image.network(Getcurrentuser.home_img),
                        ),
                        const Divider(color: Colors.deepPurple, thickness: 2.2),

                        SingleChildScrollView(
                          child: booksList(ishome: true),
                        ),

                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.1,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }


}
