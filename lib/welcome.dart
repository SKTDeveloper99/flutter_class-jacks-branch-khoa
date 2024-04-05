import 'package:flutter/material.dart';

import 'Accounts/login.dart';
import 'main.dart';

class Kat extends StatefulWidget {

  @override
  State<Kat> createState() => _KatState();
}
enum Character {teacher, student, parent, guest}
class _KatState extends State<Kat> {
  Character? _character = Character.student;
  bool isGuest = false;
  bool isStudent = true;
  bool isTeacher = false;
  bool isParent = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(width);


    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          )
        ),
        toolbarHeight: height/5,
        backgroundColor: Colors.blue[100],
        bottomOpacity: 0,
        elevation: 0,
        title:
        Padding(
          padding: const EdgeInsets.only(top: 0.0,),
          child: Image.asset(
              "assets/logo.PNG",
              width: width/3,
          )
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Sign In, Create a Account, or Browse as a Teacher, Student, Parent, or Guest",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: height/43,
                  fontFamily: "Merriweather",
                ),
              ),
              const SizedBox(height: 5,),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: Colors.black,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: RadioListTile<Character>(
                    title: Text(
                      "Student",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        fontFamily: "Merriweather",
                      ),
                    ),
                    subtitle: Text(
                      "Signing in to access classes and homework",
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: "Merriweather",
                      ),
                    ),
                    secondary: Icon(
                      Icons.school,
                      color: Colors.blue[100],
                      size: 50,
                    ),
                    value: Character.student,
                    groupValue: _character,
                    onChanged: (Character? value){
                      setState(() {
                        isStudent = true;
                        isTeacher = false;
                        _character = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 5,),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: Colors.black,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: RadioListTile<Character>(
                    title: Text(
                      "Teacher",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        fontFamily: "Merriweather",
                      ),
                    ),
                    subtitle: Text(
                      "Signing in to manage classes and homework",
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: "Merriweather",
                      ),
                    ),
                    secondary: Icon(
                      Icons.assignment_ind,
                      color: Colors.blue[100],
                      size: 50,
                    ),
                    value: Character.teacher,
                    groupValue: _character,
                    onChanged: (Character? value){
                      setState(() {
                        isStudent = false;
                        isTeacher = true;
                        _character = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 5,),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: Colors.black,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: RadioListTile<Character>(
                    title: Text(
                      "Guest",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        fontFamily: "Merriweather",
                      ),
                    ),
                    subtitle: Text(
                      "To explore options and browse teachers",
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: "Merriweather",
                      ),
                    ),
                    secondary: Icon(
                      Icons.perm_identity,
                      color: Colors.blue[100],
                      size: 50,
                    ),
                    value: Character.guest,
                    groupValue: _character,
                    onChanged: (Character? value){
                      setState(() {
                        isStudent = false;
                        isGuest = true;
                        isTeacher = false;
                        _character = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 5,),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: Colors.black,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: RadioListTile<Character>(
                    title: Text(
                      "Parent",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        fontFamily: "Merriweather",
                      ),
                    ),
                    subtitle: Text(
                      "Signing in to explore classes or purchase classes",
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: "Merriweather",
                      ),
                    ),
                    secondary: Icon(
                      Icons.escalator_warning,
                      color: Colors.blue[100],
                      size: 50,
                    ),
                    value: Character.parent,
                    groupValue: _character,
                    onChanged: (Character? value){
                      setState(() {
                        isStudent = false;
                        isTeacher = false;
                        isParent = true;
                        _character = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 5,),
            SizedBox(
              height: 50,
              width: 500,
              child: ElevatedButton(
                onPressed: () {
                  if (_character == Character.guest) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(_character!, 'My Home Page'),
                      ),
                    );
                  }
                  else {
                    print(_character.toString());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(_character!),
                      ),
                    );
                  }
                },
                child: Text("Continue",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "Merriweather",
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
            ],
          ),
        ),
      ),
    );
  }
}
