import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_class/Accounts/authentication.dart';
import 'package:flutter_class/welcome.dart';
import 'package:flutter_class/widgets.dart';

class Classbody extends StatefulWidget {
  late final Character character;
  Classbody(this.character);
  @override
  State<Classbody> createState() => _ClassbodyState(character);

}

class _ClassbodyState extends State<Classbody> {
  List<String> categories = ["Nonprofit Classes", "Art Class", "English Class", "Math Class", "Computer Science Class"];
  List<Widget> classes = [];
  FirebaseFirestore db = FirebaseFirestore.instance;
  AuthenticationHelper Auth = AuthenticationHelper();
  late final Character character;
  String currentAccount = "users.Students";


  _ClassbodyState(this.character){
    if (character.toString() == "Character.student") {
      currentAccount = "users.Students";
    }
    else if (character.toString() == "Character.teacher") {
      currentAccount = "users.Teachers";
    }
    else if (character.toString() == "Character.parent") {
      currentAccount = "users.Parents";

    }
    else if (character.toString() == "Character.guest"){
      currentAccount = "users.guest";

    }
    refreshClasses();
  }



  void refreshClasses() {

    db.collection(currentAccount).doc(AuthenticationHelper().uid).collection("classes").get().then((querySnapshot) {
      List<Classess> tmpClasses = [];
      for (var i in querySnapshot.docs) {
        //i.id.toString() == the class id number
        db.collection("classes").doc(i.id.toString()).get().then((value) {
           tmpClasses.add(Classess(
            character,
            i.id.toString(),
            value.data()!["name"].toString(),
            value.data()!["teacherName"].toString(),
            value.data()!["zoomLink"].toString(),
            value.data()!["image"].toString(),

          ));
        });
      }
      classes = tmpClasses;
    });

  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchClass() async {



      QuerySnapshot<Map<String, dynamic>> snapshot = (await db.collection(currentAccount).doc(AuthenticationHelper().uid).collection("classes").get());

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchClasses() async {
    // Replace 'collectionName' with your actual collection name
    QuerySnapshot<Map<String, dynamic>> snapshot = (await db.collection(currentAccount).doc(AuthenticationHelper().uid).collection("classes").get());

    return snapshot;
  }




  void _incrementCounter() {
    setState(() {
      final Map<String, Object> newMap = {
          "TeacherName": "emily",
          "Zoom Link": "1234",
        };
      final Map<String, Object> classMap = {
        "TeacherName": "Jack Wagner",
        "Zoom Link": "1234",
      };
      db.collection("users").doc(AuthenticationHelper().uid).collection("classes").doc("alegbra").set(classMap);




    });
        }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: fetchClasses(), // Call your fetchData function here
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
                  final data = snapshot.data!;
                  return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      future: fetchClass(), // Call your fetchData function here
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
                          final data = snapshot.data!;
                          List<Classess> tmpClasses = [];
                          refreshClasses();

                          // Extract the data from the DocumentSnapshot
                          return Container(
                            height: height / 1.3,
                            width: width,
                            child: ListView(
                              children: classes,
                            ),
                          );
                        }
    });}}),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[100],
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      )
    );
  }
  }
