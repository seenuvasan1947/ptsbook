import 'package:contactus/contactus.dart';
import 'package:flutter/material.dart';



class ContactusPage extends StatefulWidget {
  const ContactusPage({super.key});

  @override
  State<ContactusPage> createState() => _ContactusPageState();
}

class _ContactusPageState extends State<ContactusPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // bottomNavigationBar: ContactUsBottomAppBar(
        //   companyName: 'Abhishek Doshi',
        //   textColor: Colors.white,
        //   backgroundColor: Colors.teal.shade300,
        //   email: 'adoshi26.ad@gmail.com',
        //   // textFont: 'Sail',
        // ),
        backgroundColor: Colors.teal,
        body: SingleChildScrollView(
          child: Center(
            child: ContactUs(
                  
              cardColor: Colors.white,
              textColor: Colors.teal.shade900,
              avatarRadius: 60.0,
              logo: const AssetImage('assets/logo.png'),
              email: 'ptstechseenu@gmail.com',
              companyName: 'Ptsinfotech',
              companyColor: Colors.teal.shade100,
              dividerThickness: 2,
              phoneNumber: '+919994745592',
              website: 'https://abhishekdoshi.godaddysites.com',
              githubUserName: 'seenuvasan1947',
              linkedinURL: 'https://www.linkedin.com/in/abhishek-doshi-520983199/',
              tagLine: 'Product based software company',
              taglineColor: Colors.teal.shade100,
              twitterHandle: 'AbhishekDoshi26',
              instagram: '_abhishek_doshi',
              facebookHandle: '_abhishek_doshi',
               
            ),
          ),
        ),
      ),
    );
  }
}