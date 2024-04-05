
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_class/Teachers/submission.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:flutter_class/availableTeachers.dart';
import 'package:flutter_class/studentclasspage.dart';
import 'package:flutter_class/Teachers/teacherAccount.dart';
import 'package:flutter_class/Teachers/teacherclasspage.dart';
import 'package:flutter_class/welcome.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'Accounts/authentication.dart';

class Classess extends StatelessWidget {
  late final String title;
  late final String teacher;
  late final String zoom;
  late final Object image;
  late final String classID;
  late final Character character;
  List<dynamic> myJson = [];

  Classess(this.character, this.classID, this.title, this.teacher, this.zoom, this.image);

  Map<String, String> toMap() {
    return {
      'title': title,
      'teacher': teacher,
      'zoom': zoom,
    };
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (character.toString() == "Character.student") {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Scp(this.classID)));
        }
        if (character.toString() == "Character.parent") {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Scp(this.classID)));
        }
        else if (character.toString() == "Character.teacher") {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Tcp(this.classID)));

        }


      },
      child: Container(
        margin: EdgeInsets.all(10),
        height: 150,
        width: 300,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.transparent,),
          borderRadius: BorderRadius.circular(12),
          color: Colors.blue[100],
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 100,
                width: 600,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1, color: Colors.transparent),
                  ),
          
                  //borderRadius: BorderRadius.circular(5),
                  image: const DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        "https://marketplace.canva.com/EAETAUs3jxE/1/0/1600w/canva-chalkboard-classroom-banner-z7u1_YG6SwM.jpg"),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                  Text(title, style: TextStyle(
                    fontSize: 20
                  ),),
                  SizedBox(width: 100,),
                  Text(teacher), SizedBox(width: 20,),
          
                    Text(zoom),
                ],)
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TeacherHomework extends StatelessWidget {
  late final String title;
  late final String description;
  late final String date;
  late final String classID;
  List<dynamic> myJson = [];

  TeacherHomework(this.title, this.description, this.date, this.classID);

  Map<String, String> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
    };
  }

  File? _selectedPDF;
  FirebaseFirestore db = FirebaseFirestore.instance;
  AuthenticationHelper Auth = AuthenticationHelper();

  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      _selectedPDF = File(result.files.single.path!);
    }
  }


  Future<void> _uploadPDF() async {
    if (_selectedPDF != null) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.pdf';


      final storageRef = FirebaseStorage.instance.ref();

      final mountainsRef = storageRef.child(fileName);

      try {
        await mountainsRef.putFile(_selectedPDF!);
      } catch (e) {
        print(e);
      }
      String downloadURL = await mountainsRef.getDownloadURL();
      //We would want to save this into the user account we are currently on so that we can
      //refrence it later for the teacher to do feedback
      Map<String, String> studentlink = new Map<String,String>();
      studentlink[Auth.getUID()] = downloadURL;
      db.collection("classes").doc(this.classID).collection("HW").doc(title).collection("submissions").add(studentlink);
      /*
      firebase_storage.Reference reference =
      firebase_storage.FirebaseStorage.instance.ref().child(fileName);

      await reference.putFile(_selectedPDF!);
      String downloadURL = await reference.getDownloadURL();

      // Now you have the download URL, you can store this in your database or use it as needed.

      print('PDF uploaded. Download URL: $downloadURL');
*/
    }
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Submission(this.classID,this.title)));
      },
      child: Container(
        margin: EdgeInsets.all(10),
        height: 150,
        width: 300,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.transparent,),
          borderRadius: BorderRadius.circular(12),
          color: Colors.blue[100],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.check_circle, color: Colors.red, size: 30,),
                SizedBox(width: 10,),
                Text(title, style: TextStyle(
                  fontSize: 40,
                  fontFamily: "Metropolis",
                ),),
              ],
            ),
            Divider(
              color: Colors.black,
              thickness: 3,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(date,style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Merriweather",
                ),),
                Text(description,style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Merriweather",
                ),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StudentSubmission extends StatelessWidget {
  late final String uid;
  late final String link;
  String title = "";
  String classID = "";
  String email = "";
  FirebaseFirestore db = FirebaseFirestore.instance;
  AuthenticationHelper Auth = AuthenticationHelper();
  List<dynamic> myJson = [];

  StudentSubmission(this.uid, this.link, this.title, this.classID) {
    db.collection("users.Students").doc(this.uid).get().then((value) {
      if (value?["email"] != null) {
        email = value?["email"];
      }

    });


  }

  File? _selectedPDF;

  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      _selectedPDF = File(result.files.single.path!);
    }
  }


  Future<void> _uploadPDF() async {
    if (_selectedPDF != null) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.pdf';

      final storageRef = FirebaseStorage.instance.ref();

      final mountainsRef = storageRef.child(fileName);

      try {
        await mountainsRef.putFile(_selectedPDF!);
      } catch (e) {
        print(e);
      }
      String downloadURL = await mountainsRef.getDownloadURL();
      //We would want to save this into the user account we are currently on so that we can
      //refrence it later for the teacher to do feedback
      Map<String, String> studentlink = new Map<String,String>();
      studentlink[Auth.getUID()] = downloadURL;

      db.collection("classes").doc(this.classID).collection("HW").doc(title).collection("submissions").doc(this.uid).update({
        "feedback" : downloadURL
      });
      /*
      firebase_storage.Reference reference =
      firebase_storage.FirebaseStorage.instance.ref().child(fileName);

      await reference.putFile(_selectedPDF!);
      String downloadURL = await reference.getDownloadURL();

      // Now you have the download URL, you can store this in your database or use it as needed.

      print('PDF uploaded. Download URL: $downloadURL');
*/
    }
  }





  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 150,
      width: 300,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.transparent,),
        borderRadius: BorderRadius.circular(12),
        color: Colors.blue[100],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.check_circle, color: Colors.red, size: 30,),
              SizedBox(width: 10,),
              Text(email, style: TextStyle(
                fontSize: 15,
                fontFamily: "Metropolis",
              ),),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () {
                db.collection("classes").doc(this.classID).collection("HW").doc(title).collection("submissions").doc(this.uid).update({
                  "submitted" : true
                });
                final Uri url = Uri.parse(link);
                launchUrl(url);
              }, child: Text("Recieve HW")),
              SizedBox(width: 50,),
              ElevatedButton(onPressed: () {
                _pickPDF(); _uploadPDF();

              }, child: Text("Upload Feedback"))
            ],
          )
        ],
      ),
    );
  }
}

