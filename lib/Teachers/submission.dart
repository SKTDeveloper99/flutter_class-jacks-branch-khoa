import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_class/Accounts/authentication.dart';
import 'package:flutter_class/welcome.dart';
import 'package:flutter_class/widgets.dart';

class Submission extends StatefulWidget {
  String currentAccount = "users.Students";
  String classID = "";
  String title = "";



  Submission(this.classID, this.title);
  @override
  State<Submission> createState() => SubmissionState(this.classID, this.title);

}

class SubmissionState extends State<Submission> {
  List<String> categories = ["Nonprofit Classes", "Art Class", "English Class", "Math Class", "Computer Science Class"];
  List<Widget> Submissions = [];
  FirebaseFirestore db = FirebaseFirestore.instance;
  AuthenticationHelper Auth = AuthenticationHelper();
  late final Character character;
  String currentAccount = "users.Teachers";
  String classID = "";
  String title = "";



  SubmissionState(this.classID, this.title){


  }


  //

  void refreshClasses() {

    db.collection("classes").doc(this.classID).collection("HW").doc(title).collection("submissions").get().then((value) {
      for (var x in value.docs){
        Submissions.add(StudentSubmission(x.id, x.data()?[x.id],title, classID));
      }
    });


  }


  Future<QuerySnapshot<Map<String, dynamic>>> fetchSubmissions() async {
    // Replace 'collectionName' with your actual collection name

    Future<QuerySnapshot<Map<String, dynamic>>>  snapshot2 = db.collection("classes").doc(this.classID).collection("HW").doc(title).collection("submissions").get();


      return snapshot2;
  }



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(

      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: fetchSubmissions(), // Call your fetchData function here
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
                  // Extract the data from the DocumentSnapshot
                  for (var x in data.docs){
                    print(x.id);
                    Submissions.add(StudentSubmission(x.id, x.data()?[x.id],title, classID));
                  }
                  return Container(
                    height: height/1.3,
                    width: 300,
                    child: ListView(
                      children: Submissions,
                    ),
                  );
                }
              }
              ),

          // Container(
          //   height: 600,
          //   width: 300,
          //   child: ListView(
          //     children: Submissions,
          //   ),
          // )
        ],
      ),
    );
  }
}
