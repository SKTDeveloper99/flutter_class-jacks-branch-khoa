import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_class/Teachers/teacherAccount.dart';
import 'package:flutter_class/welcome.dart';
import 'package:flutter_class/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Accounts/authentication.dart';
import 'main.dart';

class RecruitPage extends StatefulWidget {

  @override
  State<RecruitPage> createState() => _RecruitPageState();
}


class _RecruitPageState extends State<RecruitPage> {
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
  late final Character character;
  late final String uid;
  late final String email;
  late final String password;

  bool thisCharacterTeacher = false;
  String Teachercode = "OOOO";
  String CorrectTeacherCode = "";


  String age = "";
  String name = "";
  String skills = "";
  String classes = "";

  String Experience = "";

  String currentTeachingClasses = "";

  String imagelink = "";
  String college = "";
  String major = "";


  void refreshTeacherCode() {
    db.collection("users.Teachers").doc("TeacherCode").get().then((value) {

      CorrectTeacherCode = value.data()!["code"].toString();
    }
    );
  }


  Widget build(BuildContext context) {
    refreshTeacherCode();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("Want to sign up to be apart of our team?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    fontFamily: "Metropolis"
                  ),
                ),
                const SizedBox(height: 10,),
                Text("Fill this out and we will get back to you as soon as possible!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Metropolis"
                  ),
                ),
                const SizedBox(height: 20,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0,),
                      child: TextField(
                        obscureText: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Name',
                        ),
                        onChanged: (String newEntry) {
                          name = newEntry;
                        },
                      ),
                    ), //name
                    const SizedBox(height: 3,),

                    Padding(
                      padding: const EdgeInsets.only(top: 10.0,),
                      child: TextField(
                        obscureText: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Age',
                        ),
                        onChanged: (String newEntry) {
                          age = newEntry;
                        },
                      ),
                    ), //age
                    const SizedBox(height: 3,),

                    Padding(
                      padding: const EdgeInsets.only(top: 10.0,),
                      child: TextField(
                        obscureText: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'College',
                        ),
                        onChanged: (String newEntry) {
                          print("Username was changed to $newEntry");
                          college = newEntry;
                        },
                      ),
                    ), //college
                    const SizedBox(height: 3,),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0,),
                      child: TextField(
                        obscureText: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Major',
                        ),
                        onChanged: (String newEntry) {
                          print("Username was changed to $newEntry");
                          major = newEntry;
                        },
                      ),
                    ), //major
                    const SizedBox(height: 3,),

                    Padding(
                      padding: const EdgeInsets.only(top: 10.0,),
                      child: TextField(
                        obscureText: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Experience',
                        ),
                        onChanged: (String newEntry) {
                          print("Username was changed to $newEntry");
                          Experience = newEntry;
                        },
                      ),
                    ), //experience
                    const SizedBox(height: 3,),

                    Padding(
                      padding: const EdgeInsets.only(top: 10.0,),
                      child: TextField(
                        obscureText: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Skills',
                        ),
                        onChanged: (String newEntry) {
                          print("Username was changed to $newEntry");
                          skills = newEntry;
                        },
                      ),
                    ), //skills
                    const SizedBox(height: 3,),

                    Padding(
                      padding: const EdgeInsets.only(top: 10.0,),
                      child: TextField(
                        obscureText: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Current Classes',
                        ),
                        onChanged: (String newEntry) {
                          print("Username was changed to $newEntry");
                          currentTeachingClasses = newEntry;
                        },
                      ),
                    ), //currentTeachingClasses
                    const SizedBox(height: 3,),

                    Padding(
                      padding: const EdgeInsets.only(top: 10.0,),
                      child: TextField(
                        obscureText: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Previous Classes',
                        ),
                        onChanged: (String newEntry) {
                          print("Username was changed to $newEntry");
                          classes = newEntry;
                        },
                      ),
                    ), //classes
                    const SizedBox(height: 3,),


                    Padding(
                      padding: const EdgeInsets.only(top: 10.0,),
                      child: TextField(
                        obscureText: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Link to image',
                        ),
                        onChanged: (String newEntry) {
                          print("Username was changed to $newEntry");
                          imagelink = newEntry;
                        },
                      ),
                    ), //imageLink
                    const SizedBox(height: 20,),


                    SizedBox(
                      height: 50,
                      width: 500,
                      child: ElevatedButton(
                        onPressed: (){

                          final Map<String, Object> newMap;

                          newMap = {
                            "Teachers": {
                              "name" : name,
                              "college": college,
                              "major": major,
                              "skills": skills,
                              "expereince": Experience,
                              "age": age,
                              "currentClasses": currentTeachingClasses,
                              "classes": classes,
                              "email": email,
                              "password": password,
                              "account": uid,
                              "image" : imagelink

                            },
                          };



                          db.collection("users.Teachers").doc(AuthenticationHelper().uid).set(newMap);
                          _launchURL("emilym0isakittycat@gmail.com", "报名", "I WANNA BE A TEACHERRRRRRR");
                        },
                        child: Text("Submit",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: "Metropolis",
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 5.0,
                          backgroundColor: Colors.blue[100],
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5,),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}
