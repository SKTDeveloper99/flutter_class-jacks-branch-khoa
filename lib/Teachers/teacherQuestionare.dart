import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_class/widgets.dart';

import '../Accounts/authentication.dart';
import '../Accounts/login.dart';
import '../main.dart';
import '../welcome.dart';
class teacherQuestion extends StatefulWidget {
  @override
  late final Character character;
  late final String uid;
  late final String email;
  late final String password;

  teacherQuestion(this.character, this.uid, this.email, this.password);
  State<teacherQuestion> createState() => teacherQuestionState(character, uid, email, password);
}

class teacherQuestionState extends State<teacherQuestion> {
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


  FirebaseFirestore db = FirebaseFirestore.instance;


  teacherQuestionState(this.character, this.uid, this.email, this.password){
    if (character.toString() == "Character.teacher") {
      thisCharacterTeacher = true;
    }

  }

  void refreshTeacherCode() {
    db.collection("users.Teachers").doc("TeacherCode").get().then((value) {

      CorrectTeacherCode = value.data()!["code"].toString();
    }
    );
  }


  Widget build(BuildContext context) {
    refreshTeacherCode();
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            )
        ),
        toolbarHeight: 100,
        backgroundColor: Colors.blue[100],
        bottomOpacity: 0,
        elevation: 0,
        title:
        Padding(
            padding: const EdgeInsets.only(top: 0.0,),
            child: Image.asset(
              "assets/logo.PNG",
              width: 160,
            )
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
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
              const SizedBox(height: 5,),


              SizedBox(
                height: 50,
                width: 500,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyHomePage(character, 'My Home Page')));
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

                    },
                  child: Text("Continue",
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
        ),
      ),
    );
  }
}

