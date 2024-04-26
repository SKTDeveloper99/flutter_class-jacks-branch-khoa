import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_class/Teachers/teacherQuestionare.dart';
import 'package:flutter_class/widgets.dart';

import '../services/auth_service.dart';
import 'authentication.dart';
import 'login.dart';
import '../main.dart';
import '../welcome.dart';
class Signup extends StatefulWidget {
  @override
  late final Character character;
  Signup(this.character);
  State<Signup> createState() => _SignupState(character);
}

class _SignupState extends State<Signup> {
  @override
  late final Character character;
  bool thisCharacterTeacher = false;
  String Teachercode = "OOOO";
  String CorrectTeacherCode = "";
  FirebaseFirestore db = FirebaseFirestore.instance;


  _SignupState(this.character){
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

  String email = "";
  String password = "";
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
        toolbarHeight: 250,
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
                padding: const EdgeInsets.only(top: 10.0,),
                child: TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                  onChanged: (String newEntry) {
                    print("Username was changed to $newEntry");
                    email = newEntry;
                  },
                ),
              ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(top: 10.0,),
                child: TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  onChanged: (String newEntry) {
                    print("Username was changed to $newEntry");
                    password = newEntry;
                  },
                ),
              ),
              const SizedBox(height: 20,),
              Visibility(visible:thisCharacterTeacher,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0,),
                    child: TextField(
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Teacher Code',
                      ),
                      onChanged: (String newEntry) {
                        Teachercode = newEntry;
                      },
                    ),
                  ),
              ),
              const SizedBox(height: 20,),

              SizedBox(
                height: 50,
                width: 500,
                child: ElevatedButton(
                  onPressed: (){
                    AuthenticationHelper()
                        .signUp(email: email!, password: password!)
                        .then((result) {
                      if (result == null) {
                        Map<String, Object> city = new HashMap<String,Object>();
                        final Map<String, Object> newMap;
                        print(CorrectTeacherCode);

                        if (character.toString() == "Character.student") {
                          newMap = {
                            "Students": {
                              "email": email,
                              "password": password,
                              "account": AuthenticationHelper().uid,
                            },
                          };
                          db.collection("users.Students").doc(AuthenticationHelper().uid).set(newMap);

                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => MyHomePage(character, 'My Home Page')));
                        }
                        else if (character.toString() == "Character.teacher") {
                          if (Teachercode == CorrectTeacherCode) {
                            newMap = {
                              "Teachers": {
                                "name" : "Jack Wagner",
                                "email": email,
                                "password": password,
                                "account": AuthenticationHelper().uid,
                                "image" : "https://cdn.discordapp.com/attachments/1070956419949535272/1134368270301016064/istockphoto-75940775-612x612.jpg"

                              },
                            };

                            db.collection("users.Teachers").doc(AuthenticationHelper().uid).set(newMap);


                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => teacherQuestion(character, AuthenticationHelper().uid, email, password)));
                          }
                          else {
                            AuthenticationHelper().currentUser.delete();
                          }


                        }
                        else if (character.toString() == "Character.parent") {
                          newMap = {
                            "Parents": {
                              "email": email,
                              "password": password,
                              "account": AuthenticationHelper().uid,
                            },
                          };
                          db.collection("users.Parents").doc(AuthenticationHelper().uid).set(newMap);


                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => MyHomePage(character, 'My Home Page')));
                        }
                        else {
                          newMap = {};

                          print("I'm a Guest");
                          db.collection("users").doc(AuthenticationHelper().uid).set(newMap);


                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => MyHomePage(character, 'My Home Page')));

                        }


                      }
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            result,
                            style: TextStyle(fontSize: 16),
                          ),
                        ));
                      }
                    });
                  },
                  child: Text("Sign up",
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
              // const SizedBox(height: 5,),
              // Text("-or-",
              //   style: TextStyle(
              //     fontWeight: FontWeight.w800,
              //     color: Colors.black,
              //     fontSize: 15,
              //     fontFamily: "Merriweather",
              //   ),
              // ),
              //const SizedBox(height: 5,),
              // SizedBox(
              //   height: 50,
              //   width: 500,
              //   child: ElevatedButton(
              //     onPressed: (){
              //       AuthService().signInWithGoogle();
              //     },
              //     child: Text("Continue With Google",
              //       style: TextStyle(
              //         fontWeight: FontWeight.w800,
              //         color: Colors.white,
              //         fontSize: 20,
              //         fontFamily: "Metropolis",
              //       ),
              //     ),
              //     style: ElevatedButton.styleFrom(
              //       elevation: 5.0,
              //       backgroundColor: Colors.lightBlue[900],
              //       shadowColor: Colors.transparent,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(20),
              //         side: BorderSide(
              //           color: Colors.transparent,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