class Homework extends StatelessWidget {
  late final String title;
  late final String description;
  late final String date;
  bool submitted = false;
  late final String classID;
  List<dynamic> myJson = [];

  Homework(this.title, this.description, this.date, this.classID) {
    db.collection("classes").doc(this.classID).collection("HW").doc(title).collection("submissions").doc(Auth.getUID()).get().then((value) {
      if (value?["submitted"] != null && value?["submitted"] == true) {
        submitted = true;

      }
    });

  }

  Map<String, String> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
    };
  }

  File? _selectedPDF;
  FirebaseFirestore db = FirebaseFirestore.instance;
  AuthenticationHelper Auth = AuthenticationHelper();

  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      _selectedPDF = File(result.files.single.path!);
    }
  }


  Future<void> _uploadPDF() async {
    if (_selectedPDF != null) {

      String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.pdf';


      final storageRef = FirebaseStorage.instance.ref();

      final mountainsRef = storageRef.child(fileName);

      try {
        await mountainsRef.putFile(_selectedPDF!);
      } catch (e) {
        print(e);
      }
      String downloadURL = await mountainsRef.getDownloadURL();
      Map<String, Object> studentlink = new Map<String,Object>();
      studentlink[Auth.getUID()] = downloadURL;
      studentlink["submission"] = false;
     db.collection("classes").doc(this.classID).collection("HW").doc(title).collection("submissions").doc(Auth.getUID()).set(studentlink);
    }
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (submitted) {
          db.collection("classes").doc(this.classID).collection("HW").doc(title).collection("submissions").doc(Auth.getUID()).get().then((value) {
            final Uri url = Uri.parse(value["feedback"]);
            launchUrl(url);
          });


        }
        else {
          _pickPDF(); _uploadPDF();

        }

        },
      child: Container(
        margin: EdgeInsets.all(10),
        height: 150,
        width: 300,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.transparent,),
          borderRadius: BorderRadius.circular(12),
          color: Colors.blue[100],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.check_circle, color: submitted ? Colors.green : Colors.red, size: 30,),
                SizedBox(width: 10,),
                Text(title, style: TextStyle(
                  fontSize: 40,
                  fontFamily: "Metropolis",
                ),),
              ],
            ),
            Divider(
                color: Colors.black,
              thickness: 3,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(date,style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Merriweather",
                ),),
                Text(description,style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Merriweather",
                ),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ClassMaterial extends StatelessWidget {
  late final String title;
  late final String description;
  late final String file;
  String classID;
  List<dynamic> myJson = [];
  bool thefile = false;
  File? _selectedPDF;
  FirebaseFirestore db = FirebaseFirestore.instance;
  AuthenticationHelper Auth = AuthenticationHelper();


  ClassMaterial(this.title, this.description, this.file, this.classID) {
    db.collection("classes").doc(this.classID).collection("CM").doc(title).get().then((value){
      if (value?["file"] != "") {
        thefile = true;
      }
    });
  }


  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      _selectedPDF = File(result.files.single.path!);
    }
  }


  Future<void> _uploadPDF() async {
    if (_selectedPDF != null) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.pdf';

      final storageRef = FirebaseStorage.instance.ref();

      final mountainsRef = storageRef.child(fileName);

      try {
        await mountainsRef.putFile(_selectedPDF!);
      } catch (e) {
        print(e);
      }
      String downloadURL = await mountainsRef.getDownloadURL();
      //We would want to save this into the user account we are currently on so that we can
      //refrence it later for the teacher to do feedback
      Map<String, String> studentlink = new Map<String,String>();
      studentlink[Auth.getUID()] = downloadURL;
      db.collection("classes").doc(this.classID).collection("CM").doc(title).update({
        "file" : downloadURL
      });
    }
  }



  Map<String, String> toMap() {
    return {
      'title': title,
      'description': description,
      'Attachment': file,
    };
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _pickPDF(); _uploadPDF();

      },
      child: Container(
        margin: EdgeInsets.all(10),
        height: 150,
        width: 300,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.transparent,),
          borderRadius: BorderRadius.circular(12),
          color: Colors.blue[100],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.check_circle, color: thefile ? Colors.red : Colors.green, size: 30,),
                SizedBox(width: 10,),
                Text(title, style: TextStyle(
                  fontSize: 40,
                  fontFamily: "Metropolis",
                ),),
              ],
            ),
            Divider(
              color: Colors.black,
              thickness: 3,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(description,style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Merriweather",
                ),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StudentClassMaterial extends StatelessWidget {
  late final String title;
  late final String description;
  late final String file;
  String classID;
  List<dynamic> myJson = [];

  File? _selectedPDF;
  FirebaseFirestore db = FirebaseFirestore.instance;
  AuthenticationHelper Auth = AuthenticationHelper();


  StudentClassMaterial(this.title, this.description, this.file, this.classID);


  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      _selectedPDF = File(result.files.single.path!);
    }
  }


  Future<void> _uploadPDF() async {
    if (_selectedPDF != null) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.pdf';

      final storageRef = FirebaseStorage.instance.ref();

      final mountainsRef = storageRef.child(fileName);

      try {
        await mountainsRef.putFile(_selectedPDF!);
      } catch (e) {
        print(e);
      }
      String downloadURL = await mountainsRef.getDownloadURL();
      //We would want to save this into the user account we are currently on so that we can
      //refrence it later for the teacher to do feedback
      Map<String, String> studentlink = new Map<String,String>();
      studentlink[Auth.getUID()] = downloadURL;
      db.collection("classes").doc(this.classID).collection("HW").doc(title).collection("submissions").add(studentlink);
      /*
      firebase_storage.Reference reference =
      firebase_storage.FirebaseStorage.instance.ref().child(fileName);

      await reference.putFile(_selectedPDF!);
      String downloadURL = await reference.getDownloadURL();

      // Now you have the download URL, you can store this in your database or use it as needed.

      print('PDF uploaded. Download URL: $downloadURL');
*/
    }
  }



  Map<String, String> toMap() {
    return {
      'title': title,
      'description': description,
      'Attachment': file,
    };
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        db.collection("classes").doc(this.classID).collection("CM").doc(title).get().then((value) {
         if (value["file"] != "") {
           final Uri url = Uri.parse(value["file"]);
           launchUrl(url);
         }

        });
      },
      child: Container(
        margin: EdgeInsets.all(10),
        height: 150,
        width: 300,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.transparent,),
          borderRadius: BorderRadius.circular(12),
          color: Colors.blue[100],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.check_circle, color: Colors.red, size: 30,),
                SizedBox(width: 10,),
                Text(title, style: TextStyle(
                  fontSize: 40,
                  fontFamily: "Metropolis",
                ),),
              ],
            ),
            Divider(
              color: Colors.black,
              thickness: 3,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(description,style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Merriweather",
                ),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Students extends StatelessWidget {
  late final String uid;
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<dynamic> myJson = [];

  Students(this.uid);

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchStudent() async {
    // Replace 'collectionName' with your actual collection name
    print(this.uid);
    Future<DocumentSnapshot<Map<String, dynamic>>>  snapshot2 = db
        .collection("users.Students")
        .doc(this.uid)
        .get();

    return snapshot2;
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

      },
      child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: fetchStudent(), // Call your fetchData function here
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child:
                  CircularProgressIndicator()); // Display a loading indicator while waiting for data
            } else if (snapshot.hasError) {
              return Center(
                  child: Text(
                      'Error fetching data')); // Display an error message if data fetching fails
            } else if (!snapshot.hasData) {
              return Center(
                  child: Text(
                      'No data available')); // Display a message if no data is available
            } else {
              // Build your UI using the fetched data
              // You can access the data using snapshot.data
              final data = snapshot.data!.data()?["Students"];

              String email = "";
              if (data?["email"] != null) {
                email = data?["email"];
              }



              return Container(
                margin: EdgeInsets.all(10),
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.transparent,),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blue[100],
                ),
                child: Column(
                  children: [

                    Container(
                        margin: EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 10,),
                            Text(email, style: TextStyle(
                                fontSize: 20
                            ),),

                          ],)
                    ),
                  ],
                ),
              );}}),

    );
  }
}

