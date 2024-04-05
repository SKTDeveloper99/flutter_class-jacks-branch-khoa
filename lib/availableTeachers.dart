import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_class/Teachers/teacherAccount.dart';
import 'package:flutter_class/widgets.dart';

import 'Accounts/authentication.dart';

class availableTeachers extends StatefulWidget {
  late final String courseName;
  availableTeachers(this.courseName);
  @override
  State<availableTeachers> createState() => availableTeachersState(courseName);
}


class availableTeachersState extends State<availableTeachers> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  AuthenticationHelper Auth = AuthenticationHelper();
  List<Widget> teacherName = [];
  List<String> candidates = [];
  late final String courseName;

  List<String> teacherImages = [
    "https://cdn.discordapp.com/attachments/1070956419949535272/1134368270301016064/istockphoto-75940775-612x612.jpg",
    "https://cdn.discordapp.com/attachments/1070956419949535272/1134368270301016064/istockphoto-75940775-612x612.jpg",
    "https://cdn.discordapp.com/attachments/1070956419949535272/1134368270301016064/istockphoto-75940775-612x612.jpg"
  ];

  availableTeachersState(this.courseName){
    refreshTeachers();
  }


  void refreshTeachers() {
    print(courseName);
    db.collection("Courses").doc(courseName).get().then((value) {
      List<Widget> tmpTeachers = [];

      Map<String, dynamic> data = value.data() as Map<String, dynamic>;

      for (var i in data.keys) {
        db.collection("users.Teachers").doc(i).get().then((x) {
          print(x.data());
          print(i);
          tmpTeachers.add(Teacher(i, x.data()?["Teachers"]["name"]));
          setState(() {
           // tmpTeachers.add(Teacher(i, x.data()?["name"]));
          });
        });
      }
      teacherName = tmpTeachers;
    }

    );

  }





  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: Text(
          courseName,
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Metropolis",
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        child: ListView(
          children: teacherName,
        ),
      ),
    );
  }
}
