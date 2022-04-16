import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class Contact extends StatelessWidget {
  //const Contact({ Key? key }) : super(key: key);
  void launchWhatsApp({
    String phone = "+923027677989",
    String message = "",
  }) async {
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
      } else {
        return "whatsapp://send?phone=$phone&text=${Uri.parse(message)}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      // throw 'Could not launch ${url()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic dev_height = MediaQuery.of(context).size.height;
    dynamic dev_width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.blue[300],
        body: Container(
          height: dev_height,
          width: dev_width,
          child: Column(
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                height: dev_height / 3,
                width: dev_width,
                child: Text(
                  "Contact Us",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 50, left: 70, right: 70, bottom: 70),
                child: Container(
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset("images/fb.png"),
                      GestureDetector(
                          onTap: () {
                            launchWhatsApp();
                          },
                          child: Image.asset("images/whatsapp.png")),
                      Image.asset("images/gmail.png"),
                    ],
                  ),
                ),
              ),
              Center(
                child: Divider(
                  color: Colors.blue,
                  thickness: 3,
                  //height: 5,
                  endIndent: 80,
                  indent: 80,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}



