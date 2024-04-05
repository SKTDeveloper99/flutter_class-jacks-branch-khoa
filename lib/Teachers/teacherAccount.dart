import 'package:flutter/material.dart';
import 'package:flutter_class/Accounts/account.dart';
import 'package:flutter_class/class.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_class/guessClasses.dart';
import '../Accounts/authentication.dart';
import '../buyclass.dart';
import '../firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../welcome.dart';


class TeacherProfile extends StatefulWidget {

  // const MyHomePage({super.key, required this.title});
  late final String UID;
  TeacherProfile(this.UID);
  @override
  State<TeacherProfile> createState() => TeacherProfileState(UID);
}

class TeacherProfileState extends State<TeacherProfile> {
  String name = "";
  String imageURL = "";
  String age = "";
  String skills = "";
  String classes = "";
  String Experience = "";
  String currentTeachingClasses = "";
  String college = "";
  String major = "";

  FirebaseFirestore db = FirebaseFirestore.instance;
  AuthenticationHelper Auth = AuthenticationHelper();

  late final String teacher;
  TeacherProfileState(this.teacher) {
    refreshTeachers();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchData() async {
    // Replace 'collectionName' with your actual collection name
    DocumentSnapshot<Map<String, dynamic>> snapshot = await db.collection("users.Teachers").doc(teacher).get();

    return snapshot;
  }

  void refreshTeachers() {

    db.collection("users.Teachers").doc(teacher).get().then((value) {
      String tmp = "";
      print(value.data());
      tmp = value.data()?["Teachers"]["name"];
      name = tmp;
      tmp = value.data()?["Teachers"]["age"];
      age = tmp;
      imageURL = value.data()?["Teachers"]["image"];
      Experience = value.data()?["Teachers"]["experience"];
      college = value.data()?["Teachers"]["college"];
      currentTeachingClasses = value.data()?["Teachers"]["currentClasses"];
      major = value.data()?["Teachers"]["major"];
      skills = value.data()?["Teachers"]["skills"];
      classes = value.data()?["Teachers"]["classes"];
    });
    print("hello");
    print(name + age + imageURL + Experience + college + currentTeachingClasses + major + skills + classes);

  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    //
  }


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
       // automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: fetchData(), // Call your fetchData function here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Display a loading indicator while waiting for data
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data')); // Display an error message if data fetching fails
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available')); // Display a message if no data is available
          } else {
            // Build your UI using the fetched data
            // You can access the data using snapshot.data
            final data = snapshot.data!.data(); // Extract the data from the DocumentSnapshot
            Map<String, dynamic> userData = data?["Teachers"];
            // Example: Display a text widget with a value from Firestore
       
          return  Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 16.0),

                  Center(
                    child: CircleAvatar(
                      radius: 100.0,
                      backgroundImage: NetworkImage(userData['image']),
                    ),
                  ),
                  SizedBox(height: 40.0),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Text(
                        'Name: ${userData['name']}',
                        style: TextStyle(
                          fontFamily: 'Metropolis', // Assuming you've added the Metropolis font
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.0),

                      Text(
                        'Email: ${userData['email']}',
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(height: 16.0),

                      Text(
                        'Age: ${userData['age']}',
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(height: 16.0),

                      Text(
                        'College: ${userData['college']}',
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(height: 16.0),

                      Text(
                        'Major: ${userData['major']}',
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(height: 16.0),

                      Text(
                        'Experience: ${userData['experience']}',
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(height: 16.0),

                      Text(
                        'Skills: ${userData['skills']}',
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(height: 16.0),

                      Text(
                        'Current Classes: ${userData['currentClasses']}',
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontSize: 20.0,
                        ),
                        maxLines: 3, // Wraps text to a maximum of 3 lines
                        overflow: TextOverflow.ellipsis, // Shows ellipsis if the text overflows
                      ),
                      SizedBox(height: 40.0),

                      ElevatedButton(onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Settingbody()));

                      }, child: Text("Hire Me"),)
                    ],
                  ),
                ],
              ),
            ),
            );
          }
        },
      ),


    );
  }
}