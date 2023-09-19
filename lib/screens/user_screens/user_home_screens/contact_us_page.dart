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
              logo: const AssetImage('assets/ptsbook_logo.png'),
              image: Image.asset('assets/ptsinfotech_logo.png'),
              email: 'ptstechseenu@gmail.com',
              companyName: 'Ptsinfotech',
              companyColor: Colors.teal.shade100,
              dividerThickness: 2,
              phoneNumber: '+919994745592',
              website: 'https://wordpress.com/post/ptsinfotech.wordpress.com/6',
              // githubUserName: 'seenuvasan1947',
              // linkedinURL: 'https://www.linkedin.com/in/abhishek-doshi-520983199/',
              tagLine: 'Product based software company',
              taglineColor: Colors.teal.shade100,
              twitterHandle: 'ptsinfotech',
              instagram: 'ptsinfotech',
              facebookHandle: 'ptsinfotech',
               
            ),
          ),
        ),
      ),
    );
  }
}