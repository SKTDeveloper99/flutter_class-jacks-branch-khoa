import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_class/Teachers/teacherAccount.dart';
import 'package:flutter_class/widgets.dart';

import 'Accounts/authentication.dart';

class GuestClasses extends StatefulWidget {

  @override
  State<GuestClasses> createState() => GuestClassesState();
}


class GuestClassesState extends State<GuestClasses> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  AuthenticationHelper Auth = AuthenticationHelper();
  List<Widget> Courses = [Course("English")];
   List<String> candidates = [];
   List<String> teacherImages = [
     "https://cdn.discordapp.com/attachments/1070956419949535272/1134368270301016064/istockphoto-75940775-612x612.jpg",
     "https://cdn.discordapp.com/attachments/1070956419949535272/1134368270301016064/istockphoto-75940775-612x612.jpg",
     "https://cdn.discordapp.com/attachments/1070956419949535272/1134368270301016064/istockphoto-75940775-612x612.jpg"
   ];

   void refreshCourses() {
     db.collection("Courses").get().then((querySnapshot) {
       List<Widget> tmpCourses = [];
       List<String> tmpImg = [];
       for (var i in querySnapshot.docs) {
         //   print(i.data());
         //   print(i.id);
         //    print("hello");
         setState(() {
           tmpCourses.add(Course(i.id));
          // tmpImg.add(i.data()["Teachers"]["image"]);
         });


       }
       Courses = tmpCourses;
       //teacherImages = tmpImg;
     });
   }

  _RecruitPageState() {
    refreshCourses();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: Courses,
        )
    );
  }

}