class Anouncement extends StatelessWidget {
  late final String title;
  late final String description;
  late final String date;
  List<dynamic> myJson = [];

  Anouncement(this.title, this.description, this.date);

  Map<String, String> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
    };
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => Scp()));
      },
      child: Container(
        margin: EdgeInsets.all(10),
        height: 150,
        width: 300,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.transparent,),
          borderRadius: BorderRadius.circular(12),
          color: Colors.blue[100],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(
                  fontSize: 40,
                  fontFamily: "Metropolis",
                ),),
              ],
            ),
            Divider(
              color: Colors.black,
              thickness: 3,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(date,style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Merriweather",
                ),),
                Text(description,style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Merriweather",
                ),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Course extends StatelessWidget {
  late final String title;

  List<dynamic> myJson = [];

  Course(this.title);

  Map<String, String> toMap() {
    return {
      'title': title,
    };
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => availableTeachers(this.title)));
      },
      child: Container(
        margin: EdgeInsets.all(10),
        height: 50,
        width: 300,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.transparent,),
          borderRadius: BorderRadius.circular(12),
          color: Colors.blue[100],
        ),
        child: Center(
          child: Text(title, style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontFamily: "Metropolis",
          ),),
        ),
      ),
    );
  }
}

class Teacher extends StatelessWidget {
  late final String UID;
  late final String name;

  List<dynamic> myJson = [];

  Teacher(this.UID, this.name);

  Map<String, String> toMap() {
    return {
      'title': UID,
    };
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TeacherProfile(this.UID)));
      },
      child: Container(
        margin: EdgeInsets.all(10),
        height: 50,
        width: 300,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.transparent,),
          borderRadius: BorderRadius.circular(12),
          color: Colors.blue[100],
        ),
        child: Center(
          child: Text(name, style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontFamily: "Metropolis",
          ),),
        ),
      ),
    );
  }
}