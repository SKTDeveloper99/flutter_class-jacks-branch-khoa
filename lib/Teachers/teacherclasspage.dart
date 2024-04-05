import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_class/Accounts/authentication.dart';
import 'package:flutter_class/Teachers/questionare.dart';
import 'package:flutter_class/welcome.dart';
import 'package:flutter_class/widgets.dart';

class Tcp extends StatefulWidget {

  late final String classID;
  Tcp(this.classID);
  @override
  State<Tcp> createState() => TcpState(classID);

}

class TcpState extends State<Tcp> with SingleTickerProviderStateMixin{
  List<Widget> homework = [];
  List<Widget> classmaterials = [];
  List<Widget> students = [];
  FirebaseFirestore db = FirebaseFirestore.instance;
  AuthenticationHelper Auth = AuthenticationHelper();
  late TabController _tabController;
  String classID = "";
  TcpState(this.classID);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void refreshDeliverables() {

    setState(() {
      List<TeacherHomework> tmpHW = [];
      List<ClassMaterial> tmpMats = [];
      db.collection("classes").doc(this.classID).collection("HW").get().then((value) {
        for (var x in value.docs){
          tmpHW.add(
              TeacherHomework(x.data()!["title"], x.data()!["description"], x.data()!["date"],this.classID)
          );
        }
      });

      db.collection("classes").doc(this.classID).collection("CM").get().then((value) {
        for (var x in value.docs){
          tmpMats.add(
              ClassMaterial(x.data()!["title"], x.data()!["description"], x.data()!["file"], classID)
          );
        }
      });

      homework = tmpHW;
      classmaterials = tmpMats;
    });


  }
  void addDeliverables() {

    setState(() {
      final Map<String, Object> newMap = {
        "TeacherName": "emily",
        "Zoom Link": "1234",
      };
      final Map<String, Object> classMap = {
        "TeacherName": "Jack Wagner",
        "Zoom Link": "1234",
      };
      db.collection("classes").doc(this.classID).collection("HW").doc("alegbra").set(classMap);




    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchHW() async {
    // Replace 'collectionName' with your actual collection name
    QuerySnapshot<Map<String, dynamic>> snapshot = (await db.collection(
        "classes").doc(this.classID)
        .collection("HW")
        .get());
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchCM() async {
    // Replace 'collectionName' with your actual collection name

    Future<QuerySnapshot<Map<String, dynamic>>>  snapshot2 = db
        .collection("classes")
        .doc(this.classID)
        .collection("CM")
        .get();

    return snapshot2;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchStudents() async {
    // Replace 'collectionName' with your actual collection name

    Future<QuerySnapshot<Map<String, dynamic>>>  snapshot2 = db
        .collection("classes")
        .doc(this.classID)
        .collection("Students")
        .get();

    return snapshot2;
  }




  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    refreshDeliverables();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        toolbarHeight: 30,
        bottom: TabBar(
          controller: _tabController, // Assign the TabController
          indicatorColor: Colors.white,
          labelStyle: TextStyle(fontFamily: "Metropolis", fontSize: 17),
          tabs: [

            Tab(text: 'Homework'),
            Tab(text: 'Class Material',),
            Tab(text: 'Students',),
          ],
        ),
      ),
      body: TabBarView(
          controller: _tabController, // Assign the TabController
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
               FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    future: fetchHW(), // Call your fetchData function here
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
                        List<TeacherHomework> tmpHW = [];

                          for (var x in data.docs) {

                            tmpHW.add(
                                TeacherHomework(x.data()!["title"],
                                    x.data()!["description"], x.data()!["date"],
                                    this.classID)
                            );
                          }
                          homework = tmpHW;
                        return Container(
                          height: height/1.3,
                          width: width,
                          child: ListView(
                            children: homework,
                          ),
                        );}}),
              ],
            ),
            // Widgets for Tab 1
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    future: fetchCM(), // Call your fetchData function here
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
                        List<ClassMaterial> tmpMats = [];

                        for (var x in data.docs) {

                          tmpMats.add(
                              ClassMaterial(x.data()!["title"], x.data()!["description"], x.data()!["file"], classID)
                          );
                        }
                        classmaterials = tmpMats;
                        return Container(
                          height: height/1.3,
                          width: width,
                          child: ListView(
                            children: classmaterials,
                          ),
                        );}}),

              ],
            ),
            // Widgets for Tab 2
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    future: fetchStudents(), // Call your fetchData function here
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
                        List<Students> tmpStudents = [];

                        for (var x in data.docs) {
                          print(x.id);
                          tmpStudents.add(
                              Students(x.id)
                          );
                        }
                        students = tmpStudents;
                        return Container(
                          height: height/1.3,
                          width: width,
                          child: ListView(
                            children: students,
                          ),
                        );}}),

              ],
            ),
          ]
      ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[100],
          onPressed: () {
            setState(() {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Questionnaire'),
                    content: QuestionnaireForm(this.classID), // Display the form here
                  );
                },
              );
            });

          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        )
    );
  }
}
