import 'package:flutter/material.dart';

class Settingbody extends StatefulWidget {

  @override
  State<Settingbody> createState() => _SettingbodyState();
}
class _SettingbodyState extends State<Settingbody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: Image.asset(
          "assets/logo.PNG",
          width: 55,
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Image.asset("assets/t&c1.png"),
            Image.asset("assets/t&c2.jpeg"),
            SizedBox(height: 20,),
            Text("Contact me to purchase classes and for more information on the prices, after you have bought the classes please make a parent account",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10,),
            Image.asset("assets/wechatqr.png"),
          ],
        ),
      ),
    );
  }
}
